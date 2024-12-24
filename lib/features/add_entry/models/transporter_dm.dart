class TransporterDm {
  final String transporterName;

  TransporterDm({
    required this.transporterName,
  });

  factory TransporterDm.fromJson(Map<String, dynamic> json) {
    return TransporterDm(
      transporterName: json['Transporter'] ?? 'N/A',
    );
  }
}
