import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';

class HighlightTextField extends StatefulWidget {
  final String language;
  final String initialText;
  final Function(String) onChanged;

  const HighlightTextField({
    super.key, 
    required this.language,
    required this.initialText,
    required this.onChanged,
  });

  @override
  _HighlightTextFieldState createState() => _HighlightTextFieldState();
}

class _HighlightTextFieldState extends State<HighlightTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _controller.addListener(() {
      widget.onChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Syntax highlighting
        Positioned.fill(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: HighlightView(
              _controller.text,
              language: widget.language,
              theme: githubTheme,
              padding: const EdgeInsets.all(12),
              textStyle: const TextStyle(
                fontFamily: 'Courier',
                fontSize: 16,
              ),
            ),
          ),
        ),
        TextField(
          controller: _controller,
          maxLines: null,
          style: const TextStyle(
            color: Colors.transparent,
            fontFamily: 'Courier',
            fontSize: 16,
          ),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Edit your ${widget.language} code here',
            fillColor: Colors.transparent,
            filled: true,
            contentPadding: const EdgeInsets.all(12),
          ),
          cursorColor: Colors.black,
          cursorWidth: 2,
        ),
      ],
    );
  }
}
