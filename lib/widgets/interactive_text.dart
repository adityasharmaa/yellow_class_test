import 'package:flutter/material.dart';

class InteractiveText extends StatelessWidget {
  final String normalText, boldText;
  final void Function() action;
  InteractiveText({
    @required this.action,
    @required this.boldText,
    @required this.normalText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: SizedBox(
        //SizedBox provides bigger area to click
        height: MediaQuery.of(context).size.longestSide * 0.03,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              normalText,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            Text(
              boldText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
