/// Flutter core models — pure domain contracts: failure types, server error
/// hierarchy, and progress state for domain layers.
///
/// Import this library to access all public types:
/// - [Failure] — root marker interface for all domain failures.
/// - [ApiFailure] and subtypes — typed server/network failures.
/// - [CanceledRequestFailure] — explicit request cancellation.
/// - [ServerFailure] — enum categorising error kinds.
/// - [BaseProgressState] / [DefaultProgressState] — sealed loading state.
///
/// For [DataResponse] and the full networking pipeline, import
/// `package:x_flutter_core/x_flutter_core.dart` instead.
library;

export 'src/domain/failure/failure.dart';
export 'src/domain/failure/networking/server_failure.dart';
export 'src/domain/failure/networking/api_failure.dart';
export 'src/domain/failure/networking/canceled_request_failure.dart';
export 'src/domain/progress_state/progress_state.dart';
