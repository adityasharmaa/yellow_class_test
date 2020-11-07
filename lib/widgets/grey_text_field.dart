import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GreyTextField extends StatefulWidget {
  final String hint;
  final bool obscured, enabled, showCounter;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLength;

  GreyTextField({
    @required this.controller,
    @required this.hint,
    this.obscured = false,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.maxLength = 1000,
    this.showCounter = false,
  });

  @override
  _GreyTextFieldState createState() => _GreyTextFieldState();
}

class _GreyTextFieldState extends State<GreyTextField> {
  bool hide = true;
  final _border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
    borderSide: BorderSide(color: Colors.grey[300]),
  );

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        disabledBorder: _border,
        border: _border,
        focusedBorder: _border,
        enabledBorder: _border,
        filled: true,
        fillColor: Colors.grey[100],
        hintText: widget.hint,
        suffixIcon: widget.obscured
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    hide = !hide;
                  });
                },
                child: Icon(
                  hide ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black,
                ),
              )
            : null,
      ),
      obscureText: widget.obscured && hide,
      controller: widget.controller,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      inputFormatters: [
        LengthLimitingTextInputFormatter(widget.maxLength),
      ],
    );
  }
}
