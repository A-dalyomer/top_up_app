abstract class LocalStorageRepository {
  Future<String?> readValue(String valueKey);

  Future<void> writeValue(String valueKey, String value);
}
