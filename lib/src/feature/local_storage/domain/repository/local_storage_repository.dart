/// Contract for local key-value storage
abstract class LocalStorageRepository {
  /// Reads a value associated with the given [valueKey]
  /// Returns a `String` if found or `null` if the key does not exist
  Future<String?> readValue(String valueKey);

  /// Writes the [value] to the storage associated with the given [valueKey]
  Future<void> writeValue(String valueKey, String value);

  /// Removes the value associated with the given [valueKey]
  Future<void> removeValue(String valueKey);
}
