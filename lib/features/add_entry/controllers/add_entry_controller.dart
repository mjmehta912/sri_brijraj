import 'package:brijraj_app/features/add_entry/models/customer_dm.dart';
import 'package:brijraj_app/features/add_entry/models/vehicle_dm.dart';
import 'package:brijraj_app/features/add_entry/services/add_entry_service.dart';
import 'package:brijraj_app/utils/alert_message_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddEntryController extends GetxController {
  final customerNameController = TextEditingController();
  var customers = <CustomerDm>[].obs;
  var dateController = TextEditingController();
  var filteredCustomers = <CustomerDm>[].obs;
  var filteredVehicles = <VehicleDm>[].obs;
  var fuelController = TextEditingController();
  var isFuelAdded = false.obs;
  var isLoading = false.obs;
  var isOilAdded = false.obs;
  var items = <Map<String, dynamic>>[].obs;
  var oilController = TextEditingController();
  var selectedCustomerCode = ''.obs;
  var selectedCustomerName = ''.obs;
  var selectedFuelType = 'P'.obs;
  var selectedVehicleCode = 0.obs;
  var selectedVehicleNo = ''.obs;
  final vehicleNoController = TextEditingController();
  var vehicles = <VehicleDm>[].obs;

  void setFuelType(String type) {
    selectedFuelType.value = type;
  }

  void addItem({
    required String code,
    required double qty,
  }) {
    items.add(
      {
        "ICODE": code,
        "QTY": qty,
      },
    );

    if (code == 'P' || code == 'D') {
      isFuelAdded.value = true;
    } else if (code == 'O') {
      isOilAdded.value = true;
    }
  }

  void removeItem(int index) {
    final removedItem = items.removeAt(index);

    if (removedItem['ICODE'] == 'P' || removedItem['ICODE'] == 'D') {
      isFuelAdded.value = items.any(
        (item) => item['ICODE'] == 'P' || item['ICODE'] == 'D',
      );
    } else if (removedItem['ICODE'] == 'O') {
      isOilAdded.value = items.any(
        (item) => item['ICODE'] == 'O',
      );
    }
  }

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
            (customer) =>
                customer.pname.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
  }

  void setSelectedCustomer(CustomerDm customer) {
    selectedCustomerName.value = customer.pname;
    selectedCustomerCode.value = customer.pcode;
    customerNameController.text = customer.pname;
    filteredCustomers.clear();

    filterVehiclesByCustomer(customer.pcode);
  }

  void handleNewCustomer(String customerName) {
    selectedCustomerName.value = customerName;
    selectedCustomerCode.value = '';

    final existingCustomer = customers.firstWhere(
      (customer) => customer.pname.toLowerCase() == customerName.toLowerCase(),
      orElse: () => CustomerDm(pname: '', pcode: ''),
    );

    if (existingCustomer.pcode.isNotEmpty) {
      selectedCustomerCode.value = existingCustomer.pcode;
    }
  }

  Future<void> fetchVehicles({String? vehicleNo}) async {
    try {
      isLoading.value = true;

      final fetchedVehicles = await AddEntryService.fetchVehicle(vehicleNo);

      vehicles.assignAll(fetchedVehicles);

      if (vehicleNo == null || vehicleNo.isEmpty) {
        filteredVehicles.assignAll(vehicles);
      } else {
        filterVehicles(vehicleNo);
      }
    } catch (e) {
      showErrorSnackbar(
        'Failed to load vehicles',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void filterVehicles(String query) {
    // If there's no query or customer is not selected, show all vehicles
    if (query.isEmpty) {
      filteredVehicles.assignAll(vehicles);
    } else {
      filteredVehicles.value = vehicles
          .where((vehicle) =>
              vehicle.vehicleNo.toLowerCase().contains(query.toLowerCase()) &&
              (selectedCustomerCode.value.isEmpty ||
                  vehicle.pCode == selectedCustomerCode.value))
          .toList();
    }
  }

  void filterVehiclesByCustomer(String pCode) {
    filteredVehicles.value = vehicles
        .where(
          (vehicle) => vehicle.pCode == pCode,
        )
        .toList();
  }

  void setSelectedVehicle(VehicleDm vehicle) {
    selectedVehicleNo.value = vehicle.vehicleNo;
    selectedVehicleCode.value = vehicle.vehicleCode;
    vehicleNoController.text = vehicle.vehicleNo;

    // Automatically assign customer name by matching pCode
    final customer = customers.firstWhere(
      (customer) => customer.pcode == vehicle.pCode,
      orElse: () => CustomerDm(pname: '', pcode: ''),
    );

    // If a customer is found with the matching pCode, assign customer name
    if (customer.pcode.isNotEmpty) {
      selectedCustomerName.value = customer.pname;
      selectedCustomerCode.value = customer.pcode;
      customerNameController.text = customer.pname;
    }

    filteredVehicles.clear();
  }

  void handleNewVehicle(String vehicleNo) {
    selectedVehicleNo.value = vehicleNo;
    selectedVehicleCode.value = 0;

    final existingVehicle = vehicles.firstWhere(
      (vehicle) => vehicle.vehicleNo.toLowerCase() == vehicleNo.toLowerCase(),
      orElse: () => VehicleDm(
        vehicleNo: '',
        vehicleCode: 0,
        pCode: '',
      ),
    );

    if (existingVehicle.vehicleCode.toString().isNotEmpty) {
      selectedVehicleCode.value = existingVehicle.vehicleCode;
    }
  }

  Future<void> addEntry() async {
    try {
      isLoading.value = true;

      final message = await AddEntryService.addEntry(
        date: DateFormat('yyyy-MM-dd').format(
          DateFormat('dd-MM-yyyy').parse(dateController.text),
        ),
        pname: selectedCustomerName.value,
        pcode: selectedCustomerCode.value,
        vehicleNo: selectedVehicleNo.value,
        vehicleCode: selectedVehicleCode.value == 0
            ? ''
            : selectedVehicleCode.value.toString(),
        items: items,
      );

      showSuccessSnackbar(
        'Success',
        message,
      );
      customerNameController.clear();
      vehicleNoController.clear();
      selectedCustomerName.value = '';
      selectedCustomerCode.value = '';
      selectedVehicleNo.value = '';
      selectedVehicleCode.value = 0;
      items.clear();
      isFuelAdded.value = false;
      isOilAdded.value = false;
    } catch (e) {
      showErrorSnackbar(
        'Failed to save entry',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
