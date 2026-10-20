// Test-only entry point; normal builds use lib/main.dart.
import 'package:flutter_driver/driver_extension.dart';
import 'package:aid_diary/main.dart' as app;

void main() {
  enableFlutterDriverExtension();
  app.main();
}
