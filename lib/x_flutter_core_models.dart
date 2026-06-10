/// Flutter core models — failure types, server error hierarchy, and progress
/// state for domain layers.
///
/// Import this library to access all public types:
/// - [DataResponse] — standard response contract for data layers.
/// - [Failure] — root marker interface for all domain failures.
/// - [ApiFailure] and subtypes — typed server/network failures.
/// - [CanceledRequestFailure] — explicit request cancellation.
/// - [ServerFailure] — enum categorising error kinds.
/// - [BaseProgressState] / [DefaultProgressState] — sealed loading state.
library;

import 'src/domain/data_response/data_response.dart';

export 'src/domain/data_response/data_response.dart';
export 'src/domain/failure/failure.dart';
export 'src/domain/failure/networking/server_failure.dart';
export 'src/domain/failure/networking/api_failure.dart';
export 'src/domain/failure/networking/canceled_request_failure.dart';
export 'src/domain/progress_state/progress_state.dart';

/// Legacy alias for [DataResponse].
///
/// Use [DataResponse] instead.
@Deprecated('Use DataResponse instead')
typedef Result<T> = DataResponse<T>;
