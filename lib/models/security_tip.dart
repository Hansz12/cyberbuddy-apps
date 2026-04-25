class SecurityTip {
  final String title;
  final String description;
  final String category;
  final String source;

  const SecurityTip({
    required this.title,
    required this.description,
    required this.category,
    required this.source,
  });

  factory SecurityTip.fromCisaKev(Map<String, dynamic> json) {
    final cveId = json['cveID']?.toString() ?? 'Unknown CVE';
    final vendor = json['vendorProject']?.toString() ?? 'Unknown vendor';
    final product = json['product']?.toString() ?? 'Unknown product';
    final vulnerabilityName =
        json['vulnerabilityName']?.toString() ?? 'Known exploited vulnerability';
    final action =
        json['requiredAction']?.toString() ?? 'Apply vendor guidance and security updates.';

    return SecurityTip(
      title: '$cveId - $product',
      description:
      '$vulnerabilityName affects $vendor $product. Recommended action: $action',
      category: 'Live Vulnerabilities',
      source: 'CISA KEV',
    );
  }
}