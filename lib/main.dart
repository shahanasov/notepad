import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notepad/core/constants/app_theme.dart';
import 'package:notepad/core/providers/auth_provider.dart';
import 'package:notepad/features/auth/presentation/sign_in.dart';
import 'package:notepad/features/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'My Notepad',
      theme: appTheme,
      home: authState.when(
        data: (user) => user != null ? const HomeScreen() : const LoginScreen(),
        loading: () => const CircularProgressIndicator(),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
