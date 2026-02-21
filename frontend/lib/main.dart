import 'package:flutter/material.dart';
import 'package:mine_wadhwani/app.dart';
import 'package:mine_wadhwani/core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const App());
}
