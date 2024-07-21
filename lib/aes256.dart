import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class Aes256 {
  Aes256._();

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
