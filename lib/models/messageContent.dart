//  minimal input, largely data fields only
//

/// a color class
class Color {
  Color(this.red, this.green, this.blue);  //  the default constructors are only here to make the file null-safe

  int red;
  int green;
  int blue;
}


//  a person
class Person {
  Person(this.name, this.luckyNumber, {this.favoriteColor});

  String name;
  int luckyNumber;
  Color? favoriteColor;
}


class Address {
  Address(this.addressLine1,this.addressLine2, this.city, this.mailCode, this.stateOrProvince);

  String addressLine1;
  String addressLine2;
  String city;
  String stateOrProvince;
  String mailCode;
}

class Employee {
  Employee(this.person, this.homeAddress, this.workAddress);

  Person person;
  Address homeAddress;
  Address workAddress;
}
