import 'dart:io';

import 'package:afc_studymate/data/services/asset_pack_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
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
  String? _assetPdfPath;
  int _currentPage = 1;
  int _pageCount = 0;
  double _zoomLevel = 1;
  PdfPageLayoutMode _pageLayoutMode = PdfPageLayoutMode.continuous;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage ?? 1;
    _resolvePdfPath();
  }

  Future<void> _resolvePdfPath() async {
    final existingFile = File(widget.pdfPath);
    if (existingFile.existsSync()) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loading = false;
        _resolvedPdfPath = existingFile.path;
      });
      return;
    }

    final assetPackService = ref.read(assetPackServiceProvider);
    var resolved = await assetPackService.resolveFilePath(widget.pdfPath);
    if (resolved == null) {
      await assetPackService.prepare(
        includeLogicalAssetPaths: {widget.pdfPath},
      );
      resolved = await assetPackService.resolveFilePath(widget.pdfPath);
    }
    if (resolved == null) {
      for (final candidate in _assetPathCandidates(widget.pdfPath)) {
        try {
          await rootBundle.load(candidate);
          if (!mounted) {
            return;
          }
          setState(() {
            _loading = false;
            _assetPdfPath = candidate;
          });
          return;
        } catch (_) {
          // Try the next asset key candidate.
        }
      }
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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Study Reader',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: 0.3,
              ),
            ),
            Text(
              widget.title ?? 'Reader',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton.filledTonal(
            icon: const Icon(Icons.share),
            tooltip: 'Share PDF',
            onPressed: _sharePdf,
          ),
          const SizedBox(width: 8),
          IconButton.filledTonal(
            icon: const Icon(Icons.find_in_page_outlined),
            tooltip: 'Go to page',
            onPressed: _loading ? null : _promptForPageNumber,
          ),
          const SizedBox(width: 8),
          IconButton.filledTonal(
            icon: Icon(
              _isSinglePageMode ? Icons.view_stream : Icons.chrome_reader_mode,
            ),
            tooltip: _isSinglePageMode
                ? 'Use scrolling view'
                : 'Use one-page view',
            onPressed: _loading ? null : _toggleReadingMode,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _buildReaderBody(context),
      bottomNavigationBar: _loading ? null : _buildReaderControls(context),
    );
  }

  Widget _buildReaderBody(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surfaceContainerLowest,
          ],
        ),
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            children: [
              _buildReaderSummary(context),
              const SizedBox(height: 14),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.35,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 28,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: _buildViewer(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReaderSummary(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title ?? _fallbackDocumentTitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(
                icon: Icons.menu_book_outlined,
                label: _pageCount > 0
                    ? 'Page $_currentPage of $_pageCount'
                    : 'Preparing document',
                onTap: _pageCount > 0 ? _promptForPageNumber : null,
              ),
              _InfoChip(
                icon: Icons.zoom_in,
                label: '${(_zoomLevel * 100).round()}% zoom',
              ),
              _InfoChip(
                icon: _isSinglePageMode
                    ? Icons.chrome_reader_mode
                    : Icons.view_stream,
                label: _isSinglePageMode ? 'One-page mode' : 'Scroll mode',
                onTap: _toggleReadingMode,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewer() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_resolvedPdfPath == null) {
      if (_assetPdfPath != null) {
        return _buildPdfAssetViewer(_assetPdfPath!);
      }
      return const Center(
        child: Text(
          'This PDF is not available yet. Retry startup and try again.',
        ),
      );
    }
    return _buildPdfFileViewer(File(_resolvedPdfPath!));
  }

  Widget _buildPdfAssetViewer(String assetPath) {
    return SfPdfViewer.asset(
      assetPath,
      initialZoomLevel: _zoomLevel,
      controller: _pdfViewerController,
      canShowPaginationDialog: false,
      canShowScrollHead: false,
      pageLayoutMode: _pageLayoutMode,
      scrollDirection: _scrollDirection,
      onDocumentLoaded: _handleDocumentLoaded,
      onPageChanged: _handlePageChanged,
      onZoomLevelChanged: _handleZoomChanged,
    );
  }

  Widget _buildPdfFileViewer(File file) {
    return SfPdfViewer.file(
      file,
      initialZoomLevel: _zoomLevel,
      controller: _pdfViewerController,
      canShowPaginationDialog: false,
      canShowScrollHead: false,
      pageLayoutMode: _pageLayoutMode,
      scrollDirection: _scrollDirection,
      onDocumentLoaded: _handleDocumentLoaded,
      onPageChanged: _handlePageChanged,
      onZoomLevelChanged: _handleZoomChanged,
    );
  }

  Widget _buildReaderControls(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.26),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reader Controls',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildControlButton(
                        icon: Icons.chevron_left,
                        label: 'Previous',
                        onPressed: _currentPage > 1 ? _goToPreviousPage : null,
                        emphasized: true,
                      ),
                      const SizedBox(width: 10),
                      _buildControlButton(
                        icon: Icons.chevron_right,
                        label: 'Next',
                        onPressed: (_pageCount > 0 && _currentPage < _pageCount)
                            ? _goToNextPage
                            : null,
                        emphasized: true,
                      ),
                      const SizedBox(width: 10),
                      _buildControlButton(
                        icon: Icons.find_in_page_outlined,
                        label: 'Go to page',
                        onPressed: _pageCount > 0 ? _promptForPageNumber : null,
                      ),
                      const SizedBox(width: 10),
                      _buildControlButton(
                        icon: Icons.zoom_out,
                        label: 'Smaller',
                        onPressed: _isDocumentReady ? _zoomOut : null,
                      ),
                      const SizedBox(width: 10),
                      _buildControlButton(
                        icon: Icons.zoom_in,
                        label: 'Bigger',
                        onPressed: _isDocumentReady ? _zoomIn : null,
                      ),
                      const SizedBox(width: 10),
                      _buildControlButton(
                        icon: Icons.center_focus_strong,
                        label: 'Reset zoom',
                        onPressed: _isDocumentReady ? _resetZoom : null,
                      ),
                      if (widget.initialPage != null) ...[
                        const SizedBox(width: 10),
                        _buildControlButton(
                          icon: Icons.flag_outlined,
                          label: 'Lesson start',
                          onPressed: _goToLessonStart,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    bool emphasized = false,
  }) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: label,
      child: emphasized
          ? FilledButton.icon(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(label),
            )
          : FilledButton.tonalIcon(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(label),
            ),
    );
  }

  Future<void> _promptForPageNumber() async {
    if (_pageCount <= 0) {
      return;
    }

    final page = await showDialog<int>(
      context: context,
      builder: (context) => _PageNumberDialog(
        currentPage: _currentPage,
        pageCount: _pageCount,
      ),
    );

    if (page == null) {
      return;
    }
    if (page < 1 || page > _pageCount) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Choose a page between 1 and $_pageCount.')),
      );
      return;
    }

    _pdfViewerController.jumpToPage(page);
  }

  void _handleDocumentLoaded(PdfDocumentLoadedDetails details) {
    final pageCount = details.document.pages.count;
    final initialPage = widget.initialPage == null
        ? _currentPage.clamp(1, pageCount)
        : widget.initialPage!.clamp(1, pageCount);

    setState(() {
      _pageCount = pageCount;
      _currentPage = initialPage;
      _zoomLevel = _pdfViewerController.zoomLevel;
    });

    if (widget.initialPage != null) {
      _pdfViewerController.jumpToPage(initialPage);
    }
    _applyAccessibilityDefaults();
  }

  void _handlePageChanged(PdfPageChangedDetails details) {
    if (!mounted) {
      return;
    }
    setState(() {
      _currentPage = details.newPageNumber;
    });
  }

  void _handleZoomChanged(PdfZoomDetails details) {
    if (!mounted) {
      return;
    }
    setState(() {
      _zoomLevel = details.newZoomLevel;
    });
  }

  void _applyAccessibilityDefaults() {
    final mediaQuery = MediaQuery.maybeOf(context);
    if (mediaQuery == null) {
      return;
    }

    final prefersLargerView =
        mediaQuery.accessibleNavigation ||
        mediaQuery.highContrast ||
        mediaQuery.textScaler.scale(1) > 1.15;
    if (prefersLargerView && _zoomLevel < 1.5) {
      _setZoom(1.5);
    }
  }

  void _goToPreviousPage() {
    _pdfViewerController.previousPage();
  }

  void _goToNextPage() {
    _pdfViewerController.nextPage();
  }

  void _goToLessonStart() {
    final initialPage = widget.initialPage;
    if (initialPage == null) {
      return;
    }
    _pdfViewerController.jumpToPage(initialPage);
  }

  void _zoomIn() {
    _setZoom(_zoomLevel + 0.25);
  }

  void _zoomOut() {
    _setZoom(_zoomLevel - 0.25);
  }

  void _resetZoom() {
    _setZoom(1);
  }

  void _setZoom(double value) {
    final clamped = value.clamp(1.0, 3.0);
    if (clamped == _zoomLevel) {
      return;
    }

    if (!_isDocumentReady) {
      if (!mounted) {
        return;
      }
      setState(() {
        _zoomLevel = clamped;
      });
      return;
    }

    _pdfViewerController.zoomLevel = clamped;
  }

  void _toggleReadingMode() {
    setState(() {
      _pageLayoutMode = _isSinglePageMode
          ? PdfPageLayoutMode.continuous
          : PdfPageLayoutMode.single;
    });
  }

  Future<void> _sharePdf() async {
    try {
      if (_resolvedPdfPath == null) {
        if (_assetPdfPath != null) {
          final bytes = await rootBundle.load(_assetPdfPath!);
          final directory = await getTemporaryDirectory();
          final fileName = widget.pdfPath.split('/').last;
          final file = File('${directory.path}/$fileName');
          await file.writeAsBytes(
            bytes.buffer.asUint8List(
              bytes.offsetInBytes,
              bytes.lengthInBytes,
            ),
          );
          await Share.shareXFiles(
            [XFile(file.path)],
            text: widget.title ?? 'StudyMate PDF',
          );
          return;
        }
        if (!mounted) {
          return;
        }
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
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to share this PDF right now.')),
      );
    }
  }

  Iterable<String> _assetPathCandidates(String path) sync* {
    yield path;

    final encodedSpaces = path.replaceAll(' ', '%20');
    if (encodedSpaces != path) {
      yield encodedSpaces;
    }

    final fullyEncoded = Uri.encodeFull(path).replaceAll('%27', "'");
    if (fullyEncoded != path && fullyEncoded != encodedSpaces) {
      yield fullyEncoded;
    }
  }

  bool get _isSinglePageMode => _pageLayoutMode == PdfPageLayoutMode.single;

  bool get _isDocumentReady => _pageCount > 0;

  PdfScrollDirection get _scrollDirection => _isSinglePageMode
      ? PdfScrollDirection.horizontal
      : PdfScrollDirection.vertical;

  String get _fallbackDocumentTitle => widget.pdfPath.split('/').last;
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: onTap != null,
      label: label,
      child: InputChip(
        backgroundColor: theme.colorScheme.surface,
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.28),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        avatar: Icon(
          icon,
          size: 18,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        label: Text(label),
        onPressed: onTap,
      ),
    );
  }
}

class _PageNumberDialog extends StatefulWidget {
  const _PageNumberDialog({
    required this.currentPage,
    required this.pageCount,
  });

  final int currentPage;
  final int pageCount;

  @override
  State<_PageNumberDialog> createState() => _PageNumberDialogState();
}

class _PageNumberDialogState extends State<_PageNumberDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.currentPage}');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Go To Page'),
      scrollable: true,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter a page from 1 to ${widget.pageCount}.'),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Page number',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Go'),
        ),
      ],
    );
  }

  void _submit() {
    final value = int.tryParse(_controller.text.trim());
    Navigator.of(context).pop(value);
  }
}
