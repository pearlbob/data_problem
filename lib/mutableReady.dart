///
///
///  an interface to generate an immutable copy of the correct type when asked
///
abstract class MutableReady<T> {
  T immutable();
}