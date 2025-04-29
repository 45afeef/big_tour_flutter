import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HybridTextEditor extends StatefulWidget {
  const HybridTextEditor({
    Key? key,
    this.text,
    this.hintText = "Enter here",
    this.style,
    this.minLines,
    this.maxLines,
    this.keyboardType,
    this.inputFormatters,
    this.onSaved,
    this.validator,
    this.isEditable = false,
  }) : super(key: key);

  final String? text;
  final String hintText;
  final TextStyle? style;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String? value)? validator;
  final void Function(String? value)? onSaved;
  final bool isEditable;

  @override
  State<HybridTextEditor> createState() => _HybridTextEditorState();
}

class _HybridTextEditorState extends State<HybridTextEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers when the widget is first initialized.
    _controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    super.dispose();
    // Clean up the controller when the widget is disposed.
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isEditable
        ? TextFormField(
            controller: _controller,
            decoration: InputDecoration(hintText: widget.hintText),
            style: widget.style,
            inputFormatters: widget.inputFormatters,
            keyboardType: widget.keyboardType,
            onSaved: widget.onSaved,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            validator: widget.validator ??
                (String? value) {
                  return (value == null || value.isEmpty)
                      ? 'Please enter a valid value'
                      : null;
                },
          )
        : Text(
            widget.text ?? "",
            style: widget.style,
          );
  }
}
