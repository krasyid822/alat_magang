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

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  void _startScrolling() async {
    if (!_scrollController.hasClients) return;
    
    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    if (maxScrollExtent <= 0) return;

    while (mounted) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted || !_scrollController.hasClients) break;
      
      await _scrollController.animateTo(
        maxScrollExtent,
        duration: Duration(milliseconds: (maxScrollExtent * 35).toInt()),
        curve: Curves.linear,
      );
      
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted || !_scrollController.hasClients) break;
      
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
