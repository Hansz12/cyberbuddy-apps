class CyberModule {
  final String id;
  final String title;
  final String tag;
  final String description;

  CyberModule({required this.id, required this.title, required this.tag, required this.description});
}

final List<CyberModule> allCyberModules = [
  CyberModule(id: '1', title: 'Identify Phishing', tag: 'phishing', description: 'Spot fake emails.'),
  CyberModule(id: '2', title: 'Password Strength', tag: 'passwords', description: 'Create unhackable keys.'),
  CyberModule(id: '3', title: 'Malware Protection', tag: 'malware', description: 'Keep your device clean.'),
];