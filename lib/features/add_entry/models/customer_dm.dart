class CustomerDm {
  final String pname;
  final String pcode;

  CustomerDm({
    required this.pname,
    required this.pcode,
  });

  factory CustomerDm.fromJson(Map<String, dynamic> json) {
    return CustomerDm(
      pname: json['PNAME'],
      pcode: json['PCODE'],
    );
  }
}
