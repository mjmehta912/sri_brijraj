import 'dart:typed_data';
import 'dart:convert';
import 'package:brijraj_app/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class ReportService {
  /// Fetches the Excel file from the API via POST request
  static Future<Uint8List> downloadExcelReport({
    String fromDate = '',
    String toDate = '',
    String transporter = '',
    String pCode = '',
  }) async {
    final Uri url = Uri.parse(
      '$kBaseUrl/data/report',
    );

    final Map<String, String> body = {
      'FromDate': fromDate,
      'ToDate': toDate,
      'Transporter': transporter,
      'PCODE': pCode,
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return response.bodyBytes; // Return file as bytes
    } else {
      throw 'Failed to download report: ${response.statusCode} ${response.body}';
    }
  }
}
