import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/app_cubit.dart';
import '../cubit/app_state.dart';
import 'pretest_screen.dart';
import 'profile_setup_screen.dart';
import 'root_screen.dart';

class AppEntryScreen extends StatelessWidget {
  const AppEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final cubit = context.read<AppCubit>();

        // Loading dulu (WAIT FIRESTORE)
        if (!state.isLoaded) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Profile belum setup
        if (!cubit.isProfileCompleted) {
          return const ProfileSetupScreen();
        }

        // 🔥 PRETEST CONDITION (FIXED)
        if (!state.hasTakenPreTest) {
          return const PreTestScreen();
        }

        // Normal user flow
        return const RootScreen();
      },
    );
  }
}