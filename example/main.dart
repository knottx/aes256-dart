import 'package:aes256/aes256.dart';

void main() async {
  // encryption
  final encrypted = await Aes256.encrypt('text', 'passphrase');

  // decryption
  final decrypted = await Aes256.decrypt(encrypted, 'passphrase');
}
