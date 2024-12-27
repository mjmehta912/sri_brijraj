import 'dart:convert';
import 'dart:typed_data';

import 'package:brijraj_app/constants/api_constants.dart';
import 'package:brijraj_app/features/history/models/history_model_dm.dart';
import 'package:http/http.dart' as http;

class HistoryService {
  static Future<List<HistoryModelDm>> fetchHistory() async {
    final url = Uri.parse(
      '$kBaseUrl/data/history',
    );

    final headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map(
            (json) => HistoryModelDm.fromJson(json),
          )
          .toList();
    } else {
      throw 'Failed to fetch history: ${response.body}';
    }
  }

  static Future<Uint8List?> downloadSlip({
    required String slipNo,
  }) async {
    final url = Uri.parse(
      '$kBaseUrl/data/print?SlipNo=$slipNo',
    );

    final headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw 'Failed to download PDF';
    }
  }
}
