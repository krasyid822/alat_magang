import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/file_chunk_service.dart';
import '../../dashboard/provider/dashboard_provider.dart';

class ChunkedImage extends ConsumerStatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const ChunkedImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorBuilder,
  });

  @override
  ConsumerState<ChunkedImage> createState() => _ChunkedImageState();
}

class _ChunkedImageState extends ConsumerState<ChunkedImage> {
  static final Map<String, Uint8List> _memoryCache = {};
  
  Uint8List? _bytes;
  bool _isLoading = false;
  String? _error;
  String? _loadedUrl;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(ChunkedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    final url = widget.url;
    if (url.isEmpty) return;

    if (!url.startsWith(kChunkedPrefix)) {
      // Not a chunked URL (might be a standard url or data URL)
      if (mounted) {
        setState(() {
          _bytes = null;
          _isLoading = false;
          _error = null;
          _loadedUrl = url;
        });
      }
      return;
    }

    if (_memoryCache.containsKey(url)) {
      if (mounted) {
        setState(() {
          _bytes = _memoryCache[url];
          _isLoading = false;
          _error = null;
          _loadedUrl = url;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = true;
        _error = null;
        _loadedUrl = url;
      });
    }

    try {
      final chunkedRef = ChunkedFileRef.fromUrl(url);
      if (chunkedRef == null) {
        throw Exception('Invalid chunked URL format');
      }

      final nim = ref.read(dashboardControllerProvider).nim;
      if (nim.isEmpty) {
        throw Exception('User NIM is empty');
      }

      final bytes = await fileChunkService.downloadFile(nim, chunkedRef);
      if (bytes == null) {
        throw Exception('Failed to download file chunks');
      }

      _memoryCache[url] = bytes;

      if (mounted && _loadedUrl == url) {
        setState(() {
          _bytes = bytes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted && _loadedUrl == url) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url.isEmpty) {
      return _buildError(context, 'Empty URL');
    }

    if (!widget.url.startsWith(kChunkedPrefix)) {
      // standard network/data URL
      return Image.network(
        widget.url,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: widget.errorBuilder ?? (context, error, stackTrace) => _buildError(context, error),
      );
    }

    if (_isLoading) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (_error != null) {
      return _buildError(context, _error!);
    }

    if (_bytes != null) {
      return Image.memory(
        _bytes!,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        errorBuilder: widget.errorBuilder ?? (context, error, stackTrace) => _buildError(context, error),
      );
    }

    return SizedBox(width: widget.width, height: widget.height);
  }

  Widget _buildError(BuildContext context, Object error) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white10
          : Colors.black12,
      child: const Center(
        child: Icon(Icons.broken_image_rounded, color: Colors.grey, size: 24),
      ),
    );
  }
}
