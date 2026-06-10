/// Sealed hierarchy for progress / loading state.
///
/// Extend [BaseProgressState] to attach custom payload to progress signals
/// (e.g. upload percentage, step label). Use [DefaultProgressState] for
/// simple show / hide loading indicators.
sealed class BaseProgressState {
  const BaseProgressState();
}

/// Simple boolean progress state for show / hide loading indicators.
///
/// [showProgress] drives visibility; [copyWith] produces a mutated copy
/// without breaking `const` usage at call sites.
class DefaultProgressState extends BaseProgressState {
  /// Whether a loading indicator should be shown.
  final bool showProgress;

  const DefaultProgressState({required this.showProgress});

  /// Returns a copy with [showProgress] replaced when provided.
  DefaultProgressState copyWith({bool? showProgress}) =>
      DefaultProgressState(showProgress: showProgress ?? this.showProgress);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
          other is DefaultProgressState &&
          other.showProgress == showProgress);

  @override
  int get hashCode => showProgress.hashCode;

  @override
  String toString() => 'DefaultProgressState{showProgress: $showProgress}';
}
