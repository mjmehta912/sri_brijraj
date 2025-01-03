import 'dart:io';
import 'dart:typed_data';

import 'package:brijraj_app/features/add_entry/models/customer_dm.dart';
import 'package:brijraj_app/features/add_entry/models/transporter_dm.dart';
import 'package:brijraj_app/features/add_entry/services/add_entry_service.dart';
import 'package:brijraj_app/features/reports/services/reports_service.dart';
import 'package:brijraj_app/utils/alert_message_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ReportsController extends GetxController {
  var isLoading = false.obs;

  var fromDateController = TextEditingController();
  var toDateController = TextEditingController();

  final customerNameController = TextEditingController();
  var selectedCustomerCode = ''.obs;
  var selectedCustomerName = ''.obs;
  var customers = <CustomerDm>[].obs;
  var filteredCustomers = <CustomerDm>[].obs;

  final transporterNameController = TextEditingController();
  var transporters = <TransporterDm>[].obs;
  var filteredTransporters = <TransporterDm>[].obs;
  var selectedTransporter = ''.obs;

  Future<void> fetchCustomers({String? pname}) async {
    try {
      isLoading.value = true;

      final fetchedCustomers =
          await AddEntryService.fetchCustomersByName(pname);
      customers.assignAll(fetchedCustomers);

      if (pname == null || pname.isEmpty) {
        filteredCustomers.assignAll(customers);
      } else {
        filterCustomers(pname);
      }
    } catch (e) {
      showErrorSnackbar(
        'Failed to load customers',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void filterCustomers(String query) {
    if (query.isEmpty) {
      filteredCustomers.assignAll(customers);
    } else {
      filteredCustomers.value = customers
          .where(
            (customer) => customer.pname.toLowerCase().contains(
                  query.toLowerCase(),
                ),
          )
          .toList();
    }
  }

  void setSelectedCustomer(CustomerDm customer) {
    selectedCustomerName.value = customer.pname;
    selectedCustomerCode.value = customer.pcode;
    customerNameController.text = customer.pname;
    filteredCustomers.clear();
  }

  Future<void> fetchTransporters({String? tname}) async {
    try {
      isLoading.value = true;

      final fetchedTransporters = await AddEntryService.fetchTransporter(tname);
      transporters.assignAll(fetchedTransporters);

      if (tname == null || tname.isEmpty) {
        filteredTransporters.assignAll(transporters);
      } else {
        filterTransporters(tname);
      }
    } catch (e) {
      showErrorSnackbar(
        'Failed to load transporters',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void filterTransporters(String query) {
    if (query.isEmpty) {
      filteredTransporters.assignAll(transporters);
    } else {
      filteredTransporters.value = transporters
          .where(
            (transporter) => transporter.transporterName.toLowerCase().contains(
                  query.toLowerCase(),
                ),
          )
          .toList();
    }
  }

  void setSelectedTransporter(TransporterDm transporter) {
    selectedTransporter.value = transporter.transporterName;
    transporterNameController.text = transporter.transporterName;

    filteredTransporters.clear();
  }

  /// Check and Request Storage Permissions
  Future<bool> _checkStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.isDenied) {
        await Permission.storage.request();
      }

      if (await Permission.manageExternalStorage.isDenied) {
        await Permission.manageExternalStorage.request();
      }

      if (await Permission.storage.isPermanentlyDenied ||
          await Permission.manageExternalStorage.isPermanentlyDenied) {
        await openAppSettings();
        return false;
      }

      return await Permission.storage.isGranted ||
          await Permission.manageExternalStorage.isGranted;
    }
    return true; // iOS doesn't need explicit storage permission
  }

  /// Download and Open Excel Report
  Future<void> downloadReport() async {
    try {
      isLoading.value = true;

      // Check Permissions
      bool hasPermission = await _checkStoragePermission();
      if (!hasPermission) {
        throw Exception('Storage permission denied');
      }

      // Download the Excel Report
      Uint8List fileBytes = await ReportService.downloadExcelReport(
        fromDate: fromDateController.text,
        toDate: toDateController.text,
        transporter: selectedTransporter.value,
        pCode: selectedCustomerCode.value,
      );

      // Save the File
      final directory = await getApplicationSupportDirectory();
      final filePath =
          '${directory.path}/report_${DateTime.now().millisecondsSinceEpoch}.xlsx';

      final File file = File(filePath);
      await file.writeAsBytes(fileBytes);

      // Open the File
      await OpenFile.open(filePath);
    } catch (e) {
      showErrorSnackbar(
        'Download Failed',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
