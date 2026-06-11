//ignore: one_member_abstracts

/// Converts an object of type [T] to type [E].
///
/// Implement this for class-based mapper objects. For simpler cases prefer
/// Dart extension methods (`extension XMapper on X { E toEntity() { ... } }`).
abstract class Mapper<T, E> {
  /// Converts [from] to [E].
  E map(T from);
}

/// A [Mapper] that also supports bulk conversion of iterables.
abstract class MapperIterable<T, E> extends Mapper<T, E> {
  /// Converts each element of [from] using [map] and returns the results.
  Iterable<E> mapList(Iterable<T> from) {
    return from.map(map);
  }
}
