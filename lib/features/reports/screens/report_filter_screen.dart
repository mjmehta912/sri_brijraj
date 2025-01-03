import 'package:brijraj_app/constants/color_constants.dart';
import 'package:brijraj_app/features/reports/controllers/reports_controller.dart';

import 'package:brijraj_app/styles/textstyles.dart';
import 'package:brijraj_app/utils/alert_message_utils.dart';
import 'package:brijraj_app/utils/text_input_formatters.dart';
import 'package:brijraj_app/widgets/app_appbar.dart';
import 'package:brijraj_app/widgets/app_button.dart';
import 'package:brijraj_app/widgets/app_date_picker_text_form_field.dart';
import 'package:brijraj_app/widgets/app_loading_overlay.dart';
import 'package:brijraj_app/widgets/app_paddings.dart';
import 'package:brijraj_app/widgets/app_size_extensions.dart';
import 'package:brijraj_app/widgets/app_spacings.dart';
import 'package:brijraj_app/widgets/app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReportFilterScreen extends StatefulWidget {
  const ReportFilterScreen({
    super.key,
  });

  @override
  State<ReportFilterScreen> createState() => _ReportFilterScreenState();
}

class _ReportFilterScreenState extends State<ReportFilterScreen> {
  final ReportsController _controller = Get.put(
    ReportsController(),
  );

  @override
  void initState() {
    super.initState();

    _controller.fromDateController.text = DateFormat('dd-MM-yyyy').format(
      DateTime.now(),
    );
    _controller.toDateController.text = DateFormat('dd-MM-yyyy').format(
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
                  AppDatePickerTextFormField(
                    dateController: _controller.fromDateController,
                    hintText: 'From Date',
                  ),
                  AppSpaces.v16,
                  AppDatePickerTextFormField(
                    dateController: _controller.toDateController,
                    hintText: 'To Date',
                  ),
                  AppSpaces.v16,
                  AppTextFormField(
                    controller: _controller.transporterNameController,
                    hintText: 'Transporter',
                    onChanged: (value) {
                      _controller.fetchTransporters(
                        tname: value,
                      );
                    },
                    inputFormatters: [
                      TitleCaseTextInputFormatter(),
                    ],
                  ),
                  Obx(
                    () {
                      if (_controller.filteredTransporters.isEmpty ||
                          _controller.transporterNameController.text.isEmpty) {
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
                            itemCount: _controller.filteredTransporters.length,
                            itemBuilder: (context, index) {
                              final transporter =
                                  _controller.filteredTransporters[index];
                              return GestureDetector(
                                onTap: () {
                                  _controller
                                      .setSelectedTransporter(transporter);
                                  _controller.filteredTransporters.clear();
                                },
                                child: Text(
                                  transporter.transporterName,
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
                  AppSpaces.v16,
                  AppTextFormField(
                    controller: _controller.customerNameController,
                    hintText: 'Owner',
                    onChanged: (value) {
                      _controller.fetchCustomers(
                        pname: value,
                      );
                    },
                    inputFormatters: [
                      TitleCaseTextInputFormatter(),
                    ],
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
                  AppButton(
                    onTap: () async {
                      final fromDate = _controller.fromDateController.text;
                      final toDate = _controller.toDateController.text;

                      final DateFormat format = DateFormat('dd-MM-yyyy');
                      final DateTime fromDateParsed = format.parse(fromDate);
                      final DateTime toDateParsed = format.parse(toDate);

                      if (toDateParsed.isBefore(fromDateParsed)) {
                        showErrorSnackbar(
                          'Error',
                          'To Date must be greater than or equal to From Date.',
                        );
                        return;
                      }
                      await _controller.downloadReport();
                    },
                    buttonHeight: 40.appHeight,
                    title: 'Download Report',
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
