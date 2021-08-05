import 'dart:mirrors';

import 'package:dart_generator_test/app_logger.dart';
import 'package:dart_generator_test/models/messageContent.g.dart';
import 'package:logger/logger.dart';
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
      var color = Color(0, 0, 0);
      var tc1 = color.immutable();
      color.blue = 12;
      var tc2 = color.immutable();
      expect(identical(tc1, tc2), isFalse);
      color.blue = 0;
      tc2 = color.immutable();
      expect(tc1, tc2); //  expect the same immutable values
      expect(identical(tc1, tc2), isFalse); //  don't expect the same immutable instances
    }
  });

  test('immutable person', () {
    {
      Logger.level = Level.info;

      var bob1 = Person('bob', 13, Color(0, 0, 255));
      var bob2 = Person('bob', 13, Color(0, 0, 255));
      expect(bob1, bob2);
      var im1 = bob1.immutable();
      logger.i('im1: $im1');
      var im2 = bob2.immutable();
      expect(im1, im2);
      expect(bob1, bob2.immutable());
      expect(bob1.immutable(), bob2);

      logger.i('bob2: $bob2');
      bob2.favoriteColor = Color(255, 0, 255);
      logger.i('bob2: $bob2');
      expect(bob1 == bob2, isFalse);
      expect(im1 == bob2.immutable(), isFalse);
      expect(im1, im2); // should be no changes

      expect(bob1.name, bob2.name);
      expect(bob1.luckyNumber, bob2.luckyNumber);
      expect(im1.name, bob2.name);
      expect(im1.luckyNumber, bob2.luckyNumber);
      expect(im2.name, bob2.name);
      expect(im2.luckyNumber, bob2.luckyNumber);

      expect(bob1.favoriteColor?.green, bob2.favoriteColor?.green);
      expect(im1.favoriteColor?.green, bob2.favoriteColor?.green);
      expect(im2.favoriteColor?.green, bob2.favoriteColor?.green);

      logger.i('im1: $im1');
      expect(im1.favoriteColor?.red, bob1.favoriteColor?.red);

      im2 = bob2.immutable();
      expect(im2.favoriteColor, bob2.favoriteColor);
    }
  });

  test('immutable mirror', () {
    {
      var p = Person('bob', 13, Color(0, 10, 255)).immutable();
      var instanceMirror = reflect(p);
      var entries = instanceMirror.type.declarations.entries;
      for (var entry in entries) {
        if (entry.value is VariableMirror) {
          var name = MirrorSystem.getName(entry.value.simpleName);
          logger.i('\'$name\': ${valueOfSymbol(p, entry.value.simpleName)}');
        }
      }
      expect(valueOf(p, 'name'), 'bob');
      expect(valueOf(p, 'luckyNumber'), 13);
      expect(valueOf(p, 'favoriteColor'), ImmutableColor(0, 10, 255));
      var immutableColor = valueOf(p, 'favoriteColor') as ImmutableColor;
      expect(immutableColor.red, 0);
      expect(immutableColor.green, 10);
      expect(immutableColor.blue, 255);
    }
  });
}

/// return the value of the named field in the given object
dynamic valueOf(Object object, String name) {
  return valueOfSymbol(object, MirrorSystem.getSymbol(name));
}

/// return the value of the symbol for the given object
dynamic valueOfSymbol(Object object, Symbol symbol) {
  var instanceMirror = reflect(object);
  var dec = instanceMirror.type.declarations[symbol];
  if (dec is VariableMirror) {
    return instanceMirror.getField(dec.simpleName).reflectee;
  }
  return null;
}
