import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

/// A utility class for AES-256 encryption and decryption.
class Aes256 {
  Aes256._();

  /// Generates a salted key and initialization vector (IV) from a passphrase and salt.
  ///
  /// This method derives a key and IV for AES-256 encryption from the given
  /// passphrase and salt using the MD5 hash function.
  ///
  /// Parameters:
  /// - `passphrase`: The passphrase used to generate the key.
  /// - `salt`: The salt used in key and IV generation.
  ///
  /// Returns:
  /// - A list of integers representing the salted key and IV.
  static List<int> _generateSaltedKeyAndIv(String passphrase, List<int> salt) {
    final pass = utf8.encode(passphrase);
    var dx = <int>[];
    var salted = <int>[];

    while (salted.length < 48) {
      final data = dx + pass + salt;
      dx = md5.convert(data).bytes;
      salted.addAll(dx);
    }

    return salted;
  }

  /// Encrypts a string using AES-256 with the given passphrase.
  ///
  /// This method encrypts the provided `text` using AES-256 encryption in CBC mode.
  /// It generates a random salt, derives the key and IV from the passphrase and salt,
  /// and then encrypts the text.
  ///
  /// Parameters:
  /// - `text`: The string to be encrypted.
  /// - `passphrase`: The passphrase used to derive the key and IV.
  ///
  /// Returns:
  /// - A base64 encoded string containing the encrypted data and the salt.
  ///
  /// Throws:
  /// - An error if encryption fails.
  static Future<String> encrypt(String text, String passphrase) async {
    try {
      final random = Random.secure();
      final salt = List<int>.generate(8, (_) => random.nextInt(256));
      final salted = _generateSaltedKeyAndIv(passphrase, salt);

      final key = Key(Uint8List.fromList(salted.sublist(0, 32)));
      final iv = IV(Uint8List.fromList(salted.sublist(32, 48)));
      final encryptor = Encrypter(AES(key, mode: AESMode.cbc));

      final encrypted = encryptor.encrypt(text, iv: iv).bytes;
      final saltedPrefix = utf8.encode('Salted__');
      final result = saltedPrefix + salt + encrypted;

      return base64.encode(result);
    } catch (error) {
      rethrow;
    }
  }

  /// Decrypts a base64 encoded string using AES-256 with the given passphrase.
  ///
  /// This method decrypts the provided `encoded` string, which must be the result
  /// of the `encrypt` method. It extracts the salt and encrypted data, derives
  /// the key and IV from the passphrase and salt, and then decrypts the data.
  ///
  /// Parameters:
  /// - `encoded`: The base64 encoded string containing the encrypted data and salt.
  /// - `passphrase`: The passphrase used to derive the key and IV.
  ///
  /// Returns:
  /// - The decrypted string if decryption is successful, or `null` if the decryption
  ///   fails (e.g., if the encoded data does not start with 'Salted__').
  ///
  /// Throws:
  /// - An error if decryption fails.
  static Future<String?> decrypt(String encoded, String passphrase) async {
    try {
      final enc = base64.decode(encoded);
      final saltedPrefix = utf8.decode(enc.sublist(0, 8));

      if (saltedPrefix != 'Salted__') return null;

      final salt = enc.sublist(8, 16);
      final text = enc.sublist(16);
      final salted = _generateSaltedKeyAndIv(passphrase, salt);

      final key = Key(Uint8List.fromList(salted.sublist(0, 32)));
      final iv = IV(Uint8List.fromList(salted.sublist(32, 48)));
      final encryptor = Encrypter(AES(key, mode: AESMode.cbc));

      return encryptor.decrypt(Encrypted(Uint8List.fromList(text)), iv: iv);
    } catch (error) {
      rethrow;
    }
  }
}
