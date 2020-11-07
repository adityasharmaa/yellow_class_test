import 'package:flutter/material.dart';

class FancyButton extends StatelessWidget {
  final String label;
  final void Function() action;
  final bool isLoading;
  final bool disable;
  final Color color;

  FancyButton({
    @required this.label,
    @required this.action,
    this.isLoading = false,
    this.disable = false,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.longestSide;
    return InkWell(
      child: Container(
        height: _height * 0.06,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: color,
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text(
                      label,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
            ),
            if(disable)
              Positioned.fill(child: Container(color: Colors.white54)),
          ],
        ),
      ),
      onTap: disable ? null : isLoading ? null : action,
    );
  }
}
