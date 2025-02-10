import 'dart:io';

class Constants {
  static String getDevBaseUrl() {
    if (Platform.isIOS) {
      return 'http://localhost:5500/api';
    }

    return 'http://10.0.2.2:5500/api';
  }

  static String getDevWebsocketUrl() {
    if (Platform.isIOS) {
      return 'ws://localhost:5500';
    }

    return 'ws://10.0.2.2:5500';
  }

  ///
  static String getProdBaseUrl() {
    if (Platform.isIOS) {
      return 'http://localhost:5500/api';
    }

    return 'http://10.0.2.2:5500/api';
  }

  static String getProdWebsocketUrl() {
    if (Platform.isIOS) {
      return 'ws://localhost:5500';
    }

    return 'ws://10.0.2.2:5500';
  }
}
