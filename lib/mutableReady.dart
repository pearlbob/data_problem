import 'dart:collection';

import 'package:meta/meta.dart';

///
///
///  an interface to generate an immutable copy of the correct type when asked
///
abstract class MutableReady<T> {
  T immutable();
}

typedef DynamicValue = dynamic Function();


/// Message variable
@immutable
class MessageVar implements Comparable<MessageVar> {
  const MessageVar(this.name, this.type, this.value);

  @override
  int compareTo(MessageVar other) {
    var ret = name.compareTo(other.name);
    if (ret != 0) {
      return ret;
    }
    ret = type.toString().compareTo(other.type.toString());
    if (ret != 0) {
      return ret;
    }
    return 0;
  }

  final String name;
  final Type type;
  final DynamicValue value;
}

/// lookup for message variables
class MessageValueLookup {
  MessageValueLookup(this.messageVars);

  final SplayTreeSet<MessageVar> messageVars;
}

abstract class MessageValue {
  MessageValueLookup get messageValueLookup;
}
