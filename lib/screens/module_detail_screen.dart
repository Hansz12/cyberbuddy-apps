import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/app_cubit.dart';
import '../cubit/app_state.dart';
import 'quiz_screen.dart';

class ModuleDetailScreen extends StatelessWidget {
  const ModuleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final module = state.selectedModule;

        if (module == null) {
          return const Scaffold(
            body: Center(
              child: Text('No module selected'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Learning Module'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF4338CA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        module.icon,
                        color: Colors.white,
                        size: 36,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        module.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        module.description,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          Chip(
                            label: Text(module.category),
                            backgroundColor: Colors.white,
                          ),
                          Chip(
                            label: Text(module.difficulty),
                            backgroundColor: Colors.white,
                          ),
                          Chip(
                            label: Text(module.duration),
                            backgroundColor: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Micro-learning content',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _getModuleContent(module.id),
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () {
                              context.read<AppCubit>().completeLearning();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const QuizScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Mark as Completed & Take Quiz',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getModuleContent(String id) {
    switch (id) {
      case 'phishing':
        return '''
Phishing is a cyber attack that tricks users into revealing sensitive information such as passwords, banking details, or personal data.

Common warning signs of phishing:
• Urgent messages like “Your account will be suspended”
• Suspicious sender email addresses
• Fake links that imitate real websites
• Attachments from unknown sources

Safe practices:
• Always verify the sender’s email
• Never click unknown or shortened links without checking
• Inspect the website URL before entering credentials
• Report suspicious emails instead of replying

Why this matters:
Phishing is one of the most common cyber threats faced by students because email, banking apps, and university systems are frequently targeted.
''';

      case 'password':
        return '''
Strong passwords are essential to protect personal, academic, and financial accounts from unauthorized access.

Good password practices:
• Use at least 8 to 12 characters
• Combine uppercase, lowercase, numbers, and symbols
• Create unique passwords for different accounts
• Use a password manager if needed

Unsafe password habits:
• Reusing the same password on multiple accounts
• Using your name, birthday, or phone number
• Sharing passwords with others
• Saving passwords in plain text files

Why this matters:
Weak passwords make it easier for attackers to break into accounts, especially when users reuse the same credentials across many platforms.
''';

      case 'malware':
        return '''
Malware refers to harmful software designed to damage systems, steal data, or gain unauthorized access to devices.

Common sources of malware:
• Downloading apps from untrusted sites
• Clicking infected attachments or links
• Installing cracked software or APK files
• Visiting malicious websites

Protection tips:
• Only install apps from trusted sources such as Google Play
• Keep your phone and apps updated
• Avoid suspicious pop-ups and unknown downloads
• Use security features already available on your device

Why this matters:
Students often download files, notes, apps, and software from different sources, which increases the risk of malware infection.
''';

      case 'privacy':
        return '''
Privacy on social media is important because oversharing personal details can expose users to identity theft, scams, stalking, and social engineering.

Examples of risky oversharing:
• Posting your full address or phone number
• Sharing real-time location publicly
• Uploading student ID or important documents
• Revealing daily routine patterns

How to protect your privacy:
• Set accounts to private when possible
• Review privacy settings regularly
• Limit who can see your posts and stories
• Avoid sharing sensitive personal or academic information

Why this matters:
Cybercriminals can use small pieces of public information to build trust, impersonate you, or launch targeted attacks.
''';

      case 'incident':
        return '''
A cyber incident is any suspicious or harmful digital event, such as an account hack, data leak, phishing attempt, or unauthorized login.

Examples:
• Receiving login alerts you did not trigger
• Losing access to an account suddenly
• Finding strange messages sent from your profile
• Clicking a fake link and entering your password

Immediate response steps:
• Change your password as soon as possible
• Log out from other devices if available
• Report the issue to the relevant authority or administrator
• Keep evidence such as screenshots or suspicious emails

Why this matters:
Fast action can reduce damage, stop further misuse, and help protect both the victim and other users.
''';

      default:
        return 'Learning content not available.';
    }
  }
}