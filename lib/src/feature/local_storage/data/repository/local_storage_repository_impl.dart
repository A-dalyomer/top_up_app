import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/repository/local_storage_repository.dart';

class LocalStorageRepositoryImpl implements LocalStorageRepository {
  LocalStorageRepositoryImpl({required this.storageClient});
  final FlutterSecureStorage storageClient;

  @override
  Future<String?> readValue(String valueKey) async {
    return await storageClient.read(key: valueKey);
  }

  @override
  Future<void> writeValue(String valueKey, String value) async {
    return await storageClient.write(key: valueKey, value: value);
  }

  @override
  Future<void> removeValue(String valueKey) async {
    return await storageClient.delete(key: valueKey);
  }
}
