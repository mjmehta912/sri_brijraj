import 'package:brijraj_app/features/history/models/history_model_dm.dart';
import 'package:brijraj_app/features/history/screens/pdf_screen.dart';
import 'package:brijraj_app/features/history/services/history_api_service.dart';
import 'package:brijraj_app/utils/alert_message_utils.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  var isLoading = false.obs;

  var historyList = <HistoryModelDm>[].obs;

  Future<void> fetchHistory() async {
    isLoading.value = true;
    try {
      List<HistoryModelDm> fetchedHistory = await HistoryService.fetchHistory();
      historyList.assignAll(fetchedHistory);
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> viewPdf({
    required String slipNo,
  }) async {
    try {
      isLoading.value = true;
      final pdfBytes = await HistoryService.downloadSlip(
        slipNo: slipNo,
      );

      if (pdfBytes != null && pdfBytes.isNotEmpty) {
        Get.to(
          () => PdfScreen(
            pdfBytes: pdfBytes,
            title: slipNo,
          ),
        );
      }
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
