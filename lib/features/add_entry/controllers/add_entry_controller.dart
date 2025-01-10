import 'package:brijraj_app/features/add_entry/models/customer_dm.dart';
import 'package:brijraj_app/features/add_entry/models/transporter_dm.dart';
import 'package:brijraj_app/features/add_entry/models/vehicle_dm.dart';
import 'package:brijraj_app/features/add_entry/services/add_entry_service.dart';
import 'package:brijraj_app/utils/alert_message_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  var items = <Map<String, dynamic>>[].obs;
  var otherItemController = TextEditingController();
  var otherItemQtyController = TextEditingController();
  var selectedCustomerCode = ''.obs;
  var selectedCustomerName = ''.obs;
  var selectedFuelType = 'Diesel'.obs;
  var selectedVehicleCode = 0.obs;
  var selectedVehicleNo = ''.obs;
  final vehicleNoController = TextEditingController();
  var vehicles = <VehicleDm>[].obs;
  final transporterNameController = TextEditingController();
  var transporters = <TransporterDm>[].obs;
  var filteredTransporters = <TransporterDm>[].obs;
  var selectedTransporter = ''.obs;
  final remarkController = TextEditingController();

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  void setFuelType(String type) {
    selectedFuelType.value = type;
  }

  void addItem({
    required String iName,
    required double qty,
  }) {
    items.add(
      {
        "INAME": iName,
        "QTY": qty,
      },
    );

    if (iName == 'Petrol' || iName == 'Diesel') {
      isFuelAdded.value = true;
    }
  }

  void removeItem(int index) {
    final removedItem = items.removeAt(index);

    if (removedItem['INAME'] == 'Petrol' || removedItem['INAME'] == 'Diesel') {
      isFuelAdded.value = items.any(
        (item) => item['INAME'] == 'Petrol' || item['INAME'] == 'Diesel',
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
      filterVehiclesByCustomer(existingCustomer.pcode);
    } else {
      filteredVehicles.clear();
    }
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

  void handleNewTransporter(String transporterName) {
    selectedTransporter.value = transporterName;
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
    if (query.isEmpty) {
      filteredVehicles.assignAll(vehicles);
    } else {
      filteredVehicles.value = vehicles
          .where(
            (vehicle) =>
                vehicle.vehicleNo.toLowerCase().contains(query.toLowerCase()) &&
                (selectedCustomerCode.value.isEmpty ||
                    vehicle.pCode == selectedCustomerCode.value),
          )
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
    String? userId = await secureStorage.read(
      key: 'userId',
    );
    int id = int.parse(userId!);

    try {
      isLoading.value = true;

      final message = await AddEntryService.addEntry(
        date: DateFormat('yyyy-MM-dd').format(
          DateFormat('dd-MM-yyyy').parse(dateController.text),
        ),
        transporter: transporterNameController.text,
        pname: selectedCustomerName.value,
        pcode: selectedCustomerCode.value,
        vehicleNo: selectedVehicleNo.value,
        vehicleCode: selectedVehicleCode.value == 0
            ? ''
            : selectedVehicleCode.value.toString(),
        remark: remarkController.text,
        userId: id,
        items: items,
      );

      showSuccessSnackbar(
        'Success',
        message,
      );
      transporterNameController.clear();
      customerNameController.clear();
      vehicleNoController.clear();
      selectedCustomerName.value = '';
      selectedCustomerCode.value = '';
      selectedVehicleNo.value = '';
      selectedVehicleCode.value = 0;
      remarkController.clear();
      items.clear();
      isFuelAdded.value = false;
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
