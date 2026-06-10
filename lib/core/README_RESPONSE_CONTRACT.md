# Response Contract (x_flutter_core_models)

## ✅ Official Type

All network and repository responses MUST use:

```dart
DataResponse<T>
```

---

## ❌ Deprecated

`Result<T>` is no longer part of the public API and must NOT be used in external projects.

---

## 🧠 Architecture Rule

```
RequestProcessor → DataResponse<T> → Repository → Domain/UI
```

There is no Result layer in the official contract.

---

## ⚠️ Migration Note

If legacy code uses Result<T>, replace it with DataResponse<T>.

```dart
// Before
Future<Result<User>> getUser();

// After
Future<DataResponse<User>> getUser();
```
