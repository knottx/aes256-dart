enum HomePageMode {
  encryption,
  decryption,
  ;

  String get title {
    switch (this) {
      case HomePageMode.encryption:
        return 'Encryption';
      case HomePageMode.decryption:
        return 'Decryption';
    }
  }

  String get textFieldTitle {
    switch (this) {
      case HomePageMode.encryption:
        return 'Text to Encrypt';
      case HomePageMode.decryption:
        return 'Text to Decrypt';
    }
  }

  String get actionTitle {
    switch (this) {
      case HomePageMode.encryption:
        return 'Encrypt';
      case HomePageMode.decryption:
        return 'Decrypt';
    }
  }
}
