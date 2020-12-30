// ignore: import_of_legacy_library_into_null_safe
import 'package:build/build.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:analyzer/dart/element/element.dart';

/*
flutter pub run build_runner watch --delete-conflicting-outputs
 */

class CodeBuilder implements Builder {
  @override
  final buildExtensions = const {
    '.dart': ['.g.dart']
  };

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
//  do not change by hand
import '../mutableReady.dart';

// Input ID: ${buildStep.inputId}

$sb
''');
  }

  Iterable<Element> allElements(LibraryElement element) sync* {
    for (var cu in element.units) {
      yield* cu.functionTypeAliases;
      yield* cu.functions;
      yield* cu.mixins;
      yield* cu.topLevelVariables;
      yield* cu.types;
    }
  }

  String _generateImmutableClass(LibraryElement entryLib, Element e) {
    var fields = entryLib.getType(e.name).fields;
    var sb = StringBuffer();
    sb.write('''
/// generated Immutable class for for the given ${e.name} class
class Immutable${e.name} {
  Immutable${e.name}(''');
    var first = true;
    for (var fe in fields) {
      if (first) {
        first = false;
      } else {
        sb.write(',');
      }
      sb.write(' this.${fe.name}');
    }
    sb.writeln(');');
    sb.writeln();

    for (var fe in fields) {
      var type = fe.type;
      var isImmutable = _isImmutable(fe);
      sb.writeln('  final '
          '${isImmutable ? '' : 'Immutable'}'
          '${type.getDisplayString(withNullability: false)} ${fe.name};');
    }

    sb.write('''
 
  @override
  String toString() {
    return '\$runtimeType{''');
    first = true;
    for (var fe in fields) {
      if (first) {
        first = false;
      } else {
        sb.write(',');
      }
      sb.write(' ${fe.name}: \$${fe.name}');
    }
    sb.writeln(''' }\';
  }
}
''');
    return sb.toString();
  }

  String _generateMutableClass(LibraryElement entryLib, Element e) {
    var fields = entryLib.getType(e.name).fields;
    var sb = StringBuffer();
    sb.write('''
/// generated MutableReady class for for the given ${e.name} class
class ${e.name} implements MutableReady<Immutable${e.name}> {
  ${e.name}(''');
    var first = true;
    for (var fe in fields) {
      if (first) {
        first = false;
      } else {
        sb.write(',');
      }
      sb.write(' this.${fe.name}');
    }
    sb.writeln(');');
    sb.writeln();

    for (var fe in fields) {
      var type = fe.type;
      sb.writeln('  '
          '${type.getDisplayString(withNullability: false)} ${fe.name};');
    }

    sb.write('''

  /// generate an Immutable class for the given ${e.name} when asked
  @override
  Immutable${e.name} immutable() {
    return( Immutable${e.name}(''');
    first = true;
    for (var fe in fields) {
      if (first) {
        first = false;
      } else {
        sb.write(',');
      }
      sb.write(' ${fe.name}');
      if (!_isImmutable(fe)) {
        //  member has to be immutable or an implementation of MutableReady!
        sb.write('.immutable()');
      }
    }
    sb.writeln('));');
    sb.writeln('''
  }
  ''');

    //  todo: implement equals, hashcode, compareTo<>
    sb.write('''
 
  @override
  String toString() {
    return '\$runtimeType{''');
    first = true;
    for (var fe in fields) {
      if (first) {
        first = false;
      } else {
        sb.write(',');
      }
      sb.write(' ${fe.name}: \$${fe.name}');
    }
    sb.writeln(''' }\';
  }
}
''');
    return sb.toString();
  }

  /// is the given field element immutable?
  bool _isImmutable(FieldElement fe) {
    var type = fe.type;
    return // try to find one of the known language immutables
        fe.isFinal ||
            type.isDartCoreBool ||
            type.isDartCoreDouble ||
            type.isDartCoreInt ||
            type.isDartCoreString ||
            type.isDartCoreNum;
  }
}
