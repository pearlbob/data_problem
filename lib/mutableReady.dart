import 'dart:collection';

import 'package:meta/meta.dart';

///
///
///  an interface to generate an immutable copy of the correct type when asked
///
abstract class MutableReady<T> {
  T immutable();
}

typedef DynamicValueFunction = dynamic Function();


/// Message variable
@immutable
class MessageMember implements Comparable<MessageMember> {
  const MessageMember(this.name, this.type, this.value);

  @override
  int compareTo(MessageMember other) {
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
  final DynamicValueFunction value;
}

/// lookup for message variables
class MessageMemberLookup {
  MessageMemberLookup(this.messageMembers);

  final List<MessageMember> messageMembers;
}

abstract class MessageMembers {
  MessageMemberLookup get messageMemberLookup;
}
