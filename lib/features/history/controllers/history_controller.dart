import 'package:brijraj_app/features/history/models/history_model_dm.dart';
import 'package:brijraj_app/features/history/screens/pdf_screen.dart';
import 'package:brijraj_app/features/history/services/history_api_service.dart';
import 'package:brijraj_app/utils/alert_message_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var hasMoreData = true.obs;
  var currentPage = 1;
  var pageSize = 10;

  var searchController = TextEditingController();
  var searchQuery = ''.obs;
  var historyList = <HistoryModelDm>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSlipHistory();
    debounceSearchQuery();
  }

  void debounceSearchQuery() {
    debounce(
      searchQuery,
      (_) => fetchSlipHistory(),
      time: const Duration(
        milliseconds: 300,
      ),
    );
  }

  Future<void> fetchSlipHistory({
    bool loadMore = false,
  }) async {
    if (loadMore && !hasMoreData.value) return;
    try {
      if (!loadMore) {
        isLoading.value = true;
        currentPage = 1;
        historyList.clear();
      } else {
        isLoadingMore.value = true;
      }

      var fetchedHistory = await HistoryService.fetchHistory(
        pageNumber: currentPage,
        pageSize: pageSize,
        slipNo: searchQuery.value,
      );

      if (fetchedHistory.isNotEmpty) {
        historyList.addAll(
          fetchedHistory,
        );
        currentPage++;
      } else {
        hasMoreData.value = false;
      }
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
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
