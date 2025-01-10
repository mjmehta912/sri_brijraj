import 'dart:io';
import 'dart:typed_data';
import 'package:brijraj_app/constants/color_constants.dart';
import 'package:brijraj_app/utils/alert_message_utils.dart';
import 'package:brijraj_app/widgets/app_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class PdfScreen extends StatefulWidget {
  final Uint8List pdfBytes;
  final String title;

  const PdfScreen({
    super.key,
    required this.pdfBytes,
    required this.title,
  });

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  bool isPdfReady = false;

  @override
  void initState() {
    super.initState();
    isPdfReady = false;
  }

  Future<void> _sharePdf() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final sanitizedTitle = widget.title.replaceAll(
        RegExp(r'[^\w\s]+'),
        '_',
      );
      final fileName = '$sanitizedTitle.pdf';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(widget.pdfBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Here is a PDF file: ${widget.title}',
      );
    } catch (e) {
      showErrorSnackbar('Error', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorLightGrey,
      appBar: AppAppbar(
        title: widget.title,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.share,
              size: 25,
              color: kColorPrimary,
            ),
            onPressed: _sharePdf,
          ),
        ],
      ),
      body: Stack(
        children: [
          PDFView(
            pdfData: widget.pdfBytes,
            enableSwipe: true,
            autoSpacing: false,
            pageFling: false,
            fitPolicy: FitPolicy.BOTH,
            onRender: (pages) async {
              await Future.delayed(Duration(milliseconds: 300));
              if (mounted) {
                setState(() {
                  isPdfReady = true;
                });
              }
            },
          ),
          isPdfReady
              ? const SizedBox.shrink()
              : const Center(
                  child: CircularProgressIndicator(
                    color: kColorPrimary,
                  ),
                ),
        ],
      ),
    );
  }
}
