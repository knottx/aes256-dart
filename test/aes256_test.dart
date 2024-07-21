import 'package:aes256/aes256.dart';
import 'package:test/test.dart';

void main() {
  final text = 'Hello World!';
  final passphrase = 'passphrase';

  test('Verify that the encryption and decryption process works correctly.',
      () async {
    final encrypted = await Aes256.encrypt(text, passphrase);
    // ignore: avoid_print
    print(encrypted);
    final decrypted = await Aes256.decrypt(encrypted, passphrase);

    expect(decrypted, equals(text));
  });

  test('Verify that encryption generates a different value each time.',
      () async {
    final encrypted1 = await Aes256.encrypt(text, passphrase);
    final encrypted2 = await Aes256.encrypt(text, passphrase);

    expect(encrypted1, isNot(equals(encrypted2)));
  });

  test('Verify that encrypted data is a base64 string.', () async {
    final encrypted = await Aes256.encrypt(text, passphrase);

    expect(encrypted, matches(RegExp(r'^[A-Za-z0-9+/]+={0,2}$')));
  });

  test('Decryption fails with an incorrect passphrase', () async {
    final encrypted = await Aes256.encrypt(text, passphrase);
    expect(
      () async => await Aes256.decrypt(encrypted, 'incorrect passphrase'),
      throwsA(isA<ArgumentError>()),
    );
  });
}
