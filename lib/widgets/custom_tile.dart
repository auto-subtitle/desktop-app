import 'package:auto_subtitle/service/constants.dart';
import 'package:flutter/material.dart';

class CustomTile extends StatefulWidget {
  const CustomTile({
    super.key,
    required this.text,
    required this.description,
    required this.leading,
    required this.buttonText,
    required this.onPressed,
  });

  final String text;
  final String description;
  final IconData? leading;
  final String buttonText;
  final VoidCallback? onPressed;

  @override
  State<CustomTile> createState() => _CustomTileState();
}

class _CustomTileState extends State<CustomTile> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.1,
      child: Card(
        color: accentColor,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Icon(
                widget.leading,
                color: secondaryColor,
              ),
            ),
            Text(
              widget.text,
              style: TextStyle(
                color: secondaryColor,
                fontSize: 17,
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    child: (widget.description.length > 70)
                        ? Text(
                            "...${widget.description.substring(widget.description.length - 57, widget.description.length)}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 13,
                            ),
                          )
                        : Text(
                            widget.description,
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 13,
                            ),
                          ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: MaterialButton(
                      color: primaryColor,
                      onPressed: widget.onPressed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(widget.buttonText),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
