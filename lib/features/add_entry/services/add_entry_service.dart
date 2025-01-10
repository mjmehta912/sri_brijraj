import 'dart:convert';

import 'package:brijraj_app/constants/api_constants.dart';
import 'package:brijraj_app/features/add_entry/models/customer_dm.dart';
import 'package:brijraj_app/features/add_entry/models/transporter_dm.dart';
import 'package:brijraj_app/features/add_entry/models/vehicle_dm.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AddEntryService {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  static Future<List<CustomerDm>> fetchCustomersByName([
    String? pName,
  ]) async {
    final query = pName != null && pName.isNotEmpty ? '?PNAME=$pName' : '';
    final url = Uri.parse(
      '$kBaseUrl/data/customer$query',
    );

    final headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data
          .map(
            (json) => CustomerDm.fromJson(json),
          )
          .toList();
    } else {
      throw response.body;
    }
  }

  static Future<List<TransporterDm>> fetchTransporter([
    String? tName,
  ]) async {
    final query =
        tName != null && tName.isNotEmpty ? '?Transporter=$tName' : '';
    final url = Uri.parse(
      '$kBaseUrl/data/transporter$query',
    );

    final headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data
          .map(
            (json) => TransporterDm.fromJson(json),
          )
          .toList();
    } else {
      throw response.body;
    }
  }

  static Future<List<VehicleDm>> fetchVehicle([
    String? vehicleNo,
  ]) async {
    final query = vehicleNo != null && vehicleNo.isNotEmpty
        ? '?VehicleNo=$vehicleNo'
        : '';
    final url = Uri.parse(
      '$kBaseUrl/data/vehicle$query',
    );

    final headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<dynamic> data = body['data'];
      return data
          .map(
            (json) => VehicleDm.fromJson(json),
          )
          .toList();
    } else {
      throw response.body;
    }
  }

  static Future<String> addEntry({
    required String date,
    required String transporter,
    required String pname,
    required String pcode,
    required String vehicleNo,
    required String vehicleCode,
    required String remark,
    required int userId,
    required List<Map<String, dynamic>> items,
  }) async {
    final url = Uri.parse(
      '$kBaseUrl/data/add',
    );

    final headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> requestBody = {
      'DATE': date,
      'Transporter': transporter,
      'PNAME': pname,
      'PCODE': pcode,
      'VehicleNo': vehicleNo,
      'VehicleCode': vehicleCode,
      'Remark': remark,
      'UserId': userId,
      'data': items,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final message = body['message'];
      return message;
    } else {
      // print(response.body);
      // print(response.reasonPhrase);
      // print(response.statusCode);
      throw response.body;
    }
  }
}
