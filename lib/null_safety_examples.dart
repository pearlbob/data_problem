//
//
/// dart new null safety feature examples
class NullSafetyExamples {
  void main(List<String> nonNullArguments) //  a non-null list of non-null values
  {
    if (nonNullArguments.isNotEmpty) //  no test for null
    {
      for (var arg in nonNullArguments) {
        if (arg.isNotEmpty) //  no test for null is required
        {
          print('arg: $arg');
        }
      }
    }
  }

  void anotherMain(List<String?>? nullableArguments) //  a nullable list of nullable values
  {
    //error: nullableArguments.isNotEmpty;   error: An expression whose value can be 'null' must be null-checked before it can be dereferenced.

    if (nullableArguments != null) {
      if (nullableArguments.isNotEmpty) //  ok since tested above
      {
        for (var arg in nullableArguments) {
          if (arg == null) {
            print('arg: $arg'); //  always prints null... null is a class instance of Null with a toString() method
            continue;
          }
          if (arg.isNotEmpty) {
            // no test for null, print string if not empty
            print('arg: $arg');
          }
        }
      }
    }

    //error: int myNumber = canBeNull;// error: A value of type 'int?' can't be assigned to a variable of type 'int'.

    try {
      var myNumber = canBeNull!; //  note the !  the developer takes responsibility for this run time failure!
      print('myNumber: $myNumber');
    } catch (e) {
      print('thrown: $e');
    }

    var myNumber2 = canBeNull ?? 0; //  default value covers a possible run time failure
    print('myNumber2: $myNumber2');

    NullSafetyExamples? myNullableExample; //  will be null here

    print('myNullableExample: $myNullableExample'); //  prints null

    //  protect against indirection on a null reference
    {
      var myValue = myNullableExample?.canBeNull //  indirection on null pointer will not happen but will return null
              ??
              0 //  default value covers possible run time failure
          ;
      print('myValue: $myValue');
    }

    //  testing for null will be understood... most of the time
    if (myNullableExample != null) {
      //  compiler knows myExample will not be null here based on program flow
      //  the ? will not be required
      var myValue = myNullableExample.neverNull;
      print('myValue: $myValue');
    }
  }

  void yetAnotherMain(List<String?>? nullableArguments) //  a nullable list of nullable values
  {
    for (var arg in nullableArguments ?? []) //  substitute empty list if list is null
    {
      // print string if not empty or null
      if (arg?.isNotEmpty ?? false) {
        print('arg: $arg');
      }
    }
  }

  /// default constructor
  NullSafetyExamples()
      : initializedByConstructor = 12,
        anotherInitializedFinal = 10 //  default value from this constructor
  {
    print('constructor called');
  }

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

  int neverNull = 0; //  has to be initialized!
  int? canBeNull; //  initialization is optional
  int initializedByConstructor;
  final int initializedFinal = 4; //  value cannot change
  final int anotherInitializedFinal; //  value cannot change outside of constructor initialization
  late int aLateValue;
  late final int aLateFinalValue; //  developer is responsible for initializing this prior to use
}
