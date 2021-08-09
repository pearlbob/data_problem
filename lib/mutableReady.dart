///
///  an interface to generate an immutable copy of the correct type when asked
///
abstract class MutableReady<T> {
  T immutable();
}

/// marker class to identify generated immutable value classes
abstract class ImmutableReady<T extends MutableReady> {
  T toMutable();
}

typedef MessageSink = void Function(ImmutableReady value);

class Message<T extends ImmutableReady> {
  void registerSink(MessageSink sink) {
    if (!_sinks.contains(sink)) {
      _sinks.add(sink);
    }
  }

  void source(T message) {
    for (var sink in _sinks) {
      sink(message);
    }
  }

  final List<MessageSink> _sinks = [];
}
