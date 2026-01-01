import 'package:blood_link/app/app.dart';
import 'package:blood_link/core/services/hive/hive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  // Initialize Hive service and open boxes before the app runs
  await container.read(hiveServiceProvider).init();
  await container.read(hiveServiceProvider).openBoxes();

  runApp(UncontrolledProviderScope(container: container, child: const App()));
}
