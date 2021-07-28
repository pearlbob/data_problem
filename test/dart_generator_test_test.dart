
import 'package:dart_generator_test/models/messageContent.g.dart';
import 'package:test/test.dart';

void main() {
  test('immutable color', () {
    {
      var color = Color(0, 0, 0);
      var tc1 = color.immutable();
      var tc2 = color.immutable();
      expect(tc1, tc2); //  expect the same immutable instance
      expect(identical(tc1, tc2), isTrue);

      color = Color(0, 0, 0);
      tc2 = color.immutable();
      expect(identical(tc1, tc2), isFalse); //  expect a new immutable instance
      expect(tc1, tc2);
    }
    {
      var color = Color( 0,0,0);
      var tc1 = color.immutable();
      color.blue = 12;
      var tc2 = color.immutable();
      expect(identical(tc1, tc2), isFalse);
      color.blue = 0;
      tc2 = color.immutable();
      expect(tc1, tc2); //  expect the same immutable values
      expect(identical(tc1, tc2), isFalse);//  don't expect the same immutable instances
    }


  });
}
