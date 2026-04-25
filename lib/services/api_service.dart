import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/security_tip.dart';

class ApiService {
  static const String _cisaKevUrl =
      'https://www.cisa.gov/sites/default/files/feeds/known_exploited_vulnerabilities.json';

  static Future<List<SecurityTip>> fetchSecurityTips() async {
    final awarenessTips = _fallbackAwarenessTips();

    try {
      final response = await http
          .get(Uri.parse(_cisaKevUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        return awarenessTips;
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final vulnerabilities = decoded['vulnerabilities'] as List<dynamic>?;

      if (vulnerabilities == null || vulnerabilities.isEmpty) {
        return awarenessTips;
      }

      final liveTips = vulnerabilities
          .take(8)
          .map(
            (item) => SecurityTip.fromCisaKev(
          Map<String, dynamic>.from(item as Map),
        ),
      )
          .toList();

      return [
        ...awarenessTips,
        ...liveTips,
      ];
    } catch (_) {
      return awarenessTips;
    }
  }

  static List<SecurityTip> _fallbackAwarenessTips() {
    return const [
      SecurityTip(
        title: 'Check Links Before Clicking',
        description:
        'Always inspect links in emails or messages before clicking. Avoid opening links from unknown senders or urgent messages asking for personal information.',
        category: 'Phishing',
        source: 'CyberBuddy Awareness',
      ),
      SecurityTip(
        title: 'Use Strong and Unique Passwords',
        description:
        'Create different passwords for different accounts. A strong password should include uppercase letters, lowercase letters, numbers, and symbols.',
        category: 'Password',
        source: 'CyberBuddy Awareness',
      ),
      SecurityTip(
        title: 'Enable Two-Factor Authentication',
        description:
        'Two-factor authentication adds an extra layer of security by requiring a second verification step besides your password.',
        category: 'Password',
        source: 'CyberBuddy Awareness',
      ),
      SecurityTip(
        title: 'Avoid Unknown App Downloads',
        description:
        'Only download apps from trusted sources such as Google Play Store or official websites. Unknown APK files may contain malware.',
        category: 'Malware',
        source: 'CyberBuddy Awareness',
      ),
      SecurityTip(
        title: 'Update Your Device Regularly',
        description:
        'System and app updates often include security patches that protect your device from newly discovered vulnerabilities.',
        category: 'Live Vulnerabilities',
        source: 'CyberBuddy Awareness',
      ),
      SecurityTip(
        title: 'Protect Your Personal Information',
        description:
        'Avoid sharing your address, phone number, identification number, or account details publicly on social media.',
        category: 'Privacy',
        source: 'CyberBuddy Awareness',
      ),
      SecurityTip(
        title: 'Report Suspicious Activity',
        description:
        'If you notice suspicious login attempts or account changes, change your password immediately and report the incident to the platform or administrator.',
        category: 'Incident',
        source: 'CyberBuddy Awareness',
      ),
    ];
  }
}