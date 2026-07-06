import 'package:flutter/material.dart';

class RunningText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const RunningText({
    super.key,
    required this.text,
    required this.style,
  });

  @override
  State<RunningText> createState() => _RunningTextState();
}

class _RunningTextState extends State<RunningText> {
  late ScrollController _scrollController;
  String? _currentText;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _currentText = widget.text;
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  @override
  void didUpdateWidget(covariant RunningText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _currentText = widget.text;
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
    }
  }

  void _startScrolling() async {
    final textToScroll = widget.text;
    if (!_scrollController.hasClients) return;
    
    // Let layout settle so maxScrollExtent is calculated correctly
    await Future.delayed(const Duration(milliseconds: 100));
    if (!mounted || !_scrollController.hasClients || _currentText != textToScroll) return;

    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    if (maxScrollExtent <= 0) return;

    while (mounted && _currentText == textToScroll) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted || !_scrollController.hasClients || _currentText != textToScroll) break;
      
      await _scrollController.animateTo(
        maxScrollExtent,
        duration: Duration(milliseconds: (maxScrollExtent * 35).toInt()),
        curve: Curves.linear,
      );
      
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted || !_scrollController.hasClients || _currentText != textToScroll) break;
      
      await _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: (maxScrollExtent * 35).toInt()),
        curve: Curves.linear,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Text(
        widget.text,
        style: widget.style,
        maxLines: 1,
      ),
    );
  }
}
