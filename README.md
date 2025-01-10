# AES256

Available at [pub.dev](https://pub.dev/packages/aes256)

AES CBC mode with 256-bit key, PKCS7 padding, and random salt.

Try on [Demo](https://knottx.github.io/aes256-dart)

```dart
import 'package:aes256/aes256.dart';

...
// encryption
final encrypted = Aes256.encrypt('text', 'passphrase');

// decryption
final decrypted = Aes256.decrypt(encrypted, 'passphrase');
...
```
