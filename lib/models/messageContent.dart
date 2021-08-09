//  minimal input, largely data fields only
//

/// a color class
class Color {
  int red = 0; //  initial values only to make this file null-safe
  int green = 0;
  int blue = 0;
}

//  a person
class Person {
  String name = '';
  int luckyNumber = 0;
  Color? favoriteColor;
}

class Address {
  String addressLine1 = '';
  String addressLine2 = '';
  String city = '';
  String stateOrProvince = '';
  String mailCode = '';
}

class Employee {
  Employee(this.person, this.homeAddress, this.workAddress);

  Person person;
  Address homeAddress;
  Address workAddress;
}
