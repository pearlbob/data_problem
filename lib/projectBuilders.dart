//
import 'package:build/build.dart';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';

/*
run a compile service locally:

flutter pub run build_runner watch --delete-conflicting-outputs

*/

class CodeBuilder implements Builder {
  @override
  final buildExtensions = const {
    '.dart': ['.g.dart']
  };

  /// generate the boilerplate code for the given input class data structure
  @override
  Future build(BuildStep buildStep) async {
    // Get the `LibraryElement` for the primary input.
    var entryLib = await buildStep.inputLibrary;

    // Resolves all libraries reachable from the primary input.
    // var resolver = buildStep.resolver;

    var info = buildStep.inputId.changeExtension('.g.dart');

    var elements = allElements(entryLib);

    var sb = StringBuffer();
    for (var e in elements) {
      sb.writeln(_generateImmutableClass(entryLib, e));
      sb.writeln(_generateMutableClass(entryLib, e));
    }

    await buildStep.writeAsString(info, '''
//  generated code
//  do not change by hand!

import 'package:meta/meta.dart';
import '../mutableReady.dart';

// Input ID: ${buildStep.inputId}

$sb
''');
  }

  //  a bit of dart stream magic
  Iterable<Element> allElements(LibraryElement element) sync* {
    for (var cu in element.units) {
      yield* cu.typeAliases;
      yield* cu.functions;
      yield* cu.mixins;
      yield* cu.topLevelVariables;
      yield* cu.types;
    }
  }

  ///  generate the code for the immutable version of the data structure
  String _generateImmutableClass(LibraryElement entryLib, Element e) {
    var fields = entryLib.getType(e.name ?? '')?.fields ?? [];
    var sb = StringBuffer();

    //  declare class and default constructor
    sb.write('''
/// generated Immutable class for the ${e.name} class model
@immutable
class Immutable${e.name} implements ImmutableReady<${e.name}> {
  Immutable${e.name}(''');

    //  list all fields in the constructor
    var first = true;
    for (var field in fields) {
      if (first) {
        first = false;
      } else {
        sb.write(', ');
      }
      sb.write('this.${field.name}');
    }
    sb.writeln(');');
    sb.writeln();

    /// simple promotion to mutable
    //  declare class and default constructor
    sb.write('''
  @override
  ${e.name} toMutable() {
    return ${e.name}(''');

    //  list all fields in the constructor
    first = true;
    for (var field in fields) {
      if (first) {
        first = false;
      } else {
        sb.write(',\n    ');
      }
      var isImmutable = _isImmutable(field);
      var nullable = _isNullable(field);
      sb.write(isImmutable ? field.name : '${field.name}${nullable ? '?' : ''}.toMutable()');
    }
    sb.write(''');
  }
''');
    sb.writeln();

    //  declare all the fields in the generated class
    for (var field in fields) {
      var type = field.type;
      var isImmutable = _isImmutable(field);
      sb.writeln('  final '
          '${isImmutable ? '' : 'Immutable'}'
          '${type.getDisplayString(withNullability: true)} ${field.name};');
    }

    //  generate a toString() function for convenience
    sb.write('''

  @override
  String toString() {
    return '\$runtimeType{''');
    first = true;
    for (var field in fields) {
      if (first) {
        first = false;
      } else {
        sb.write(',');
      }
      //  there are no accessors available but the final values are fine to use
      sb.write(' ${field.name}: \$${field.name}');
    }
    sb.writeln(''' }\';
  }
''');

    //  generate a operator == function
    sb.write('''
  @override
  bool operator ==(Object o) {
    if (identical(this, o)) {
      return true; //  cheap, deep identical
    }
    if (o is! Immutable${e.name}) {
      if (o is! ${e.name}) {
        return false; //  can never be == if the type is wrong
      }
      o = o.immutable();
    }
    return ''');
    first = true;
    for (var field in fields) {
      if (first) {
        first = false;
      } else {
        sb.write('\n      && ');
      }
      //  note: use private values!  not the accessors
      //  otherwise you will null the immutable copy unintentionally
      sb.write('${field.name} == o.${field.name}');
    }
    sb.write(''';
  }
''');

    //  generate a hashCode function
    sb.write('''

  @override
  int get hashCode => ''');
    first = true;
    for (var field in fields) {
      if (first) {
        first = false;
      } else {
        sb.write('\n      ^ ');
      }
      //  note: use private values!  not the accessors
      sb.write('${field.name}.hashCode');
    }
    sb.write(''';
''');

    sb.write('''}
''');
    return sb.toString();
  }

  //  generate the code for the mutable version of the data structure
  //  capable of generating the immutable version
  String _generateMutableClass(LibraryElement entryLib, Element e) {
    var fields = entryLib.getType(e.name ?? '')?.fields ?? [];
    var sb = StringBuffer();

    //  find all the mutable classes referenced
    var mutableFields = <FieldElement>[];
    for (var field in fields) {
      if (!_isImmutable(field)) {
        mutableFields.add(field);
      }
    }

    //  generate class and its constructor
    sb.write('''
/// generated MutableReady class for the ${e.name} class model
class ${e.name} implements MutableReady<Immutable${e.name}> {
  ${e.name}(''');

    //  list all the fields in the constructor
    var first = true;
    for (var field in fields) {
      if (first) {
        first = false;
      } else {
        sb.write(', ');
      }
      sb.write('this._${field.name}');
    }
    sb.writeln(');');
    sb.writeln();

    /// constructor from immutable
    {
      sb.write('''
  ${e.name}.fromImmutable(Immutable${e.name} immutable${e.name})
    : this(''');

      //  list all the fields in the constructor
      var first = true;
      for (var field in fields) {
        if (first) {
          first = false;
        } else {
          sb.write(',\n    ');
        }
        var isImmutable = _isImmutable(field);
        var isNullable = _isNullable(field);
        sb.write(isImmutable
            ? 'immutable${e.name}.${field.name}'
            : 'immutable${e.name}.${field.name}${isNullable ? '?' : ''}.toMutable()');
      }
      sb.writeln(');');
      sb.writeln();
    }

    //  declare all the fields in the generated class
    for (var field in fields) {
      var type = field.type;
      sb.writeln('''
  //  boiler plate for ${field.name}
  ${type.getDisplayString(withNullability: true)} _${field.name};
  ${type.getDisplayString(withNullability: true)} get ${field.name} => _${field.name};
  set ${field.name}(${type.getDisplayString(withNullability: true)} value) {
    if (_${field.name} != value) {
      _${field.name} = value;
      _immutable${e.name} = null;
    }
  }
''');
    }

    //  adhere to the MutableReady interface by implementing the immutable()
    //  method.
    sb.writeln('''
  Immutable${e.name}? _immutable${e.name}; //  last immutable copy made.
  ''');

    //  provide references to immutable versions of mutable class references
    if (mutableFields.isNotEmpty) {
      sb.writeln('  // storage to monitor MutableReady fields');

      for (var field in mutableFields) {
        sb.writeln('  Immutable${field.type.getDisplayString(withNullability: true)}'
            //  make immutable copies nullable if they are not so naturally
            '${_isNullable(field) ? '' : '?'}'
            ' _lastImmutable_${field.name};');
      }
    }
    sb.write('''

  /// generate an Immutable class for the given ${e.name} when asked
  @override
  Immutable${e.name} immutable() {
''');
    if (mutableFields.isEmpty) {
      //  mutableFields.isEmpty     create a simplified version of immutable()
      sb.write('''
      return _immutable${e.name}
        ??
        (_immutable${e.name} = Immutable${e.name}(''');
      first = true;
      for (var field in fields) {
        if (first) {
          first = false;
        } else {
          sb.write(',');
        }

        if (!_isImmutable(field)) {
          //  member has to be immutable or an implementation of MutableReady!
          sb.write(' _lastImmutable_${field.name}!');
        } else {
          sb.write(' _${field.name}');
        }
      }
      sb.writeln('));');
      sb.writeln('  }');
    } else {
      //  mutableFields.isNotEmpty
      sb.write('''
    if (_immutable${e.name} == null
        //  test if the MutableReady fields have been changed
        //  note that the immutable() calls either are required for the result below
        //  or are inexpensive, especially the second time since they are idempotent.
''');
      for (var field in mutableFields) {
        //  member has to be immutable or an implementation of MutableReady!
        sb.writeln('      || !identical(_lastImmutable_${field.name},'
            ' _${field.name}${_isNullable(field) ? '?' : ''}.immutable())');
      }
      sb.write('''      )
      {   
''');
      //  update the immutable copies
      for (var field in mutableFields) {
        //  member has to be immutable or an implementation of MutableReady!
        sb.writeln('      _lastImmutable_${field.name} = _${field.name}${_isNullable(field)
            ? '?'
            : ''}.immutable();');
      }
      sb.write('''
      _immutable${e.name} = Immutable${e.name}(''');
      first = true;
      for (var field in fields) {
        if (first) {
          first = false;
        } else {
          sb.write(', ');
        }

        //  provide the default constructor the correct argument list
        if (!_isImmutable(field)) {
          //  member has to be immutable or an implementation of MutableReady!
          sb.write('_lastImmutable_${field.name}!');
        } else {
          sb.write('_${field.name}');
        }
      }
      sb.writeln(');');
      sb.writeln('''      }
    return _immutable${e.name}!;
  }
''');
    }

    //  generate a toString() function for convenience
    sb.write('''

  @override
  String toString() {
    return '\$runtimeType{''');
    first = true;
    for (var field in fields) {
      if (first) {
        first = false;
      } else {
        sb.write(',');
      }
      //  note: use private values!  not the accessors
      //  otherwise you will null the immutable copy unintentionally
      sb.write(' ${field.name}: \$_${field.name}');
    }
    sb.write('''  }\';
  }
  
''');

    //  generate a operator == function
    sb.write('''
  @override
  bool operator ==(Object o) {
    if (identical(this, o)) {
      return true; //  cheap, deep identical
    }
    if (o is! ${e.name}) {
      if (o is Immutable${e.name}) {
        return o == immutable(); //  compare as immutables
      }
      return false; //  can never be == if the type is wrong
    }
    return ''');
    first = true;
    for (var field in fields) {
      if (first) {
        first = false;
      } else {
        sb.write('\n      && ');
      }
      //  note: use private values!  not the accessors
      //  otherwise you will null the immutable copy unintentionally
      sb.write('_${field.name} == o.${field.name}');
    }
    sb.write(''';
  }
''');

    //  generate a hashCode function
    sb.write('''

  @override
  int get hashCode => ''');
    first = true;
    for (var field in fields) {
      if (first) {
        first = false;
      } else {
        sb.write('\n      ^ ');
      }
      //  note: use private values!  not the accessors
      sb.write('_${field.name}.hashCode');
    }
    sb.write(''';
''');

    //  todo: implement compareTo<>
    //  todo: copy comments
    //  todo: copy class methods, const values, static methods, etc.
    //  todo: deal with mutable class inheritance of mutable classes
    sb.writeln('''
}
''');
    return sb.toString();
  }

  bool _isNullable(FieldElement field) {
    return field.type.nullabilitySuffix == NullabilitySuffix.question;
  }

  /// test if the given field element is immutable
  bool _isImmutable(FieldElement field) {
    var type = field.type;
    return // try to find one of the known language immutables
        field.isFinal ||
            type.isDartCoreBool ||
            type.isDartCoreDouble ||
            type.isDartCoreInt ||
            type.isDartCoreString ||
            type.isDartCoreNum;
  }
}
