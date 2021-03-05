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
