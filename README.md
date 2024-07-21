# AES256

AES CBC mode with 256-bit key, PKCS7 padding, and random salt.

```dart
// encryption
final encrypted = await Aes256.encrypt("text", "passphrase");

// decryption
final decrypted = await Aes256.decrypt(encrypted, "passphrase");
```
