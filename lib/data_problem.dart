// ignore: import_of_legacy_library_into_null_safe
import 'package:meta/meta.dart';

import 'models/messageContent.g.dart';
import 'mutableReady.dart';

//  a print utility
void _printHistory(List history) {
  print('history:');
  var i = 0;
  for (var e in history) {
    print('   ${i++}: $e');
  }
}

///   Run the sample situations to highlight the use of immutable classes
///
void main(List<String> arguments) {
  // ignore: omit_local_variable_types

//   print('''
// a few dart notes:
//    all Strings, numbers and boolean values in dart are immutable objects.
//       typically it's only strings.
//    final variables are not re-assignable.
//    the "new" reserved word is optional on constructor invocation
//    methods and fields are public unless the name begins with an underscore.
//    this code is written using the new null-safety compiler.
//      if you see odd uses of ?, ??, or !, ask me
//    dart can infer the data type of local variables so the use of "var" is encouraged
//    variables are public except when the name stars with an underscore
//    single quotes and double quotes delineate strings
//    three single quotes make a multi-line string.
// ''');

  // try {
  //   // let everyone have access to the member values
  //   // Note: The dart analyzer can infer types for fields, methods,
  //   //     local variables, and most generic type arguments by their use... thus the use of var
  //   var bob = PersonWithPublicValues('bob', 13);
  //   print('bob: $bob');
  //   bob.luckyNumber = 7;
  //   print('bob: $bob');
  //   print('member values are changed as expected');
  // } catch (e) {
  //   print(e);
  // }
  //
  // try {
  //   print('');
  //   // restrict the member values to read only
  //   var bob = PersonWithGetters('bob', 13);
  //   print('bob: $bob');
  //   //compile error:  bob.luckyNumber = 7;    //  There isn’t a setter named 'luckyNumber' in class 'Person2'.
  //   print('bob: $bob');
  //   print('private member values are cannot be changed');
  //   print('java/C++ style getters work as expected: bob.getName() = "' + bob.getName() + '"');
  // } catch (e) {
  //   print(e);
  // }
  //
  // try {
  //   print('');
  //   // restricted the member values can be final
  //   var bob = PersonWithFinalValues('bob', 13);
  //   print('bob: $bob');
  //   //compile error:  bob.luckyNumber = 7;    //  There isn’t a setter named 'luckyNumber' in class 'Person2'.
  //   print('bob: $bob');
  //   print('final private member values are cannot be changed');
  //   print('all constructor values need to be constant at compile time');
  // } catch (e) {
  //   print(e);
  // }

  // try {
  //   print('');
  //   // read or write through getters and setters
  //   // too much boilerplate!  similar behavior to situation #1
  //   var bob = PersonWithGettersAndSetters('bob', 13);
  //   print('bob: $bob');
  //   bob.luckyNumber = 7;
  //   print('bob: $bob');
  //   print('private member values can be changed through public accessors');
  //   print('not much accomplished other than boilerplate');
  // } catch (e) {
  //   print(e);
  // }
  //
  // try {
  //   print('');
  //   //  one instance implies only one instance!
  //   var history = <int>[]; //  an empty list of int
  //   var luckyNumber = 13;
  //   history.add(luckyNumber);
  //   print('luckyNumber: $luckyNumber');
  //   luckyNumber = 7;
  //   history.add(luckyNumber);
  //   print('luckyNumber: $luckyNumber');
  //   _printHistory(history);
  //   print('//  as expected');
  //   print('//  note: in dart, numbers are immutable.');
  // } catch (e) {
  //   print(e);
  // }

  try {
    print('');
    //  one instance implies only one instance!
    var history = <PersonWithPublicValues>[]; //  an empty list
    var bob = PersonWithPublicValues('bob', 13);
    history.add(bob);
    print('bob: $bob');
    bob.luckyNumber = 7;
    history.add(bob);
    print('bob: $bob');
    _printHistory(history);
    print('//  the history list did not work as intended.');
    print('//  all lucky numbers are now 7!  this is true since there is only one "bob" instance.');
    print('//  note: in dart, user declared classes are mutable.');
    print('');
  } catch (e) {
    print(e);
  }

  try {
    print('');
    print('ask the user to generate copies for the history records.');
    //  this will eventually be very memory intensive.
    //  this requires human discipline to enforce.
    var history = <PersonWithCopy>[]; //  an empty list
    var bob = PersonWithCopy('bob', 13);
    history.add(bob.copy());
    print('bob: $bob');
    bob.luckyNumber = 7;
    history.add(bob.copy());
    print('bob: $bob');
    _printHistory(history);
    print('//  history is now correct.  the history list has an instance for each entry, based on convention');

    print('');
    print('//  human error can still get things wrong');
    //  add more bob history
    bob.luckyNumber = 3;
    print('bob: $bob');
    history.add(bob); //  fixme: this should be a copy!
    _printHistory(history);
    bob.luckyNumber = 123456;
    print('bob: $bob');
    history.add(bob);
    _printHistory(history);
    print('''
//  history is not always correct.  entry #2 should have luckyNumber of 3
//  the history list accuracy depends on developer discipline
//  these errors are often hard to find.
''');
    print('');
  } catch (e) {
    print(e);
  }

  try {
    print('');
    print('//   force the user to generate ImmutablePerson copies for the history record.');
    print('//   use the language type system to force the copy.');
    var history = <AlmostImmutablePerson>[]; //  an empty list
    var bob = SimpleAlmostMutablePerson('bob', 13);
    //  compile error:
    //  history.add(bob); //  error: The argument type 'SimpleAlmostMutablePerson'
    //  can't be assigned to the parameter type 'AlmostImmutablePerson'.
    history.add(bob.immutable());
    print('bob: $bob');
    bob.luckyNumber = 7;
    history.add(bob.immutable());
    history.add(bob.immutable()); //  another history event
    print('bob: $bob');
    _printHistory(history);
    print('//  history is now correct.');
    print('//  the history list has an instance for each entry enforced by the dart type system');
    print('//  unfortunately it\'s not very memory efficient.');
    print('identical(history[1], history[2]): ${identical(history[1], history[2])}');
    print(
        '//   thus a history of ten-thousand entries will generate ten-thousand ImmutablePerson copies for each of its records.');
    print('//   we need to be more effective with our use of memory!');
    print('');
  } catch (e) {
    print(e);
  }

  try {
    print('');

    var history = <AlmostImmutablePerson>[];
    var bob = EffectiveMutablePerson('bob', 13);
    //  compile error:
    //  history.add(bob); //  error: The argument type 'EffectiveMutablePerson'
    //  can't be assigned to the parameter type 'AlmostImmutablePerson'.
    history.add(bob.immutable());
    print('bob: $bob');
    bob.luckyNumber = 7;
    history.add(bob.immutable());
    bob.luckyNumber = 7; //  notice that the immutable is not nulled
    history.add(bob.immutable()); //  the immutable was re-used.
    print('bob: $bob');
    _printHistory(history);
    print('//  history is now correct.  the history list shares an instance for adjacent identical values.');
    print('identical(history[1], history[2]): ${identical(history[1], history[2])}');
    print('//  the immutable instance is only created when required');
    print('//  note the tonnage of hand written boilerplate required!');
    print('');
  } catch (e) {
    print(e);
  }

  // {
  //   print('');
  print('//   an attempt at a solution using generics:');
  //   var immutableName = ImmutableWithGetter<String>('bob');
  //   print('immutableName: $immutableName');
  //
  //   var name = MutableObject<String>('bob');
  //   print('name: $name');
  //   print('name.immutable(): ${name.immutable().runtimeType} ${name.immutable()}');
  //   name.value = 'rodger';
  //   print('name.value = \'rodger\' //  note that the ".value" is required');
  //   print('name.immutable(): ${name.immutable().runtimeType} ${name.immutable()}');
  //
  //   print('');
  //   print('//  unfortunately it doesn\'t work for compound values:');
  //   var bob = MutableObject<PersonWithGettersAndSetters>(PersonWithGettersAndSetters('bob', 13));
  //   print('bob: $bob');
  //   print('bob.immutable(): ${bob.immutable().runtimeType} ${bob.immutable()}');
  //
  //   var immutableBob = bob.immutable();
  //   print('immutableBob.immutable(): ${immutableBob.runtimeType} $immutableBob');
  //   immutableBob.value?.luckyNumber = 123456;
  //   print('immutableBob: $immutableBob');
  //   print('// the immutable lucky number was changed!');
  print('//   doesn\'t really work in the general nested data structure case');
  print('');
  // }

  {
    print('');
    print('//   now let\'s worry about compound values:');
    var bob = EffectiveMutablePerson('bob', 13, favoriteColor: SampleColor(0, 0, 255));
    var immutableBob = bob.immutable();
    print('immutableBob: $immutableBob');
    //immutableBob.luckyNumber = 0;   //  compile error: There isn’t a setter named 'luckyNumber' in class 'ImmutablePerson'.

    //  write an immutable value... by working your way around the language protections
    {
      final favoriteColor = immutableBob.favoriteColor;
      //  note that the local variable favoriteColor is final!
      //  only means that the reference can't be changed... but the value can!
      if (favoriteColor != null) {
        favoriteColor.red = 255; //  fixme: this is bad, really bad
        //  we're changing a value that we think is "final" because it's a final field
        //  referenced by a final variable
        favoriteColor.green = 255;
      }
    }
    print('immutableBob: $immutableBob');
    print('//   lesson: all referenced types need to know that they are immutable!');
    print('//   so they can defend themselves from change');
    print('//   String and int are immutable classes so we didn\'t have this problem with them');
    print('');
  }

  {
    print('');
    print('//   speaking of compound values, let\'s try again:');
    print('//   What?!!!!  What can possibly wrong if we have final references to immutable fields?');
    print('//   nested compound values can create a problem.');
    var bob = MutablePerson('bob', 13, favoriteColor: MutableColor(0, 0, 255));
    var immutableBob = bob.immutable();
    print('immutableBob: $immutableBob');
    //immutableBob.luckyNumber = 0;   //  compile error: There isn’t a setter named 'luckyNumber' in class 'ImmutablePerson'.

    //  try to write an immutable value!
    {
      //Color? favoriteColor = immutableBob.favoriteColor;  //  A value of type 'ImmutableColor?' can't be assigned to a variable of type 'Color?'.
      var favoriteColor = immutableBob.favoriteColor;
      if (favoriteColor != null) {
        print('immutableBob favoriteColor: $favoriteColor');
        //favoriteColor.red = 255;  //  compile error: 'red' can't be used as a setter because it's final.
        //favoriteColor.green = 255;  //  compile error: 'green' can't be used as a setter because it's final.
      }
    }

    //Color? favoriteColor = immutableBob.favoriteColor;  //  A value of type 'ImmutableColor?' can't be assigned to a variable of type 'Color?'.
    {
      //  now let's update a mutable value by an external reference!!!
      var favoriteColor = bob.favoriteColor;
      if (favoriteColor != null) {
        favoriteColor.red = 255; //  bob's favorite color has been changed behind his back!
        favoriteColor.green = 255;
      }
    }

    print('bob: $bob');
    print('bob.immutable() (a new immutable copy): ${bob.immutable()}');
    print('//   now immutable values are immutable, mutable values are mutable... almost');
    print('//   ...with a ton of nearly unreadable and unmaintainable boilerplate.');
    print('');
  }

  {
    print('//   Hey, this is all fine.  What can possibly be wrong now?');
    print('//   Yes it is a subtle bug, but it\'s dangerous since it\'s not obvious.');
    var bob = MutablePerson('bob', 13, favoriteColor: MutableColor(0, 0, 255));
    var history = <NearlyImmutablePerson>[];
    print('bob: $bob');
    history.add(bob.immutable()); //  [0]

    //  let's fool around with bob's color, using an external reference
    print(
        '//   Let\'s try fooling with a mutable field with an external reference... behind the back of the containing object!');
    var favoriteColor = bob.favoriteColor; //  note: Person's immutable copy of Color was cleared here!
    if (favoriteColor != null) {
      favoriteColor.red = 255;
      history.add(bob.immutable()); //  [1] bob's immutable value was set to purple
      favoriteColor.green = 255; //  bob's immutable copy of Color was not cleared here!
      //                            so bob's immutable value copy of Color is still purple
      history.add(bob.immutable()); //  [2]
    }
    bob.luckyNumber = 123456; //  the update of another value wakes up the color to the green change
    history.add(bob.immutable()); //  [3]
    _printHistory(history);
    print('//   note that history[2] doesn\'t have the green value it should.');
    print('//   the mutable didn\'t know the field reference it gave away was used later');
    print('');
  }

  print('');
  print('//   dart, and nearly all languages i know of, are not really ready for immutable copies.');
  print('//   code generators are the only technology that i know of for this.');

  {
    print('');
    print('//   let\'s try the real solution, the generated code.');
    //  todo: sleepers wakeup, this is the real solution
    var bob = Person('bob', 13, Color(0, 0, 255));
    var history = <ImmutablePerson>[];
    //compile error: history.add(bob); //error: The argument type 'Person' can't be assigned to the parameter type 'ImmutablePerson'.
    history.add(bob.immutable()); //  [0]

    var immutableBob = bob.immutable();
    print('immutableBob: $immutableBob');
    //immutableBob.luckyNumber = 0;   //  compile error: There isn’t a setter named 'luckyNumber' in class 'ImmutablePerson'.

    //  write an immutable value!
    {
      //Color? favoriteColor = immutableBob.favoriteColor;  //  A value of type 'ImmutableColor?' can't be assigned to a variable of type 'Color?'.
      var favoriteColor = immutableBob.favoriteColor;
      //if (favoriteColor != null)    //  can never be null
      {
        print('immutableBob favoriteColor: $favoriteColor');
        //favoriteColor.red = 255;  //  compile error: 'red' can't be used as a setter because it's final.
        //favoriteColor.green = 255;  //  compile error: 'green' can't be used as a setter because it's final.
      }
    }
    //  update a mutable value!
    {
      //Color? favoriteColor = immutableBob.favoriteColor;  //  A value of type 'ImmutableColor?' can't be assigned to a variable of type 'Color?'.
      var favoriteColor = bob.favoriteColor;

      if (favoriteColor != null) {
        favoriteColor.red = 255;
        history.add(bob.immutable()); //  [1]
        favoriteColor.green = 255; //  bob's mutable ready mutable Color has monitored this update
        //  todo: step into here
        history.add(bob.immutable()); //  [2], that triggers a new immutable here
      }
      print('bob favoriteColor: ${bob.favoriteColor}');
    }
    bob.luckyNumber = 123456; //  [2]
    history.add(bob.immutable());
    history.add(bob.immutable());

    print('bob.immutable() (a new immutable copy): ${bob.immutable()}');
    print('immutableBob  (the old immutable copy): $immutableBob');
    _printHistory(history);
    print('//   note that history[2] now has the green value it should.');
    print('//   now immutable values are immutable, mutable values are mutable');
    print('//   changes from external references are accounted for');
    print('//   copies are kept to a minimum:');
    print('identical(history[3], history[4]): ${identical(history[3], history[4])}');
    print('//   the boilerplate written by the generator, hidden from the developer');
    print('//   immutable objects act as expected.');
    print('');
  }

  print('');
  //  todo: pay big attention to this:
  print('//   the big Dart takeaway:');
  print('//      final values are not deeply, transitively immutable.');
  print('');
  print('//   more dart notes:');
  print('//      constant values are deeply, transitively immutable.');
  print('//      constant values can only be constructed from values constant at compile time.');
  print('//      collection classes have their own immutability issues');
  print('//      efficient immutable copies of graphs is also difficult but can be made efficient');

  {
    print('');
    print('//   bonus material: code review of code generator');
    print('');
    print('//   bonus material: a pet peeve: ');
    print('//   philosophical observation: data hidden in class structures should be searchable');
    print('//   at least in a debug environment');
    print(database_declarations);
    print(database_use);
    print('');
  }

  print('Questions?');
}

/// let everyone have access to the member values
class PersonWithPublicValues {
  //  constructor args with the "this." prefix initializes the field value
  PersonWithPublicValues(this.name, this.luckyNumber);

  String name;
  int luckyNumber;

  @override
  String toString() {
    //  dollar signs in strings are parsed for variable value substitution
    return '$runtimeType{name: $name, luckyNumber: $luckyNumber}';
  }
}

/// restrict the member values to read only
/// that is, hide the private values behind a public interface
class PersonWithGetters {
  PersonWithGetters(this._name, this._luckyNumber);

  //  a public accessor for a private value
  //  dart style makes it look like a field reference, but it's a method call
  //  String theName = instance.name;
  String get name => _name;

  //  a public accessor for a private value... java/C++ style
  String getName() {
    return _name;
  }

  // ignore: prefer_final_fields
  String _name; //  underscore indicates that the value is private

  int get luckyNumber => _luckyNumber;

  // private data member
  // ignore: prefer_final_fields
  int _luckyNumber;

  @override
  String toString() {
    return '$runtimeType{name: $name, luckyNumber: $luckyNumber}';
  }
}

/// restricted the member values can be final
@immutable //  enforced by dart annotation
class PersonWithFinalValues {
  const PersonWithFinalValues(this.name, this.luckyNumber);

  final String name;
  final int luckyNumber;

  @override
  String toString() {
    return '$runtimeType{name: $name, luckyNumber: $luckyNumber}';
  }
}

// /// read or write through getters and setters
// /// typical dart style
// /// too much boilerplate!
// class PersonWithGettersAndSetters {
//   PersonWithGettersAndSetters(this._name, this._luckyNumber);
//
//   String _name;
//
//   set name(String value) => _name = value;
//
//   String get name => _name;
//
//   int _luckyNumber;
//
//   set luckyNumber(int value) => _luckyNumber = value;
//
//   int get luckyNumber => _luckyNumber;
//
//   @override
//   String toString() {
//     return '$runtimeType{name: $name, luckyNumber: $luckyNumber}';
//   }
// }

/// let everyone have access to the member values
class PersonWithCopy {
  PersonWithCopy(this.name, this.luckyNumber);

  PersonWithCopy copy() //  should be called clone?
  {
    return PersonWithCopy(name, luckyNumber);
  }

  String name;
  int luckyNumber;

  @override
  String toString() {
    return '$runtimeType{name: $name, luckyNumber: $luckyNumber}';
  }
}

/// used as a simple compound value class
class SampleColor {
  SampleColor(this.red, this.green, this.blue);

  int red;
  int green;
  int blue;

  @override
  String toString() {
    return '$runtimeType{red: $red, green: $green, blue: $blue}';
  }
}

/// an immutable version of Person
/// just like PersonWithPublicValues.
@immutable
// this annotation is only a start to the problem.
// it enforces all fields need to be final
// but does not prevent their modification from other references.
class AlmostImmutablePerson {
  const AlmostImmutablePerson(this.name, this.luckyNumber, {SampleColor? favoriteColor})
      : favoriteColor = favoriteColor;

  final String name;
  final int luckyNumber;
  final SampleColor? favoriteColor;

  @override
  String toString() {
    return '$runtimeType{name: $name, luckyNumber: $luckyNumber'
        '${favoriteColor == null ? '' : ', favoriteColor: $favoriteColor'}'
        '}';
  }
}

/// a simple mutable version of Person
class SimpleAlmostMutablePerson {
  SimpleAlmostMutablePerson(this.name, this.luckyNumber, {this.favoriteColor});

  AlmostImmutablePerson immutable() {
    //  a immutable copy is made at every call!
    return AlmostImmutablePerson(name, luckyNumber, favoriteColor: favoriteColor);
  }

  String name;
  int luckyNumber;
  SampleColor? favoriteColor;

  @override
  String toString() {
    return '$runtimeType{name: $name, luckyNumber: $luckyNumber}'
        '${favoriteColor == null ? '' : ', favoriteColor: $favoriteColor'}'
        '}';
  }
}

/// a mutable version of Person that only generates a new immutable when required (i.e. lazy eval).
class EffectiveMutablePerson {
  EffectiveMutablePerson(this._name, this._luckyNumber, {SampleColor? favoriteColor}) : _favoriteColor = favoriteColor;

  AlmostImmutablePerson immutable() {
    return _immutablePerson //  reuse an accurate immutable value
        ?? //  if the value above was null, do the following:
        //  generate a new immutable and save it for possible subsequent use
        (_immutablePerson = AlmostImmutablePerson(name, luckyNumber, favoriteColor: _favoriteColor));
  }

  String _name;

  String get name => _name;

  set name(String value) {
    //  does the set result in a change of value?
    if (_name == value) {
      return; //  no, do nothing
    }
    //  yes.  apply the change and forget any old immutable copy
    _name = value;
    _immutablePerson = null; //  invalidate any existing immutable value
  }

  int _luckyNumber;

  int get luckyNumber => _luckyNumber;

  set luckyNumber(int value) {
    if (_luckyNumber == value) {
      return;
    }
    _luckyNumber = value;
    _immutablePerson = null;
  }

  SampleColor? _favoriteColor;

  SampleColor? get favoriteColor => _favoriteColor;

  set favoriteColor(SampleColor? value) {
    if (_favoriteColor == value) {
      return;
    }
    _favoriteColor = value;
    _immutablePerson = null;
  }

  AlmostImmutablePerson? _immutablePerson; //  lazy eval immutable version, will be null initially

  @override
  String toString() {
    return '$runtimeType{name: $name, luckyNumber: $luckyNumber'
        '${_favoriteColor == null ? '' : ', favoriteColor: $_favoriteColor'}'
        '}';
  }
}

/// an attempt at generic solution
class ImmutableWithGetter<T> {
  //  initialize the value in the constructor
  ImmutableWithGetter(T? v) : _value = v;

  // ignore: unused_element
  ImmutableWithGetter._(); //  force the default constructor to be private, i.e. never used

  @override
  String toString() {
    return '$_value';
  }

  T? get value => _value;
  T? _value; //  can't be final due to it's use in immutable object
}

/// an attempt at generic solution
class MutableObject<T> extends ImmutableWithGetter<T> {
  MutableObject(T v) : super(v);

  // ignore: unused_element
  MutableObject._() : super._(); //  force the default constructor to be private, i.e. never used

  set value(T? v) => _value = v; //  the private variable _value is accessible if in source is the same source file!

  ///  create an immutable copy
  ImmutableWithGetter<T> immutable() {
    return ImmutableWithGetter<T>(_value);
  }
}

@immutable
class ImmutableColor {
  ImmutableColor(this.red, this.green, this.blue);

  final int red;
  final int green;
  final int blue;

  @override
  String toString() {
    return '$runtimeType{red: $red, green: $green, blue: $blue}';
  }
}

/// used as a simple compound value class
class MutableColor implements MutableReady<ImmutableColor> {
  MutableColor(this.red, this.green, this.blue);

  int red;
  int green;
  int blue;

  @override
  ImmutableColor immutable() {
    //  always make a copy
    return ImmutableColor(red, green, blue);
  }

  @override
  String toString() {
    return '$runtimeType{red: $red, green: $green, blue: $blue}';
  }
}

/// an immutable version of Person
/// just like AlmostImmutablePerson but with an immutable favorite color.
@immutable
class NearlyImmutablePerson {
  const NearlyImmutablePerson(this.name, this.luckyNumber, {ImmutableColor? favoriteColor})
      : favoriteColor = favoriteColor;

  final String name;
  final int luckyNumber;
  final ImmutableColor? favoriteColor;

  @override
  String toString() {
    return '$runtimeType{name: $name, luckyNumber: $luckyNumber'
        '${favoriteColor == null ? '' : ', favoriteColor: $favoriteColor'}';
  }
}

/// an mutable version of Person
class MutablePerson implements MutableReady<NearlyImmutablePerson> {
  MutablePerson(this._name, this._luckyNumber, {MutableColor? favoriteColor}) // optional named argument in dart
      : _favoriteColor = favoriteColor;

  @override
  NearlyImmutablePerson immutable() {
    _immutablePerson ??= NearlyImmutablePerson(name, luckyNumber, favoriteColor: _favoriteColor?.immutable());
    return _immutablePerson!;
  }

  String _name;

  set name(String value) {
    if (_name == value) {
      return;
    }
    _name = value;
    _immutablePerson = null; //  invalidate any existing immutable value
  }

  String get name => _name;

  int _luckyNumber;

  set luckyNumber(int value) {
    if (_luckyNumber == value) {
      return;
    }
    _luckyNumber = value;
    _immutablePerson = null;
  }

  int get luckyNumber => _luckyNumber;

  MutableColor? _favoriteColor;

  set favoriteColor(MutableColor? value) {
    if (_favoriteColor == value) {
      return;
    }
    _favoriteColor = value;
    _immutablePerson = null;
  }

  MutableColor? get favoriteColor {
    //  since we're giving away a reference to a mutable value
    //  our local immutable copy may not stay valid!
    //
    //  note: this almost works.
    //  if a reference is acquired and an immutable copy is made,
    //  subsequent alterations using that reference will not be monitored.
    //
    //  var c = bob.favoriteColor;    //  get a reference from the getter
    //  history.add(bob.immutable()); //  validate the immutable version
    //  c.red = 128;                  //  modify the color
    //  history.add(bob.immutable()); //  the _immutablePerson will still be considered valid!
    _immutablePerson = null;
    return _favoriteColor;
  }

  //  immutable value for optimization
  NearlyImmutablePerson? _immutablePerson;

  @override
  String toString() {
    return '$runtimeType{name: $_name, luckyNumber: $_luckyNumber}'
        '${_favoriteColor == null ? '' : ', favoriteColor: $_favoriteColor'}';
  }
}

String database_declarations = '''
//  db: class data structure as database tables
CREATE TABLE IF NOT EXISTS Color(
    instanceId INT AUTO_INCREMENT PRIMARY KEY,
    red INT NOT NULL,
    green INT NOT NULL,
    blue INT NOT NULL
    );
CREATE TABLE IF NOT EXISTS Person(
    instanceId INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    luckyNumber INT NOT NULL,
    favoriteColor INT,
    CONSTRAINT fk_favoriteColor
        FOREIGN KEY (favoriteColor)
        REFERENCES Color(instanceId)
    );
''';

String database_use = '''

#  look for colors in use with the a large amount of blue
select fullClassPath, instanceId, member, type, member.toString()
from anyClass
where
  type is Color
  and member.blue > 200
sort by fullPath, instanceId, member.blue descending, type
limit 20;

#  trigger on too much blue
CREATE TRIGGER bad_blue_update
BEFORE UPDATE
ON Color
BEGIN
    IF member.blue and newValue > 200 THEN
        breakPoint('blue set too large on: \${member.blue) = \$newValue');
    END IF;
END
''';
