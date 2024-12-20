class HistoryModelDm {
  final String slipNo;
  final String date;
  final String pname;
  final String vehicleNo;
  final List<HistoryItemDm> items;

  HistoryModelDm({
    required this.slipNo,
    required this.date,
    required this.pname,
    required this.vehicleNo,
    required this.items,
  });

  factory HistoryModelDm.fromJson(Map<String, dynamic> json) {
    return HistoryModelDm(
      slipNo: json['slipNo'],
      date: json['date'],
      pname: json['pname'],
      vehicleNo: json['vehicleNo'],
      items: (json['items'] as List)
          .map(
            (item) => HistoryItemDm.fromJson(item),
          )
          .toList(),
    );
  }
}

class HistoryItemDm {
  final String icode;
  final String qty;

  HistoryItemDm({
    required this.icode,
    required this.qty,
  });

  factory HistoryItemDm.fromJson(Map<String, dynamic> json) {
    return HistoryItemDm(
      icode: json['icode'],
      qty: json['qty'],
    );
  }
}
