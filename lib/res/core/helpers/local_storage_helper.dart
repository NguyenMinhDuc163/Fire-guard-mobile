import 'package:hive_flutter/hive_flutter.dart';
// su dung Singleton Method Design Pattern de khoi tao doi tuong dung 1 lan
class LocalStorageHelper {
  LocalStorageHelper._internal();
  static final LocalStorageHelper _shared = LocalStorageHelper._internal();
  factory LocalStorageHelper() {
    return _shared;
  }

  Box<dynamic>? hiveBox;

  static initLocalStorageHelper() async {
    _shared.hiveBox = await Hive.openBox('fire_guard');
  }

  static dynamic getValue(String key) {
    return _shared.hiveBox?.get(key);
  }

  static setValue(String key, dynamic val) {
    _shared.hiveBox?.put(key, val);
  }

  static deleteValue(String key) {
    _shared.hiveBox?.delete(key);
  }
}
