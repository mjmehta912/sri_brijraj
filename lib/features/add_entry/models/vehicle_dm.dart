class VehicleDm {
  final String vehicleNo;
  final int vehicleCode;
  final String pCode;

  VehicleDm({
    required this.vehicleNo,
    required this.vehicleCode,
    required this.pCode,
  });

  factory VehicleDm.fromJson(Map<String, dynamic> json) {
    return VehicleDm(
      vehicleCode: json['VehicleCode'],
      vehicleNo: json['VehicleNo'],
      pCode: json['PCODE'],
    );
  }
}
