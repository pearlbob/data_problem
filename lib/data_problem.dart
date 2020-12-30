// ignore: import_of_legacy_library_into_null_safe
import 'package:meta/meta.dart';

import 'models/messageContent.g.dart' as generated;

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

  try {
    // let everyone have access to the member values
    // Note: The dart analyzer can infer types for fields, methods,
    // local variables, and most generic type arguments.
    // Note: in dart, the new reserved word is optional on constructor invocation
    var bob = PersonWithPublicValues('bob', 13);
    print('bob: $bob');
    bob.luckyNumber = 7;
    print('bob: $bob');
    print('member values are changed as expected');
  } catch (e) {
    print(e);
  }

  try {
    print('');
    // restrict the member values to read only
    var bob = PersonWithGetters('bob', 13);
    print('bob: $bob');
    //compile error:  bob.luckyNumber = 7;    //  There isn’t a setter named 'luckyNumber' in class 'Person2'.
    print('bob: $bob');
    print('private member values are cannot be changed');
    print('java/C++ getters work as expected: bob.getName() = "' + bob.getName() + '"');
  } catch (e) {
    print(e);
  }

  try {
    print('');
    // restricted the member values can be final
    var bob = PersonWithFinalValues('bob', 13);
    print('bob: $bob');
    //compile error:  bob.luckyNumber = 7;    //  There isn’t a setter named 'luckyNumber' in class 'Person2'.
    print('bob: $bob');
    print('final private member values are cannot be changed');
    print('all constructor values need to be constant at compile time');
  } catch (e) {
    print(e);
  }

  try {
    print('');
    // read or write through getters and setters
    // too much boilerplate!  similar behavior to situation #1
    var bob = PersonWithGettersAndSetters('bob', 13);
    print('bob: $bob');
    bob.luckyNumber = 7;
    print('bob: $bob');
    print('private member values can be changed through public accessors');
  } catch (e) {
    print(e);
  }

  try {
    print('');
    //  one instance implies only one instance!
    var history = <PersonWithGettersAndSetters>[]; //  an empty list
    var bob = PersonWithGettersAndSetters('bob', 13);
    history.add(bob);
    print('bob: $bob');
    bob.luckyNumber = 7;
    history.add(bob);
    print('bob: $bob');
    _printHistory(history);
    print('//  all lucky numbers are now 7!  this is true since there is only one instance!');
  } catch (e) {
    print(e);
  }

  try {
    print('');
    //  force the user to generate copies for the history's records.
    //  this will eventually be very memory intensive.
    //  this requires human discipline to enforce.
    var history = <PersonWithCopy>[]; //  an empty list
    var bob = PersonWithCopy('bob', 13);
    history.add(bob.copy());
    print('bob: $bob');
    //  dart numbers are references to immutable class instances!
    //  so this does not modify existing memory.
    bob.luckyNumber = 7;
    history.add(bob.copy());
    print('bob: $bob');
    _printHistory(history);
    print('//  history is now correct.  the history list has an instance for each entry, based on convention');

    print('');
    print('human error can still get things wrong');
    // history = <PersonWithCopy>[]; //  empty the list
    bob.luckyNumber = 3;
    print('bob: $bob');
    history.add(bob); //  should be a copy
    _printHistory(history);
    bob.luckyNumber = 123456;
    print('bob: $bob');
    history.add(bob);
    _printHistory(history);
    print('//  history is not always correct.  the history list accuracy depends on developer discipline');
  } catch (e) {
    print(e);
  }

  try {
    print('');
    print('force the history to generate ImmutablePerson copies for it\'s record.');
    print('use the language type system to force the copy.');
    var history = <AlmostImmutablePerson>[]; //  an empty list
    var bob = SimpleAlmostMutablePerson('bob', 13);
    //  compile error:
    //  history.add(bob); //  error: The argument type 'SimpleMutablePerson'
    //  can't be assigned to the parameter type 'ImmutablePerson'.
    history.add(bob.immutable());
    print('bob: $bob');
    bob.luckyNumber = 7;
    history.add(bob.immutable());
    print('bob: $bob');
    _printHistory(history);
    print('//  history is now correct.  the history list has an instance for each entry enforced by the type system');
  } catch (e) {
    print(e);
  }

  try {
    print('');
    //  force the history to generate ImmutablePerson copies for it's record.
    //  use the language type system to force the copy.
    var history = <AlmostImmutablePerson>[];
    var bob = EffectiveMutablePerson('bob', 13);
    //  compile error:
    //  history.add(bob); //  error: The argument type 'SimpleMutablePerson'
    //  can't be assigned to the parameter type 'ImmutablePerson'.
    history.add(bob.immutable());
    print('bob: $bob');
    bob.luckyNumber = 7;
    history.add(bob.immutable());
    bob.luckyNumber = 7; //  notice that the immutable is not nulled
    history.add(bob.immutable()); //  the immutable was re-used.
    print('bob: $bob');
    _printHistory(history);
    print('//  history is now correct.  the history list has an instance for each entry enforced by the type system');
    print('//  the immutable instance is only created when required');
    print('//  note the tonnage of boilerplate required!');
  } catch (e) {
    print(e);
  }

  {
    print('');
    print('an attempted generic solution:');
    var immutableName = ImmutableWithGetter<String>('bob');
    print('immutableName: $immutableName');

    var name = MutableObject<String>('bob');
    print('name: $name');
    print('name.immutable(): ${name.immutable().runtimeType} ${name.immutable()}');
    name.value = 'rodger';
    print('name.value = \'rodger\' //  note that the ".value" is required');
    print('name.immutable(): ${name.immutable().runtimeType} ${name.immutable()}');

    print('');
    print('unfortunately it doesn\'t work for compound values:');
    var bob = MutableObject<PersonWithGettersAndSetters>(PersonWithGettersAndSetters('bob', 13));
    print('bob: $bob');
    print('bob.immutable(): ${bob.immutable().runtimeType} ${bob.immutable()}');

    var immutableBob = bob.immutable();
    print('immutableBob.immutable(): ${immutableBob.runtimeType} $immutableBob');
    immutableBob.value?.luckyNumber = 123456;
    print('immutableBob: $immutableBob');
  }

  {
    print('');
    print('speaking of compound values:');
    var bob = SimpleAlmostMutablePerson('bob', 13, favoriteColor: SampleColor(0, 0, 255));
    var immutableBob = bob.immutable();
    print('immutableBob: $immutableBob');
    //immutableBob.luckyNumber = 0;   //  compile error: There isn’t a setter named 'luckyNumber' in class 'ImmutablePerson'.

    //  write an immutable value... by working your way around the language protections
    {
      var favoriteColor = immutableBob.favoriteColor;
      if (favoriteColor != null) {
        favoriteColor.red = 255;
        favoriteColor.green = 255;
      }
    }
    print('immutableBob: $immutableBob');
    print('lesson: all referenced types need to know that they are immutable!');
  }

  {
    print('');
    print('speaking of compound values, let\'s try again:');
    var bob = MutablePerson('bob', 13, favoriteColor: MutableColor(0, 0, 255));
    var immutableBob = bob.immutable();
    print('immutableBob: $immutableBob');
    //immutableBob.luckyNumber = 0;   //  compile error: There isn’t a setter named 'luckyNumber' in class 'ImmutablePerson'.

    //  write an immutable value!
    {
      //Color? favoriteColor = immutableBob.favoriteColor;  //  A value of type 'ImmutableColor?' can't be assigned to a variable of type 'Color?'.
      var favoriteColor = immutableBob.favoriteColor;
      if (favoriteColor != null) {
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
        favoriteColor.green = 255;
      }
    }

    print('bob: $bob');
    print('bob.immutable() (a new immutable copy): ${bob.immutable()}');
    print('immutableBob  (the old immutable copy): $immutableBob');
    print('now immutable values are immutable, mutable values are mutable');
  }

  print('');
  print('small dart notes:');
  print('   all Strings, numbers and boolean values in dart are immutable objects!');
  print('   final variables are not re-assignable.');
  print('   constant values are deeply, transitively immutable.');
  print('   constant values can only be constructed from values constant at compile time.');
  print('   final values are not deeply, transitively immutable.');
  print('   collection classes have their own immutability issues');
  print('   efficient immutable copies of graphs is also difficult');

  print('');
  print('dart, as all languages is know of, are not really ready for immutable copies.');
  print('code generators are the only technology that i know of for this.');
  print('see sample input classes at the bottom of this code.');
  {
    print('');
    print('generator source for color: '
        '${Color(0, 0, 255).toString()}');
    print('generator output for color: '
        '${MutableColor(0, 0, 255).toString()}');
    print('generator source for person: '
        '${Person('bob', 13, favoriteColor: Color(0, 0, 255))}');
    print('generator output for person: '
        '${MutablePerson('bob', 13, favoriteColor: MutableColor(0, 0, 255))}');
    print('Note: in common use, the mutable ready version of color would be named Color...');
    print('     just from a different class path.');
  }

  {
    print('');
    print(database_declarations);
    print(database_use);
  }

  {
    print('');
    print('speaking of compound values, let\'s try the generated code:');
    var bob = generated.Person('bob', 13, generated.Color(0, 0, 255));
    var history = <generated.ImmutablePerson>[]; //  an empty list
    //compile error: history.add(bob); //error: The argument type 'Person' can't be assigned to the parameter type 'ImmutablePerson'. (argument_type_not_assignable at [dart_generator_test] lib/data_problem.dart:275)
    history.add(bob.immutable());

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
      //  if (favoriteColor != null)  //  can never be null
      {
        favoriteColor.red = 255;
        history.add(bob.immutable());
        favoriteColor.green = 255;
        history.add(bob.immutable());
      }
      print('bob favoriteColor: ${bob.favoriteColor}');
    }
    bob.luckyNumber = 123456;
    history.add(bob.immutable());

    print('bob.immutable() (a new immutable copy): ${bob.immutable()}');
    print('immutableBob  (the old immutable copy): $immutableBob');
    _printHistory(history);
    print('bob: $bob');
    print('now immutable values are immutable, mutable values are mutable');
    print('boilerplate written by the generator, hidden from the developer');
  }
}

/// let everyone have access to the member values
class PersonWithPublicValues {
  PersonWithPublicValues(this.name, this.luckyNumber);

  String name;
  int luckyNumber;

  @override
  String toString() {
    return '$runtimeType{name: $name, luckyNumber: $luckyNumber}';
  }
}

/// restrict the member values to read only
/// that is, hide the private values behind a public interface
class PersonWithGetters {
  PersonWithGetters(this._name, this._luckyNumber);

  //  a public accessor for a private value
  //  String theName = instance.name;
  String get name => _name;

  //  a public accessor for a private value... java style
  //  String theName = instance.getName();
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

  final String name; //  final can only be initialized at construction
  final int luckyNumber; //  final can only be initialized at construction

  @override
  String toString() {
    return '$runtimeType{name: $name, luckyNumber: $luckyNumber}';
  }
}

/// read or write through getters and setters
/// too much boilerplate!
class PersonWithGettersAndSetters {
  PersonWithGettersAndSetters(this._name, this._luckyNumber);

  set name(String value) => _name = value;

  String get name => _name;
  String _name;

  set luckyNumber(int value) => _luckyNumber = value;

  int get luckyNumber => _luckyNumber;
  int _luckyNumber;

  @override
  String toString() {
    return '$runtimeType{name: $name, luckyNumber: $luckyNumber}';
  }
}

/// let everyone have access to the member values
class PersonWithCopy {
  PersonWithCopy(this.name, this.luckyNumber);

  PersonWithCopy copy() {
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
  const AlmostImmutablePerson(this.name, this.luckyNumber, //
      {SampleColor? favoriteColor} // optional named argument in dart
      )
      : favoriteColor = favoriteColor;

  final String name;
  final int luckyNumber;
  final SampleColor? favoriteColor; //  the ? means it can be null

  @override
  String toString() {
    return '$runtimeType{name: $name, luckyNumber: $luckyNumber'
        //  return string of favorite color if it's not null
        '${favoriteColor == null ? '' : ', favoriteColor: $favoriteColor'}'
        '}';
  }
}

/// a simple mutable version of Person
class SimpleAlmostMutablePerson {
  SimpleAlmostMutablePerson(this.name, this.luckyNumber, {this.favoriteColor});

  AlmostImmutablePerson immutable() {
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
  EffectiveMutablePerson(this._name, this._luckyNumber);

  AlmostImmutablePerson immutable() {
    return immutablePerson //  reuse an accurate immutable value
        ?? //  if the value above was null, do the following:
        //  generate a new immutable and save it for possible subsequent use
        (immutablePerson = AlmostImmutablePerson(name, luckyNumber));
  }

  set name(String value) {
    if (_name == value) {
      return;
    }
    _name = value;
    immutablePerson = null; //  invalidate any existing immutable value
  }

  String get name => _name;
  String _name;

  set luckyNumber(int value) {
    if (_luckyNumber == value) {
      return;
    }
    _luckyNumber = value;
    immutablePerson = null;
  }

  int get luckyNumber => _luckyNumber;
  int _luckyNumber;

  AlmostImmutablePerson? immutablePerson; //  lazy eval immutable version, will be null initially

  @override
  String toString() {
    return '$runtimeType{name: $name, luckyNumber: $luckyNumber}';
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

abstract class MutableReady<T> {
  T immutable();
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
class ImmutablePerson {
  const ImmutablePerson(this.name, this.luckyNumber, {ImmutableColor? favoriteColor}) : favoriteColor = favoriteColor;

  final String name;
  final int luckyNumber;
  final ImmutableColor? favoriteColor;

  @override
  String toString() {
    return '$runtimeType{name: $name, luckyNumber: $luckyNumber'
        '${favoriteColor == null ? '' : ', favoriteColor: $favoriteColor'}';
  }
}

/// an effective mutable version of Person
class MutablePerson implements MutableReady<ImmutablePerson> {
  MutablePerson(this._name, this._luckyNumber, {MutableColor? favoriteColor}) // optional named argument in dart
      : _favoriteColor = favoriteColor;

  @override
  ImmutablePerson immutable() {
    return _immutablePerson //  reuse an accurate immutable value
        ??
        //  generate a new immutable and save it for possible subsequent use
        (_immutablePerson = ImmutablePerson(name, luckyNumber, favoriteColor: favoriteColor?.immutable()));
  }

  set name(String value) {
    if (_name == value) {
      return;
    }
    _name = value;
    _immutablePerson = null; //  invalidate any existing immutable value
  }

  String get name => _name;
  String _name;

  set luckyNumber(int value) {
    if (_luckyNumber == value) {
      return;
    }
    _luckyNumber = value;
    _immutablePerson = null;
  }

  int get luckyNumber => _luckyNumber;
  int _luckyNumber;

  set favoriteColor(MutableColor? value) {
    if (_favoriteColor == value) {
      return;
    }
    _favoriteColor = value;
    _immutablePerson = null;
  }

  MutableColor? get favoriteColor {
    //  since we're giving a reference to a mutable value
    //  our local immutable copy may not stay valid
    _immutablePerson = null;
    return _favoriteColor;
  }

  MutableColor? _favoriteColor;

  ImmutablePerson? _immutablePerson;

  @override
  String toString() {
    return '$runtimeType{name: $name, luckyNumber: $luckyNumber}'
        '${favoriteColor == null ? '' : ', favoriteColor: $favoriteColor'}';
  }
}

/// well the above is too much boilerplate to be useful.
/// my design calls for generating the above from the below:

/// code generator input:
class Color {
  Color(this.red, this.green, this.blue);

  int red;
  int green;
  int blue;

  @override
  String toString() {
    return '$runtimeType{red: $red, green: $green, blue: $blue}';
  }
}

class Person {
  Person(this.name, this.luckyNumber, {this.favoriteColor});

  String name;
  int luckyNumber;
  Color? favoriteColor;

  @override
  String toString() {
    return '$runtimeType{name: $name, luckyNumber: $luckyNumber}'
        '${favoriteColor == null ? '' : ', favoriteColor: $favoriteColor'}';
  }
}

String database_declarations = '''
//  db:
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

#  look for colors in use with the most blue
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
