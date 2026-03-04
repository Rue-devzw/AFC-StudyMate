import 'dart:io';

import 'package:afc_studymate/data/services/asset_pack_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends ConsumerStatefulWidget {
  const PdfViewerScreen({
    required this.pdfPath,
    super.key,
    this.title,
    this.initialPage,
  });

  final String pdfPath;
  final String? title;
  final int? initialPage;

  static const String routeName = 'pdfViewer';

  @override
  ConsumerState<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends ConsumerState<PdfViewerScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  bool _loading = true;
  String? _resolvedPdfPath;

  @override
  void initState() {
    super.initState();
    _resolvePdfPath();
  }

  Future<void> _resolvePdfPath() async {
    final assetPackService = ref.read(assetPackServiceProvider);
    var resolved = await assetPackService.resolveFilePath(widget.pdfPath);
    if (resolved == null) {
      await assetPackService.prepare(
        includeLogicalAssetPaths: {widget.pdfPath},
      );
      resolved = await assetPackService.resolveFilePath(widget.pdfPath);
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _loading = false;
      _resolvedPdfPath = resolved;
    });
  }

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
      body: _buildViewer(),
    );
  }

  Widget _buildViewer() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_resolvedPdfPath == null) {
      return const Center(
        child: Text(
          'This PDF is not available yet. Retry startup and try again.',
        ),
      );
    }
    return SfPdfViewer.file(
      File(_resolvedPdfPath!),
      controller: _pdfViewerController,
      onDocumentLoaded: (details) {
        if (widget.initialPage != null) {
          _pdfViewerController.jumpToPage(widget.initialPage!);
        }
      },
    );
  }

  Future<void> _sharePdf() async {
    try {
      if (_resolvedPdfPath == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF file is not ready yet.')),
        );
        return;
      }
      final directory = await getTemporaryDirectory();
      final fileName = widget.pdfPath.split('/').last;
      final file = File('${directory.path}/$fileName');
      await File(_resolvedPdfPath!).copy(file.path);
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
