import 'package:hive/hive.dart';

Future<bool> checkFlagValue() async {
  var box = await Hive.openBox('flag');
  bool flagValue = box.get('flagKey', defaultValue: false);
  return flagValue;
}

Future<void> setFlagValue(bool value) async {
  var box = await Hive.openBox('flag');
  await box.put('flagKey', value);
}
