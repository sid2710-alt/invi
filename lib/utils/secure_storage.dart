import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // Private constructor
  SecureStorage._privateConstructor();

  // Single instance of SecureStorage
  static final SecureStorage _instance = SecureStorage._privateConstructor();

  // Accessor for the instance
  static SecureStorage get instance => _instance;

  // Create the FlutterSecureStorage instance
  final _storage = const FlutterSecureStorage(
    iOptions: IOSOptions(
      // You can customize iOS-specific options here
      accountName: 'userAccount', // Optional: Name for iOS account
    ),
    aOptions: AndroidOptions(
      // Android-specific options (e.g., Encrypted storage, Secure storage)
      encryptedSharedPreferences: true,
    ),
  );

  // Store token securely
  Future<void> storeToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // Retrieve token securely
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token',);
  }

  // Delete token securely
  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }
}
