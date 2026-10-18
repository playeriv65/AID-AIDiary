// Test-only entry point; normal builds use lib/main.dart.
import 'package:flutter_driver/driver_extension.dart';
import 'package:daily_you/main.dart' as app;

void main() {
  enableFlutterDriverExtension();
  app.main();
}
