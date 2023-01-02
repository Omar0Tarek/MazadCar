import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(
          width: double.infinity,
          child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Chats",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 30),
              )),
        ),
        Divider(
          thickness: 1, // thickness of the line
          indent: 5, // empty space to the leading edge of divider.
          endIndent: 5, // empty space to the trailing edge of the divider.
          color: Colors.grey, // The color to use when painting the line.
          height: 0, // The divider's height extent.
        ),
      ],
    );
  }
}
