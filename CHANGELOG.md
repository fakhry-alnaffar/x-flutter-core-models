## 0.1.4

- Added dartdoc comments to all public constructors and the library directive
- Added `example/example.dart` demonstrating failure handling and progress state

## 0.1.3

- Fix stale "Onix" branding in README description

## 0.1.2

- Updated repository URL to `https://github.com/fakhry-alnaffar/x-flutter-core-models`
- Updated README installation version

## 0.1.1

- Renamed package from `onix_flutter_core_models` to `x_flutter_core_models`

## 0.1.0

- Added `ServerFailure.undefined` — distinct enum value for unrecognised/unexpected error payloads, so `ApiUndefinedFailure` and `ApiUnknownFailure` no longer share `ServerFailure.unknown` (breaking: exhaustive switches on `ServerFailure` must add the new arm)
- Fixed `CanceledRequestFailure.==` / `hashCode` contract violation — `operator==` now uses `runtimeType` guard, consistent with `ApiFailure` and `DefaultProgressState`
- Fixed `DefaultProgressState.==` — added `runtimeType` guard to prevent subclass instances from comparing equal to base-type instances
- Lowered SDK constraint from `^3.12.0` to `^3.0.0` — no Dart 3.12-specific features are used

## 0.0.3

- Raised Dart SDK lower bound to `>=3.12.0` — package language version now resolves to 3.12
- Added `analysis_options.yaml` with `package:lints/recommended.yaml`
- Added `lints ^6.1.0` as dev dependency
- Added pub.dev `topics` metadata
- Expanded `description` field
- Corrected `repository` URL to fork
- Removed deprecated `library` directive from barrel file
- Populated `README.md` with usage examples and API reference

## 0.0.2

- Added BaseProgress class

## 0.0.1

- Initial version.
