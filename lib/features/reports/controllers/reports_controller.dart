import 'package:brijraj_app/features/add_entry/models/customer_dm.dart';
import 'package:brijraj_app/features/add_entry/models/transporter_dm.dart';
import 'package:brijraj_app/features/add_entry/services/add_entry_service.dart';
import 'package:brijraj_app/utils/alert_message_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
}
