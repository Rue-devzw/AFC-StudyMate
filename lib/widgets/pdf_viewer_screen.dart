import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({
    super.key,
    required this.pdfPath,
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
        onDocumentLoaded: (PdfDocumentLoadedDetails details) {
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
}
