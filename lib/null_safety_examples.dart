//
//
/// dart new null safety feature examples
///
void main(List<String> arguments) {
  var exampleClassInstance = NullSafetyExamples(); //  notice type inference

  exampleClassInstance.main(arguments);
  exampleClassInstance.anotherMain(arguments); //  non-nullable variables are valid for nullable types
  exampleClassInstance.yetAnotherMain(arguments);
  exampleClassInstance.yetAnotherMain(null);
  exampleClassInstance.yetAnotherMain(['first', null, 'last']);
}

class NullSafetyExamples {
  void main(List<String> nonNullArguments) //  a non-null list of non-null values
  {
    //  as you might expect, with no extra stuff going on (i.e. no null testing)

    print('main( $nonNullArguments ):');
    //  no test for null required
    if (nonNullArguments.isNotEmpty) {
      for (var arg in nonNullArguments) {
        //  no test for null is required
        if (arg.isNotEmpty) {
          print('  arg: $arg');
        }
      }
    }
    print(this);
  }

  void anotherMain(List<String?>? nullableArguments) //  a nullable list of nullable values
  {
    //  forced to test for null before every first access

    //error: nullableArguments.isNotEmpty;   error: An expression whose value can be 'null' must be null-checked before it can be dereferenced.
    print('');
    print('anotherMain( $nullableArguments ):');
    if (nullableArguments != null) {
      if (nullableArguments.isNotEmpty) //  ok since tested above
      {
        for (var arg in nullableArguments) {
          if (arg == null) {
            //  always prints null... null is a class instance of the Null class with a toString() method
            print('  arg: $arg');
            continue;
          }
          if (arg.isNotEmpty) {
            // no test for null, print string if not empty
            print('  arg: $arg');
          }
        }
      }
    }

    try {
      var myNumber = neverNull;
      //  the type of myNumber is int. it's non-nullable, i.e. null safe
      print('myNumber: ${myNumber.runtimeType}: $myNumber');
    } catch (e) {
      print('thrown: $e');
    }

    try {
      var myNumber = canBeNull;
      //  the type of myNumber is int? and is nullable
      print(
          'myNumber: ${myNumber.runtimeType}: $myNumber    //  things often work out naturally if you don\'t force them');
    } catch (e) {
      print('thrown: $e');
    }

    try {
      //error: int myNumber = canBeNull;// error: A value of type 'int?' can't be assigned to a variable of type 'int'.
      var myNumber =
          canBeNull!; //  note: with the ! operator, the developer takes responsibility for this run time failure!
      //  the type of myNumber is int... and is non-nullable
      print('myNumber: $myNumber');
    } catch (e) {
      print('thrown: $e'); //  oops!  what would you expect?
    }

    var myNumber2 = canBeNull ?? 0; //  a default, non-nullable value covers a possible run time null failure
    //  the type of myNumber2 is int. it's non-nullable, i.e. null safe
    print('myNumber: ${myNumber2.runtimeType}: $myNumber2     //  as expected');

    {
      NullSafetyExamples? myNullableExample; //  will be null here

      print('myNullableExample: ${myNullableExample.runtimeType}: $myNullableExample'); //  prints Null: null

      //  protect against indirection on a null reference
      {
        var myValue = myNullableExample?.canBeNull //  indirection on null pointer will not happen but will return null
                ??
                0 //  default value covers possible run time failure
            ;
        //  the type of myValue is int. it's non-nullable, i.e. null safe
        print('myValue: ${myValue.runtimeType}: $myValue     //  possible error avoided');
      }
      {
        var myValue = NullSafetyExamples();

        // myValue =  myNullableExample;
        //  error: A value of type 'NullSafetyExamples?' can't be assigned to a variable of type 'NullSafetyExamples'.

        print('myValue: ${myValue.runtimeType}: $myValue     //  possible error avoided');
      }

      //  testing for null will be understood... most of the time by looking a program flow
      if (myNullableExample != null) {
        //  compiler knows myExample will not be null here based on program flow
        //  the ? will not be required
        var myValue = myNullableExample.neverNull;
        print('myValue: $myValue');
      }
    }
  }

  void yetAnotherMain(List<String?>? nullableArguments) //  a nullable list of nullable values
  {
    print('');
    print('yetAnotherMain( $nullableArguments ):');
    print('  without nulls:');
    for (var arg in nullableArguments ?? []) //  substitute empty list if list is null
    {
      // print string if not empty or null
      if (arg?.isNotEmpty ?? false) {
        print('  arg: $arg');
      }
    }

    //for (var arg in nullableArguments ) {
    //error: An expression whose value can be 'null' must be null-checked before it can be dereferenced.''

    print('');
    print('  with nulls:');
    for (var arg in nullableArguments ?? []) {
      print('  arg: $arg');
    }
  }

  /// default constructor
  NullSafetyExamples()
      : initializedByConstructor = 12,
        anotherInitializedFinal = 10 //  default value from this constructor
  {
    print('constructor called');

    //  omission of these invokes a runtime error
    aLateValue = 123;
    aLateFinalValue = 12345678;
  }

  //  in dart, alternate constructors are named
  NullSafetyExamples.alternateConstructor(
      //  non-null constructor argument value will be assigned to the member field
      this.initializedByConstructor,
      //  non-null constructor argument value will set the final value
      this.anotherInitializedFinal) {
    print('constructor called');
  }

  NullSafetyExamples.constructorWithNamedDefaultOptions(
      {
      //  non-null constructor argument value will be assigned to the member field
      this.initializedByConstructor = 3,
      //  non-null constructor argument value will set the final value
      this.anotherInitializedFinal = 10 //  default value if not given by named argument
      }) {
    print('constructor called');
  }

  @override
  String toString() {
    //  generated toString()
    return 'NullSafetyExamples{neverNull: $neverNull, canBeNull: $canBeNull,'
        ' initializedByConstructor: $initializedByConstructor,'
        ' initializedFinal: $initializedFinal,'
        ' anotherInitializedFinal: $anotherInitializedFinal,'
        ' aLateValue: $aLateValue, aLateFinalValue: $aLateFinalValue}';
  }

  int neverNull = 0; //  non-null value is initialized at construction, can change at any time
  int? canBeNull; //  a nullable value, initialization is optional, will be null if not initialized
  int initializedByConstructor; //  has to be initialized to a non-null value by every constructor

  final int initializedFinal = 4; //  non-null value cannot change
  final int anotherInitializedFinal; //  value cannot change outside of constructor initialization

  final int initializedConst = 4; //  non-null value cannot change, must be valid at compile time

  late int aLateValue; //  developer is responsible for initializing this before use
  late final int aLateFinalValue; //  developer is responsible for initializing this in the constructor
}
