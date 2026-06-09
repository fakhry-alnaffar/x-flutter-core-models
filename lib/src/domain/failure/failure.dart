/// Marker interface for all domain failures.
///
/// Implement [Failure] to introduce a new failure type. Callers should match
/// against concrete subtypes rather than [Failure] itself.
abstract interface class Failure {}
