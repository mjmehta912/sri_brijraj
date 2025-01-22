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
    _controller.transporterNameController.clear();
    _controller.vehicleNoController.clear();
    _controller.selectedCustomerName.value = '';
    _controller.selectedCustomerCode.value = '';
    _controller.selectedVehicleNo.value = '';
    _controller.selectedVehicleCode.value = 0;
    _controller.items.clear();
    _controller.remarkController.clear();
    _controller.isFuelAdded.value = false;

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
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _controller.formKey,
                        child: Column(
                          children: [
                            AppDatePickerTextFormField(
                              dateController: _controller.dateController,
                              hintText: 'Date',
                            ),
                            AppSpaces.v16,
                            AppTextFormField(
                              controller: _controller.transporterNameController,
                              hintText: 'Transporter',
                              onChanged: (value) {
                                _controller.fetchTransporters(
                                  tname: value,
                                );

                                _controller.handleNewTransporter(value);
                              },
                              inputFormatters: [
                                TitleCaseTextInputFormatter(),
                              ],
                            ),
                            Obx(
                              () {
                                if (_controller.filteredTransporters.isEmpty ||
                                    _controller.transporterNameController.text
                                        .isEmpty) {
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
                                      itemCount: _controller
                                          .filteredTransporters.length,
                                      itemBuilder: (context, index) {
                                        final transporter = _controller
                                            .filteredTransporters[index];
                                        return GestureDetector(
                                          onTap: () {
                                            _controller.setSelectedTransporter(
                                                transporter);
                                            _controller.filteredTransporters
                                                .clear();
                                          },
                                          child: Text(
                                            transporter.transporterName,
                                            style: TextStyles
                                                .kSemiBoldInstrumentSans(
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
                            AppSpaces.v16,
                            AppTextFormField(
                              controller: _controller.customerNameController,
                              hintText: 'Owner',
                              onChanged: (value) {
                                _controller.fetchCustomers(
                                  pname: value,
                                );

                                _controller.handleNewCustomer(value);
                              },
                              inputFormatters: [
                                TitleCaseTextInputFormatter(),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter owner name';
                                }
                                return null;
                              },
                            ),
                            Obx(
                              () {
                                if (_controller.filteredCustomers.isEmpty ||
                                    _controller
                                        .customerNameController.text.isEmpty) {
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
                                      itemCount:
                                          _controller.filteredCustomers.length,
                                      itemBuilder: (context, index) {
                                        final customer = _controller
                                            .filteredCustomers[index];
                                        return GestureDetector(
                                          onTap: () {
                                            _controller
                                                .setSelectedCustomer(customer);
                                            _controller.filteredCustomers
                                                .clear();
                                          },
                                          child: Text(
                                            customer.pname,
                                            style: TextStyles
                                                .kSemiBoldInstrumentSans(
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
                            AppSpaces.v16,
                            AppTextFormField(
                              controller: _controller.vehicleNoController,
                              hintText: 'Vehicle',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a vehicle no';
                                }

                                if (value.length != 10) {
                                  return 'Please enter a 10-digit vehicle no';
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z0-9]'),
                                ),
                                UpperCaseTextInputFormatter(),
                              ],
                              onChanged: (value) {
                                if (_controller
                                    .selectedCustomerCode.value.isNotEmpty) {
                                  _controller.fetchVehicles(vehicleNo: value);
                                } else {
                                  _controller.filteredVehicles
                                      .clear(); // Clear vehicles if no valid customer is selected
                                }
                                _controller.handleNewVehicle(value);
                              },
                            ),
                            Obx(
                              () {
                                if (_controller.filteredVehicles.isEmpty ||
                                    _controller
                                        .vehicleNoController.text.isEmpty) {
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
                                      itemCount:
                                          _controller.filteredVehicles.length,
                                      itemBuilder: (context, index) {
                                        final vehicle =
                                            _controller.filteredVehicles[index];
                                        return GestureDetector(
                                          onTap: () {
                                            _controller
                                                .setSelectedVehicle(vehicle);
                                            _controller.filteredVehicles
                                                .clear();
                                          },
                                          child: Text(
                                            vehicle.vehicleNo,
                                            style: TextStyles
                                                .kSemiBoldInstrumentSans(
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
                            AppSpaces.v16,
                            AppTextFormField(
                              controller: _controller.remarkController,
                              hintText: 'Remark',
                            ),
                            AppSpaces.v16,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(
                                  () => AppSecondaryButton(
                                    onPressed: _controller.isFuelAdded.value
                                        ? () {}
                                        : () {
                                            _controller.setFuelType('Diesel');
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
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        AppPaddings.combined(
                                                      horizontal: 15.appWidth,
                                                      vertical: 15.appHeight,
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
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
                                                                color:
                                                                    kColorPrimary,
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
                                                              TextInputType
                                                                  .number,
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
                                                                      .setFuelType(
                                                                          'Petrol');
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Radio<
                                                                        String>(
                                                                      activeColor:
                                                                          kColorPrimary,
                                                                      value:
                                                                          'Petrol',
                                                                      groupValue: _controller
                                                                          .selectedFuelType
                                                                          .value,
                                                                      onChanged:
                                                                          (value) {
                                                                        if (value !=
                                                                            null) {
                                                                          _controller
                                                                              .setFuelType(value);
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
                                                                      .setFuelType(
                                                                          'Diesel');
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Radio<
                                                                        String>(
                                                                      activeColor:
                                                                          kColorPrimary,
                                                                      value:
                                                                          'Diesel',
                                                                      groupValue: _controller
                                                                          .selectedFuelType
                                                                          .value,
                                                                      onChanged:
                                                                          (value) {
                                                                        if (value !=
                                                                            null) {
                                                                          _controller
                                                                              .setFuelType(value);
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
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                            double qty = double.tryParse(
                                                                    _controller
                                                                        .fuelController
                                                                        .text) ??
                                                                0.0;
                                                            if (qty > 0) {
                                                              _controller
                                                                  .addItem(
                                                                iName: _controller
                                                                    .selectedFuelType
                                                                    .value,
                                                                qty: qty,
                                                              );
                                                              Get.back();
                                                            }
                                                          },
                                                          buttonHeight:
                                                              40.appHeight,
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
                                    titleSize: FontSize.k20FontSize,
                                    icon: kIconFuel,
                                  ),
                                ),
                                AppSecondaryButton(
                                  onPressed: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    _controller.otherItemController.clear();
                                    _controller.otherItemQtyController.clear();
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
                                                      kIconOther,
                                                      colorFilter:
                                                          const ColorFilter
                                                              .mode(
                                                        kColorPrimary,
                                                        BlendMode.srcIn,
                                                      ),
                                                    ),
                                                    AppSpaces.h20,
                                                    Text(
                                                      'Other',
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
                                                      .otherItemController,
                                                  hintText: 'Item',
                                                  inputFormatters: [
                                                    TitleCaseTextInputFormatter()
                                                  ],
                                                ),
                                                AppSpaces.v20,
                                                AppTextFormField(
                                                  controller: _controller
                                                      .otherItemQtyController,
                                                  hintText: 'Qty',
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
                                                                .otherItemQtyController
                                                                .text) ??
                                                        0.0;
                                                    if (qty > 0) {
                                                      _controller.addItem(
                                                        iName: _controller
                                                            .otherItemController
                                                            .text,
                                                        qty: qty,
                                                      );
                                                      Get.back();
                                                    }
                                                  },
                                                  buttonHeight: 40.appHeight,
                                                  title: 'Add',
                                                  icon: kIconOther,
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
                                  buttonColor: kColorPrimary,
                                  title: 'Other',
                                  titleSize: FontSize.k20FontSize,
                                  icon: kIconOther,
                                ),
                              ],
                            ),
                            AppSpaces.v20,
                            Obx(
                              () => ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _controller.items.length,
                                itemBuilder: (context, index) {
                                  final item = _controller.items[index];

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
                                                  item['INAME'],
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
                                                  item['INAME'] == 'Petrol' ||
                                                          item['INAME'] ==
                                                              'Diesel'
                                                      ? '${item['QTY']}  Litre'
                                                      : item['QTY'].toString(),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppSpaces.v20,
                  AppButton(
                    onTap: () {
                      if (_controller.formKey.currentState!.validate()) {
                        if (_controller.items.isEmpty) {
                          showErrorSnackbar(
                            'Oops!',
                            'Please enter an item to continue',
                          );
                        } else {
                          _controller.addEntry();
                        }
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
        Obx(
          () => CustomLoadingOverlay(
            isLoading: _controller.isLoading.value,
          ),
        ),
      ],
    );
  }
}
