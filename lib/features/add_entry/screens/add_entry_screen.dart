import 'package:brijraj_app/constants/color_constants.dart';
import 'package:brijraj_app/constants/image_constants.dart';
import 'package:brijraj_app/features/add_entry/controllers/add_entry_controller.dart';
import 'package:brijraj_app/styles/textstyles.dart';
import 'package:brijraj_app/utils/alert_message_utils.dart';
import 'package:brijraj_app/utils/text_input_formatters.dart';
import 'package:brijraj_app/widgets/app_appbar.dart';
import 'package:brijraj_app/widgets/app_button.dart';
import 'package:brijraj_app/widgets/app_date_picker_text_form_field.dart';
import 'package:brijraj_app/widgets/app_loading_overlay.dart';
import 'package:brijraj_app/widgets/app_paddings.dart';
import 'package:brijraj_app/widgets/app_secondary_button.dart';
import 'package:brijraj_app/widgets/app_size_extensions.dart';
import 'package:brijraj_app/widgets/app_spacings.dart';
import 'package:brijraj_app/widgets/app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({
    super.key,
  });

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final AddEntryController _controller = Get.put(
    AddEntryController(),
  );

  @override
  void initState() {
    _controller.customerNameController.clear();
    _controller.vehicleNoController.clear();
    _controller.selectedCustomerName.value = '';
    _controller.selectedCustomerCode.value = '';
    _controller.selectedVehicleNo.value = '';
    _controller.selectedVehicleCode.value = 0;
    _controller.items.clear();
    _controller.isFuelAdded.value = false;
    _controller.isOilAdded = false.obs;
    super.initState();
    _controller.dateController.text = DateFormat('dd-MM-yyyy').format(
      DateTime.now(),
    );
    _controller.fetchCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            _controller.filteredCustomers.clear();
            _controller.filteredVehicles.clear();
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: kColorBackground,
            appBar: const AppAppbar(),
            body: Padding(
              padding: AppPaddings.combined(
                horizontal: 15.appWidth,
                vertical: 10.appHeight,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AppDatePickerTextFormField(
                      dateController: _controller.dateController,
                      hintText: 'Date',
                    ),
                    AppSpaces.v20,
                    AppTextFormField(
                      controller: _controller.customerNameController,
                      hintText: 'Customer',
                      onChanged: (value) {
                        _controller.fetchCustomers(
                          pname: value,
                        );

                        _controller.handleNewCustomer(value);
                      },
                    ),
                    Obx(
                      () {
                        if (_controller.filteredCustomers.isEmpty ||
                            _controller.customerNameController.text.isEmpty) {
                          return const SizedBox();
                        } else {
                          return Container(
                            height: 0.125.screenHeight,
                            decoration: BoxDecoration(
                              color: kColorwhite,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: AppPaddings.p12,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _controller.filteredCustomers.length,
                              itemBuilder: (context, index) {
                                final customer =
                                    _controller.filteredCustomers[index];
                                return GestureDetector(
                                  onTap: () {
                                    _controller.setSelectedCustomer(customer);
                                    _controller.filteredCustomers.clear();
                                  },
                                  child: Text(
                                    customer.pname,
                                    style: TextStyles.kSemiBoldInstrumentSans(
                                      color: kColorPrimary,
                                    ).copyWith(
                                      height: 2,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                    AppSpaces.v20,
                    AppTextFormField(
                      controller: _controller.vehicleNoController,
                      hintText: 'Vehicle',
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z0-9]'),
                        ),
                        UpperCaseTextInputFormatter(),
                      ],
                      onChanged: (value) {
                        _controller.fetchVehicles(
                          vehicleNo: value,
                        );

                        _controller.handleNewVehicle(value);
                      },
                    ),
                    Obx(
                      () {
                        if (_controller.filteredVehicles.isEmpty ||
                            _controller.vehicleNoController.text.isEmpty) {
                          return const SizedBox();
                        } else {
                          return Container(
                            height: 0.2.screenHeight,
                            decoration: BoxDecoration(
                              color: kColorwhite,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: AppPaddings.p12,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _controller.filteredVehicles.length,
                              itemBuilder: (context, index) {
                                final vehicle =
                                    _controller.filteredVehicles[index];
                                return GestureDetector(
                                  onTap: () {
                                    _controller.setSelectedVehicle(vehicle);
                                    _controller.filteredVehicles.clear();
                                  },
                                  child: Text(
                                    vehicle.vehicleNo,
                                    style: TextStyles.kSemiBoldInstrumentSans(
                                      color: kColorPrimary,
                                    ).copyWith(
                                      height: 2,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                    AppSpaces.v20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => AppSecondaryButton(
                            onPressed: _controller.isFuelAdded.value
                                ? () {}
                                : () {
                                    _controller.setFuelType('P');
                                    _controller.fuelController.clear();
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          backgroundColor: kColorwhite,
                                          surfaceTintColor: kColorwhite,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Padding(
                                            padding: AppPaddings.combined(
                                              horizontal: 15.appWidth,
                                              vertical: 15.appHeight,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      kIconFuel,
                                                      colorFilter:
                                                          const ColorFilter
                                                              .mode(
                                                        kColorPrimary,
                                                        BlendMode.srcIn,
                                                      ),
                                                    ),
                                                    AppSpaces.h20,
                                                    Text(
                                                      'Fuel',
                                                      style: TextStyles
                                                          .kBoldInstrumentSans(
                                                        color: kColorPrimary,
                                                        fontSize: 24,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                AppSpaces.v20,
                                                AppTextFormField(
                                                  controller: _controller
                                                      .fuelController,
                                                  hintText: 'Litre',
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                                AppSpaces.v20,
                                                Obx(
                                                  () => Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          _controller
                                                              .setFuelType('P');
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Radio<String>(
                                                              activeColor:
                                                                  kColorPrimary,
                                                              value: 'P',
                                                              groupValue:
                                                                  _controller
                                                                      .selectedFuelType
                                                                      .value,
                                                              onChanged:
                                                                  (value) {
                                                                if (value !=
                                                                    null) {
                                                                  _controller
                                                                      .setFuelType(
                                                                          value);
                                                                }
                                                              },
                                                            ),
                                                            Text(
                                                              'Petrol',
                                                              style: TextStyles
                                                                  .kSemiBoldInstrumentSans(
                                                                color:
                                                                    kColorPrimary,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          _controller
                                                              .setFuelType('D');
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Radio<String>(
                                                              activeColor:
                                                                  kColorPrimary,
                                                              value: 'D',
                                                              groupValue:
                                                                  _controller
                                                                      .selectedFuelType
                                                                      .value,
                                                              onChanged:
                                                                  (value) {
                                                                if (value !=
                                                                    null) {
                                                                  _controller
                                                                      .setFuelType(
                                                                          value);
                                                                }
                                                              },
                                                            ),
                                                            Text(
                                                              'Diesel',
                                                              style: TextStyles
                                                                  .kSemiBoldInstrumentSans(
                                                                color:
                                                                    kColorPrimary,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                AppSpaces.v20,
                                                AppSecondaryButton(
                                                  onPressed: () {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                    double qty = double.tryParse(
                                                            _controller
                                                                .fuelController
                                                                .text) ??
                                                        0.0;
                                                    if (qty > 0) {
                                                      _controller.addItem(
                                                        code: _controller
                                                            .selectedFuelType
                                                            .value,
                                                        qty: qty,
                                                      );
                                                      Get.back();
                                                    }
                                                  },
                                                  buttonHeight: 40.appHeight,
                                                  title: 'Add',
                                                  icon: kIconFuel,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                            buttonHeight: 40.appHeight,
                            buttonWidth: 0.4.screenWidth,
                            buttonColor: _controller.isFuelAdded.value
                                ? kColorLightGrey
                                : kColorPrimary,
                            title: 'Fuel',
                            icon: kIconFuel,
                          ),
                        ),
                        Obx(
                          () => AppSecondaryButton(
                            onPressed: _controller.isOilAdded.value
                                ? () {}
                                : () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    _controller.oilController.clear();
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          backgroundColor: kColorwhite,
                                          surfaceTintColor: kColorwhite,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Padding(
                                            padding: AppPaddings.combined(
                                              horizontal: 15.appWidth,
                                              vertical: 15.appHeight,
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      kIconOil,
                                                      colorFilter:
                                                          const ColorFilter
                                                              .mode(
                                                        kColorPrimary,
                                                        BlendMode.srcIn,
                                                      ),
                                                    ),
                                                    AppSpaces.h20,
                                                    Text(
                                                      'Oil',
                                                      style: TextStyles
                                                          .kBoldInstrumentSans(
                                                        color: kColorPrimary,
                                                        fontSize: 24,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                AppSpaces.v20,
                                                AppTextFormField(
                                                  controller:
                                                      _controller.oilController,
                                                  hintText: 'Litre',
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                                AppSpaces.v20,
                                                AppSecondaryButton(
                                                  onPressed: () {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                    double qty = double.tryParse(
                                                            _controller
                                                                .oilController
                                                                .text) ??
                                                        0.0;
                                                    if (qty > 0) {
                                                      _controller.addItem(
                                                        code: 'O',
                                                        qty: qty,
                                                      );
                                                      Get.back();
                                                    }
                                                  },
                                                  buttonHeight: 40.appHeight,
                                                  title: 'Add',
                                                  icon: kIconOil,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                            buttonHeight: 40.appHeight,
                            buttonWidth: 0.4.screenWidth,
                            buttonColor: _controller.isOilAdded.value
                                ? kColorLightGrey
                                : kColorPrimary,
                            title: 'Oil',
                            icon: kIconOil,
                          ),
                        ),
                      ],
                    ),
                    AppSpaces.v20,
                    SizedBox(
                      height: 0.2.screenHeight,
                      child: Obx(
                        () => ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _controller.items.length,
                          itemBuilder: (context, index) {
                            final item = _controller.items[index];
                            final itemName = item['ICODE'] == 'P'
                                ? 'Petrol'
                                : item['ICODE'] == 'D'
                                    ? 'Diesel'
                                    : 'Oil';

                            return Column(
                              children: [
                                Card(
                                  elevation: 5,
                                  color: kColorwhite,
                                  child: ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 0.25.screenWidth,
                                          child: Text(
                                            itemName,
                                            style: TextStyles
                                                .kSemiBoldInstrumentSans(
                                              color: kColorPrimary,
                                            ).copyWith(
                                              height: 1,
                                            ),
                                          ),
                                        ),
                                        AppSpaces.h10,
                                        SizedBox(
                                          width: 0.25.screenWidth,
                                          child: Text(
                                            '${item['QTY']}  Litre',
                                            style: TextStyles
                                                .kSemiBoldInstrumentSans(
                                              color: kColorPrimary,
                                            ).copyWith(
                                              height: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        _controller.removeItem(index);
                                      },
                                    ),
                                  ),
                                ),
                                AppSpaces.v6
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    AppSpaces.v60,
                    AppButton(
                      onTap: () {
                        if (_controller.customerNameController.text.isEmpty &&
                            _controller.vehicleNoController.text.isNotEmpty) {
                          showErrorSnackbar(
                            'Oops',
                            'Please enter a customer to continue',
                          );
                        }

                        if (_controller
                                .customerNameController.text.isNotEmpty &&
                            _controller.vehicleNoController.text.isEmpty) {
                          showErrorSnackbar(
                            'Oops',
                            'Please enter a vehicle to continue',
                          );
                        }

                        if (_controller.customerNameController.text.isEmpty &&
                            _controller.vehicleNoController.text.isEmpty &&
                            _controller.items.isEmpty) {
                          showErrorSnackbar(
                            'Oops',
                            'Please enter all the details to continue',
                          );
                        }

                        if (_controller.items.isNotEmpty) {
                          _controller.addEntry();
                        }
                      },
                      buttonHeight: 40.appHeight,
                      title: 'Save',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Obx(
          () => CustomLoadingOverlay(
            isLoading: _controller.isLoading.value,
          ),
        ),
      ],
    );
  }
}
