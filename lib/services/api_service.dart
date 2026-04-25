import '../models/security_tip.dart';

class ApiService {
  static Future<List<SecurityTip>> fetchSecurityTips() async {
    await Future.delayed(const Duration(milliseconds: 600));

    return const [
      SecurityTip(
        title: 'Check Links Before Clicking',
        description:
        'Always inspect links in emails or messages before clicking. Avoid opening links from unknown senders or urgent messages asking for personal information.',
      ),
      SecurityTip(
        title: 'Use Strong and Unique Passwords',
        description:
        'Create different passwords for different accounts. A strong password should include uppercase letters, lowercase letters, numbers, and symbols.',
      ),
      SecurityTip(
        title: 'Enable Two-Factor Authentication',
        description:
        'Two-factor authentication adds an extra layer of security by requiring a second verification step besides your password.',
      ),
      SecurityTip(
        title: 'Avoid Unknown App Downloads',
        description:
        'Only download apps from trusted sources such as Google Play Store or official websites. Unknown APK files may contain malware.',
      ),
      SecurityTip(
        title: 'Update Your Device Regularly',
        description:
        'System and app updates often include security patches that protect your device from newly discovered vulnerabilities.',
      ),
      SecurityTip(
        title: 'Protect Your Personal Information',
        description:
        'Avoid sharing your address, phone number, identification number, or account details publicly on social media.',
      ),
      SecurityTip(
        title: 'Report Suspicious Activity',
        description:
        'If you notice suspicious login attempts or account changes, change your password immediately and report the incident to the platform or administrator.',
      ),
    ];
  }
}