# x_flutter_core_models

Flutter core models — failure types, server error hierarchy, and progress state for domain layers.

## Features

- **`Failure`** — abstract root type for all domain failures.
- **`ApiFailure` hierarchy** — typed server failures covering no-network, unauthorized, too-many-requests, exceptions, and unknown states.
- **`CanceledRequestFailure`** — const-constructible failure for canceled in-flight requests.
- **`BaseProgressState` / `DefaultProgressState`** — sealed progress state for driving loading indicators without coupling UI to business logic.

## Installation

```yaml
dependencies:
  x_flutter_core_models: ^0.1.3
```

## Usage

### Failure types

```dart
import 'package:x_flutter_core_models/x_flutter_core_models.dart';

Future<Result<User>> getUser(String id) async {
  try {
    final data = await api.fetchUser(id);
    return Result.success(data);
  } on SocketException {
    return Result.failure(ConnectionFailure());
  } on UnauthorizedException {
    return Result.failure(ApiUnauthorizedFailure());
  } on ApiException catch (e) {
    return Result.failure(ApiExceptionFailure(message: e.message));
  }
}
```

### Progress state

```dart
import 'package:x_flutter_core_models/x_flutter_core_models.dart';

// Extend BaseProgressState to carry custom data alongside show/hide signals.
class UploadProgressState extends BaseProgressState {
  final double percent;
  const UploadProgressState(this.percent);
}

// Use DefaultProgressState for simple boolean show/hide.
const loading = DefaultProgressState(showProgress: true);
const idle    = DefaultProgressState(showProgress: false);
```

## API reference

| Class | Description |
|---|---|
| `Failure` | Abstract root — implement or extend to create domain-specific failures. |
| `ApiFailure` | Base for all server/network failures; carries `ServerFailure` enum, optional status code, and message. |
| `ApiUndefinedFailure` | Server returned an unrecognized error. |
| `ConnectionFailure` | No network / socket unreachable. |
| `ApiExceptionFailure` | Unexpected exception during an API call. |
| `ApiUnauthorizedFailure` | HTTP 401 / auth token rejected. |
| `ApiTooManyRequestsFailure` | HTTP 429 / rate-limited. |
| `ApiUnknownFailure` | Catch-all when the failure type cannot be determined. |
| `CanceledRequestFailure` | Request was deliberately canceled before completion. |
| `BaseProgressState` | Sealed base for progress state; extend to attach custom payload. |
| `DefaultProgressState` | Simple `showProgress` boolean state for loading indicators. |

## License

MIT
