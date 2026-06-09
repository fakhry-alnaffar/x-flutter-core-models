# Migration & Refactoring Report
## onix_flutter_core_models

**Author:** Fakhry H. Al-Naffar  
**Date:** 2026-06-09  
**Version:** 0.0.2 → 0.0.3  
**Dart SDK:** 3.0.0 → 3.12.0  
**Flutter SDK:** 3.44.0  

---

## 1. Executive Summary

The package was audited, migrated to Dart SDK 3.12.0, modernised for pub.dev
publication standards, and refactored to senior-level clean architecture.
The public API surface is fully tested (40 tests, 0 failures), the analyser
reports zero issues at `--fatal-infos --fatal-warnings`, and `pub publish
--dry-run` passes with zero errors.

---

## 2. Starting State

| Property | Value |
|---|---|
| Version | 0.0.2 |
| SDK constraint | `>=3.0.0 <4.0.0` |
| Language version | 3.0 |
| Dependencies | none |
| Dev dependencies | none |
| Linting | none |
| Tests | none |
| README | empty |
| Generated code | none |
| `dart analyze` | clean |

---

## 3. Changes by Category

### 3.1 SDK & Environment

| File | Change |
|---|---|
| `pubspec.yaml` | SDK lower bound raised from `>=3.0.0` to `>=3.12.0` |
| `.dart_tool/package_config.json` | `languageVersion` resolved from `3.0` to `3.12` |

**Effect:** All Dart 3.12 language features are now available in package
source — enhanced patterns, exhaustive switches over sealed classes, extension
types, wildcard variables, and null-aware collection elements.

---

### 3.2 Linting & Analysis

| File | Change |
|---|---|
| `analysis_options.yaml` | Created — includes `package:lints/recommended.yaml` |
| `pubspec.yaml` | Added `lints: ^6.1.0` to `dev_dependencies` |

Result: `dart analyze --fatal-infos --fatal-warnings` → **No issues found**

---

### 3.3 Architecture — `Failure`

**File:** `lib/src/domain/failure/failure.dart`

| Before | After |
|---|---|
| `abstract class Failure {}` | `abstract interface class Failure {}` |

**Why:** `Failure` has no shared implementation — it is a pure marker
contract. The `interface` modifier makes that intent explicit at the type
level and prevents consumers from using `extends` (which would be
semantically wrong for a marker type). Both existing subtypes already used
`implements`, so this is non-breaking for them.

---

### 3.4 Architecture — `ServerFailure`

**File:** `lib/src/domain/failure/networking/server_failure.dart` *(new)*

Extracted from `api_failure.dart` (single-responsibility) and upgraded from
a plain enum to an **enhanced enum** with a `label` field.

```dart
// Before — plain enum, buried in api_failure.dart
enum ServerFailure {
  noNetwork, exception, unAuthorized, tooManyRequests, response, unknown,
}

// After — enhanced enum, own file, correct naming
enum ServerFailure {
  noNetwork('No network connection'),
  exception('Request exception'),
  unauthorized('Unauthorized'),          // renamed from unAuthorized
  tooManyRequests('Too many requests'),
  response('Server response error'),
  unknown('Unknown error');

  const ServerFailure(this.label);
  final String label;
}
```

**Breaking change:** `ServerFailure.unAuthorized` renamed to
`ServerFailure.unauthorized` — consistent Dart camelCase.

---

### 3.5 Architecture — `ApiFailure` hierarchy

**File:** `lib/src/domain/failure/networking/api_failure.dart`

#### `ApiFailure` made abstract

```dart
// Before
class ApiFailure implements Failure { ... }

// After
abstract class ApiFailure implements Failure { ... }
```

**Why:** `ApiFailure` was never meant to be instantiated directly — every
valid error case has a named subtype. Making it abstract enforces correct
usage at compile time.  
**Breaking change:** `ApiFailure(ServerFailure.x, ...)` no longer compiles.

#### `ApiResponseFailure` added

Fills the gap for `ServerFailure.response`, which previously had no
corresponding concrete class.

```dart
class ApiResponseFailure extends ApiFailure {
  const ApiResponseFailure({required int statusCode, String message = ''})
      : super(ServerFailure.response, statusCode: statusCode, message: message);
}
```

#### `toString` deduplicated

7 near-identical `toString` overrides replaced by one on the base using
`runtimeType`:

```dart
// Before — repeated in every subclass
@override
String toString() => 'ConnectionFailure{failure: $failure}';

// After — single implementation on ApiFailure
@override
String toString() =>
    '$runtimeType{failure: $failure, statusCode: $statusCode, message: $message}';
```

#### `const` constructors

All subclasses now have `const` constructors — consumers can use compile-time
constants (`const ConnectionFailure()`, `const ApiUnauthorizedFailure()`, etc.).

#### Value equality

`==` and `hashCode` added to `ApiFailure` based on
`runtimeType + failure + statusCode + message`. Two instances of the same
concrete subtype with identical fields are now equal.

---

### 3.6 `CanceledRequestFailure`

**File:** `lib/src/domain/failure/networking/canceled_request_failure.dart`

| Added | Detail |
|---|---|
| `==` / `hashCode` | Value equality — two `CanceledRequestFailure()` instances are equal |
| `toString` | Returns `CanceledRequestFailure{}` |

---

### 3.7 `DefaultProgressState`

**File:** `lib/src/domain/progress_state/progress_state.dart`

| Added | Detail |
|---|---|
| `==` / `hashCode` | Value equality based on `showProgress` |
| `copyWith` | `copyWith({bool? showProgress})` — produces a mutated copy |
| `toString` | Returns `DefaultProgressState{showProgress: true/false}` |
| Doc comments | On sealed base and concrete class |

---

### 3.8 Barrel file

**File:** `lib/onix_flutter_core_models.dart`

- Removed deprecated `library onix_flutter_core_models;` directive
- Added export for `server_failure.dart`

---

### 3.9 Package metadata

**File:** `pubspec.yaml`

| Field | Before | After |
|---|---|---|
| `description` | `Onix Flutter core models` | Extended with feature summary |
| `repository` | `OnixFlutterTeam/...` | `fakhry-alnaffar/...` (corrected to fork) |
| `topics` | absent | `failure`, `models`, `domain`, `networking` |
| `version` | `0.0.2` | `0.0.3` |

---

### 3.10 README

**File:** `README.md`

Populated from empty. Now contains:
- Feature overview
- Installation snippet
- Usage examples (failure handling, progress state)
- Full API reference table

---

### 3.11 Tests

**File:** `test/core_models_test.dart`

| Before | After |
|---|---|
| No tests | 40 tests, 0 failures |
| — | `package:test` with `group` / `test` / `expect` |
| — | Covers all public types and behaviours |

---

## 4. Final File Structure

```
lib/
  onix_flutter_core_models.dart          ← barrel export
  src/domain/
    failure/
      failure.dart                        ← abstract interface class Failure
      networking/
        server_failure.dart               ← ServerFailure enhanced enum (NEW)
        api_failure.dart                  ← abstract ApiFailure + 7 subtypes
        canceled_request_failure.dart     ← CanceledRequestFailure
    progress_state/
      progress_state.dart                 ← sealed BaseProgressState + DefaultProgressState
test/
  core_models_test.dart                   ← 40 tests (NEW)
analysis_options.yaml                     ← linting (NEW)
```

---

## 5. Breaking Changes Summary

Requires a semver bump before publishing to pub.dev.

| Change | Type | Migration |
|---|---|---|
| `ServerFailure.unAuthorized` → `ServerFailure.unauthorized` | Rename | Find & replace |
| `ApiFailure` is now `abstract` | Abstract | Use a typed subtype instead |
| `Failure` is now `interface` | Constraint | Change `extends Failure` to `implements Failure` |

---

## 6. Success Criteria Results

| Criterion | Result |
|---|---|
| `dart pub get` | PASS |
| `dart analyze --fatal-infos --fatal-warnings` | PASS — 0 issues |
| `dart test` | PASS — 40 / 40 |
| `dart pub publish --dry-run` | PASS — 0 errors |
| No runtime dependencies added | PASS |
| No generated files | N/A — package has no code generation |

---

## 7. Recommended Next Steps

1. Bump version to `0.0.4` in `pubspec.yaml`
2. Update `CHANGELOG.md` with breaking changes listed in section 5
3. Commit and push to `fakhry-alnaffar/onix-flutter-core-models`
4. Open pull request to `OnixFlutterTeam/onix-flutter-core-models`
5. Notify consumers of the three breaking changes before they upgrade
