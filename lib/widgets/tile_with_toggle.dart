import 'package:auto_subtitle/service/constants.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class TileWithToggle extends StatefulWidget {
  const TileWithToggle({
    super.key,
    required this.text,
    required this.leading,
    required this.initialLabelIndex,
    required this.totalSwitches,
    required this.activeBgColor,
    required this.activeFgColor,
    required this.labels,
    required this.onToggle,
  });

  final String text;
  final IconData? leading;
  final int initialLabelIndex;
  final int totalSwitches;
  final Color activeBgColor;
  final Color activeFgColor;
  final List<String> labels;
  final Function(dynamic) onToggle;
  @override
  State<TileWithToggle> createState() => _TileWithToggle();
}

class _TileWithToggle extends State<TileWithToggle> {
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
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    child: ToggleSwitch(
                      initialLabelIndex: widget.initialLabelIndex,
                      totalSwitches: widget.totalSwitches,
                      labels: widget.labels,
                      minHeight: screenHeight * 0.05,
                      activeBgColor: [widget.activeBgColor],
                      activeFgColor: widget.activeFgColor,
                      inactiveFgColor: accentColor,
                      onToggle: widget.onToggle,
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
