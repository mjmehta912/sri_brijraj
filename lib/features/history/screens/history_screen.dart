import 'package:brijraj_app/constants/color_constants.dart';
import 'package:brijraj_app/features/history/controllers/history_controller.dart';
import 'package:brijraj_app/styles/textstyles.dart';
import 'package:brijraj_app/widgets/app_appbar.dart';
import 'package:brijraj_app/widgets/app_paddings.dart';
import 'package:brijraj_app/widgets/app_size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({
    super.key,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryController _controller = Get.put(
    HistoryController(),
  );

  @override
  void initState() {
    super.initState();
    _controller.fetchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBackground,
      appBar: const AppAppbar(),
      body: Padding(
        padding: AppPaddings.combined(
          horizontal: 15.appWidth,
          vertical: 10.appHeight,
        ),
        child: Obx(
          () {
            if (_controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(
                  color: kColorDarkBlue,
                ),
              );
            }
            if (_controller.historyList.isEmpty) {
              return Center(
                child: Text(
                  'No history found.',
                  style: TextStyles.kBoldInstrumentSans(
                    color: kColorSecondary,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: _controller.historyList.length,
              itemBuilder: (context, index) {
                final history = _controller.historyList[index];

                return Container(
                  padding: AppPaddings.p8,
                  margin: AppPaddings.pv4,
                  decoration: BoxDecoration(
                    gradient: const RadialGradient(
                      colors: [
                        kColorwhite,
                        kColorPrimary,
                      ],
                      radius: 15,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: kColorPrimary,
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        history.slipNo,
                        style: TextStyles.kSemiBoldInstrumentSans(
                          color: kColorPrimary,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        history.date,
                        style: TextStyles.kSemiBoldInstrumentSans(
                          color: kColorPrimary,
                          fontSize: 18,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: history.items.length,
                        itemBuilder: (context, itemIndex) {
                          final item = history.items[itemIndex];

                          return Text(
                            item.iname == 'Petrol' || item.iname == 'Diesel'
                                ? '${item.iname} - ${item.qty} L'
                                : '${item.iname} - ${item.qty}',
                            style: TextStyles.kSemiBoldInstrumentSans(
                              color: kColorSecondary,
                              fontSize: 18,
                            ),
                          );
                        },
                      ),
                      Text(
                        history.transporter.isNotEmpty
                            ? history.transporter
                            : 'N/A',
                        style: TextStyles.kSemiBoldInstrumentSans(
                          color: kColorPrimary,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            history.pname,
                            style: TextStyles.kSemiBoldInstrumentSans(
                              color: kColorPrimary,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            history.vehicleNo,
                            style: TextStyles.kSemiBoldInstrumentSans(
                              color: kColorPrimary,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
