import 'package:onix_flutter_core_models/src/domain/failure/failure.dart';

/// Indicates that a request was deliberately canceled before completion.
///
/// Const-constructible and value-equal to any other [CanceledRequestFailure]
/// instance — two different call sites that cancel requests produce equal
/// failures.
class CanceledRequestFailure implements Failure {
  const CanceledRequestFailure();

  @override
  bool operator ==(Object other) => other is CanceledRequestFailure;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'CanceledRequestFailure{}';
}
