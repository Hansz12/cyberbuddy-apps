import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/app_cubit.dart';
import 'pretest_screen.dart';
import 'root_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController =
  TextEditingController(text: 'Farhana');

  String selectedLevel = 'Beginner';

  final List<String> selectedInterests = ['phishing', 'privacy'];

  final List<String> allInterests = [
    'phishing',
    'password',
    'privacy',
    'malware',
    'incident',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1D4ED8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      color: Colors.white,
                      size: 38,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'CyberBuddy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Gamified mobile learning app with content-based recommendation.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Student name',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Learning level',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: ['Beginner', 'Intermediate'].map((level) {
                  final selected = selectedLevel == level;

                  return ChoiceChip(
                    label: Text(level),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        selectedLevel = level;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Topic interests',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: allInterests.map((interest) {
                  final selected = selectedInterests.contains(interest);

                  return FilterChip(
                    label: Text(interest),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        if (selected) {
                          selectedInterests.remove(interest);
                        } else {
                          selectedInterests.add(interest);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    await context.read<AppCubit>().setupProfile(
                      name: _nameController.text.trim().isEmpty
                          ? 'Farhana'
                          : _nameController.text.trim(),
                      level: selectedLevel,
                      interests: selectedInterests,
                    );

                    final cubit = context.read<AppCubit>();

                    if (!mounted) return;

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => cubit.state.hasTakenPreTest
                            ? const RootScreen()
                            : const PreTestScreen(),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text('Enter App'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}