import 'package:flutter/material.dart';
import '../data/module_data.dart';

class ModuleContentScreen extends StatelessWidget {
  final CyberModule module;

  const ModuleContentScreen({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: Text(
          module.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Interactive Header Section
            Center(
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: const Color(0xFF3F51B5).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  module.tag == 'phishing'
                      ? Icons.alternate_email_rounded
                      : Icons.lock_person_rounded,
                  size: 80,
                  color: const Color(0xFF3F51B5),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 2. Comprehensive Introduction
            const Text(
              "Executive Summary",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "In this module, we dive deep into the mechanics of ${module.title}. As a university student, your academic and personal data are high-value targets. This lesson is designed to equip you with the defensive mindset required to identify, report, and mitigate specific cyber threats related to ${module.tag}.",
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF4A4A4A),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),

            // 3. Deep Dive: Learning Objectives
            _buildLearningSection("Learning Objectives", [
              "Understand the primary attack vectors for ${module.tag}.",
              "Recognize the psychological triggers used by attackers.",
              "Implement proactive defense strategies in your daily digital life.",
              "Learn the standard incident reporting procedure at the university.",
            ]),

            const SizedBox(height: 32),

            // 4. Detailed Micro-learning Tips (The Core Content)
            const Text(
              "Strategic Security Protocols",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailedTipCard(
              "Verify Source Integrity",
              "Scammers often spoof email headers. Hover over the sender's name to see the actual email address. If it doesn't end in '@uitm.edu.my' or the expected domain, it's a major red flag.",
              Icons.verified_user_outlined,
            ),
            _buildDetailedTipCard(
              "Analyze Urgency Cues",
              "Attacks often use 'Social Engineering' to create panic. Phrases like 'Your account will be deleted in 2 hours' are designed to stop you from thinking clearly.",
              Icons.notification_important_outlined,
            ),
            _buildDetailedTipCard(
              "Encryption & Privacy",
              "Ensure all logins use HTTPS. Never input sensitive university credentials into a site that triggers a 'Not Secure' browser warning.",
              Icons.enhanced_encryption_outlined,
            ),
            _buildDetailedTipCard(
              "Two-Factor Authentication (2FA)",
              "Even if your password is stolen, 2FA acts as a secondary shield. Ensure your student portal has this enabled immediately.",
              Icons.app_registration_rounded,
            ),

            const SizedBox(height: 40),

            // 5. Completion Action
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F51B5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                  shadowColor: const Color(0xFF3F51B5).withOpacity(0.4),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "COMPLETE LESSON",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLearningSection(String title, List<String> points) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF3F51B5).withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const SizedBox(height: 12),
          ...points.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "• ",
                    style: TextStyle(
                      color: Color(0xFF3F51B5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      p,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedTipCard(String title, String desc, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF3F51B5).withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: const Color(0xFF3F51B5), size: 24),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
