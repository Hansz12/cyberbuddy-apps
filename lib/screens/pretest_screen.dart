import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/app_cubit.dart';
import 'root_screen.dart';

class PreTestScreen extends StatefulWidget {
  const PreTestScreen({super.key});

  @override
  State<PreTestScreen> createState() => _PreTestScreenState();
}

class _PreTestScreenState extends State<PreTestScreen> {
  int score = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pre-Test")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Basic Cybersecurity Test",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                score = 60; // dummy score
                context.read<AppCubit>().completePreTest(score);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RootScreen(),
                  ),
                );
              },
              child: const Text("Finish Pre-Test"),
            ),
          ],
        ),
      ),
    );
  }
}