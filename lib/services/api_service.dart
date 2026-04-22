import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/security_tip.dart';

class ApiService {
  static Future<List<SecurityTip>> fetchSecurityTips() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=5'),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        return data
            .map((item) => SecurityTip.fromJson(item))
            .toList();
      } else {
        return _fallbackTips();
      }
    } catch (_) {
      return _fallbackTips();
    }
  }

  static List<SecurityTip> _fallbackTips() {
    return const [
      SecurityTip(
        title: 'Avoid Suspicious Links',
        description:
        'Do not click links from unknown emails or messages without checking the sender and destination first.',
      ),
      SecurityTip(
        title: 'Use Strong Passwords',
        description:
        'Create unique passwords using a mix of letters, numbers, and symbols to reduce account compromise risk.',
      ),
      SecurityTip(
        title: 'Enable Two-Factor Authentication',
        description:
        'Activate 2FA whenever available to add an extra layer of protection to your accounts.',
      ),
      SecurityTip(
        title: 'Update Your Device Regularly',
        description:
        'Keep your phone and apps updated to reduce security vulnerabilities and malware risks.',
      ),
      SecurityTip(
        title: 'Protect Your Privacy',
        description:
        'Review social media privacy settings regularly and avoid oversharing personal information online.',
      ),
    ];
  }
}