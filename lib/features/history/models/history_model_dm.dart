class HistoryModelDm {
  final String slipNo;
  final String date;
  final String pname;
  final String vehicleNo;
  final String transporter;
  final String remark;
  final String entryDateTime;
  final List<HistoryItemDm> items;

  HistoryModelDm({
    required this.slipNo,
    required this.date,
    required this.pname,
    required this.vehicleNo,
    required this.transporter,
    required this.items,
    required this.remark,
    required this.entryDateTime,
  });

  factory HistoryModelDm.fromJson(Map<String, dynamic> json) {
    return HistoryModelDm(
      slipNo: json['slipNo'],
      date: json['date'],
      pname: json['pname'],
      vehicleNo: json['vehicleNo'],
      transporter: json['transporter'],
      remark: json['remark'] ?? '',
      entryDateTime: json['entryDateTime'],
      items: (json['items'] as List)
          .map(
            (item) => HistoryItemDm.fromJson(item),
          )
          .toList(),
    );
  }
}

class HistoryItemDm {
  final String iname;
  final String qty;

  HistoryItemDm({
    required this.iname,
    required this.qty,
  });

  factory HistoryItemDm.fromJson(Map<String, dynamic> json) {
    return HistoryItemDm(
      iname: json['iname'],
      qty: json['qty'],
    );
  }
}
