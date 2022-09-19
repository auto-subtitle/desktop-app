import 'package:auto_subtitle/service/constants.dart';
import 'package:flutter/material.dart';

class CreateActionWidget extends StatefulWidget {
  const CreateActionWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  final String text;
  final Icon icon;
  final VoidCallback? onPressed;

  @override
  State<CreateActionWidget> createState() => _CreateActionWidgetState();
}

class _CreateActionWidgetState extends State<CreateActionWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: accentColor,
      child: SizedBox(
        width: 150,
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            widget.icon,
            MaterialButton(
              color: primaryColor,
              disabledElevation: 0,
              disabledColor: subAccentColor,
              mouseCursor: (widget.onPressed != null)
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.forbidden,
              elevation: 5,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              onPressed: widget.onPressed,
              child: Text(
                widget.text,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
