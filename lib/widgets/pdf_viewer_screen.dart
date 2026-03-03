import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({
    required this.pdfPath, super.key,
    this.title,
    this.initialPage,
  });

  final String pdfPath;
  final String? title;
  final int? initialPage;

  static const String routeName = 'pdfViewer';

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Reader'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share PDF',
            onPressed: _sharePdf,
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () {
              // Future enhancement
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Future enhancement
            },
          ),
        ],
      ),
      body: SfPdfViewer.asset(
        widget.pdfPath,
        controller: _pdfViewerController,
        onDocumentLoaded: (details) {
          if (widget.initialPage != null) {
            // SfPdfViewer page index is 1-based or 0-based?
            // According to docs, jumpToPage(int pageNumber) is 1-based?
            // Actually jumpToPage(int pageNumber) where pageNumber is 1-based.
            _pdfViewerController.jumpToPage(widget.initialPage!);
          }
        },
      ),
    );
  }

  Future<void> _sharePdf() async {
    try {
      final data = await rootBundle.load(widget.pdfPath);
      final bytes = data.buffer.asUint8List();
      final directory = await getTemporaryDirectory();
      final fileName = widget.pdfPath.split('/').last;
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes, flush: true);
      await Share.shareXFiles(
        [XFile(file.path)],
        text: widget.title ?? 'StudyMate PDF',
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to share this PDF right now.')),
      );
    }
  }
}
