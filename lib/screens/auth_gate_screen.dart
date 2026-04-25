import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/app_cubit.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import 'app_entry_screen.dart';
import 'login_screen.dart';

class AuthGateScreen extends StatelessWidget {
  const AuthGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final user = snapshot.data;

        if (user == null) {
          return const LoginScreen();
        }

        return FutureBuilder(
          future: _prepareUserSession(user.uid),
          builder: (context, sessionSnapshot) {
            if (sessionSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return BlocProvider(
              key: ValueKey(user.uid),
              create: (_) => AppCubit(),
              child: const AppEntryScreen(),
            );
          },
        );
      },
    );
  }

  Future<void> _prepareUserSession(String uid) async {
    final savedUid = await StorageService.load('activeUid');

    if (savedUid != null &&
        savedUid.toString().isNotEmpty &&
        savedUid.toString() != uid) {
      await StorageService.clearAll();
    }

    await StorageService.save('activeUid', uid);
  }
}