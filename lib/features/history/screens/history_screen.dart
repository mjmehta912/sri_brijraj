import 'package:brijraj_app/constants/color_constants.dart';
import 'package:brijraj_app/features/history/controllers/history_controller.dart';
import 'package:brijraj_app/features/history/models/history_model_dm.dart';
import 'package:brijraj_app/styles/textstyles.dart';
import 'package:brijraj_app/widgets/app_appbar.dart';
import 'package:brijraj_app/widgets/app_paddings.dart';
import 'package:brijraj_app/widgets/app_size_extensions.dart';
import 'package:brijraj_app/widgets/app_spacings.dart';
import 'package:brijraj_app/widgets/app_text_form_field.dart';
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
    _controller.fetchSlipHistory();
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
        child: Column(
          children: [
            AppTextFormField(
              controller: _controller.searchController,
              hintText: 'Search Slip',
              onChanged: (query) {
                _controller.searchQuery.value = query;
              },
            ),
            AppSpaces.v12,
            Obx(
              () {
                if (_controller.isLoading.value) {
                  return Expanded(
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: kColorDarkBlue,
                      ),
                    ),
                  );
                }
                if (_controller.historyList.isEmpty) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'No history found.',
                        style: TextStyles.kBoldInstrumentSans(
                          color: kColorSecondary,
                        ),
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollEndNotification &&
                          scrollNotification.metrics.extentAfter == 0) {
                        _controller.fetchSlipHistory(
                          loadMore: true,
                        );
                      }
                      return false;
                    },
                    child: Obx(
                      () => ListView.builder(
                        itemCount: _controller.historyList.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _controller.historyList.length) {
                            return _controller.isLoadingMore.value
                                ? Padding(
                                    padding: AppPaddings.p10,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: kColorDarkBlue,
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          }
                          final history = _controller.historyList[index];
                          return HistoryCard(
                            history: history,
                            controller: _controller,
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    super.key,
    required this.history,
    required HistoryController controller,
  }) : _controller = controller;

  final HistoryModelDm history;
  final HistoryController _controller;

  @override
  Widget build(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                history.slipNo,
                style: TextStyles.kSemiBoldInstrumentSans(
                  color: kColorPrimary,
                  fontSize: 18,
                ),
              ),
              Row(
                children: [
                  if (history.user != null && history.user!.isNotEmpty)
                    Text(
                      history.user!,
                      style: TextStyles.kSemiBoldInstrumentSans(
                        color: kColorLightGrey,
                        fontSize: FontSize.k14FontSize,
                      ),
                    ),
                  AppSpaces.h10,
                  InkWell(
                    onTap: () {
                      _controller.viewPdf(slipNo: history.slipNo);
                    },
                    child: Icon(
                      Icons.print,
                      color: kColorPrimary,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                history.date,
                style: TextStyles.kSemiBoldInstrumentSans(
                  color: kColorPrimary,
                  fontSize: FontSize.k18FontSize,
                ),
              ),
              SizedBox(
                width: 0.4.screenWidth,
                child: Text(
                  history.entryDateTime,
                  style: TextStyles.kSemiBoldInstrumentSans(
                    color: kColorLightGrey,
                    fontSize: FontSize.k14FontSize,
                  ),
                ),
              ),
            ],
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
          if (history.transporter.isNotEmpty)
            Text(
              'Transporter : ${history.transporter}',
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
                  fontSize: FontSize.k18FontSize,
                ),
              ),
            ],
          ),
          if (history.remark.isNotEmpty)
            Text(
              history.remark,
              style: TextStyles.kMediumInstrumentSans(
                color: kColorPrimary,
                fontSize: FontSize.k18FontSize,
              ).copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
}
