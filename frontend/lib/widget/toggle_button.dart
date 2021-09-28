import 'package:flutter/material.dart';

import '../global.dart';

class Toggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onToggle;
  Toggle({required this.value, required this.onToggle});

  @override
  _ToggleState createState() => _ToggleState();
}

class _ToggleState extends State<Toggle> with TickerProviderStateMixin {
  late Animation _toggleAnimation, _colorAnimation;
  late AnimationController _toggleController, _colorController;

  @override
  void initState() {
    super.initState();
    _toggleController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _colorController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _toggleAnimation = AlignmentTween(
            begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
            end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(
            parent: _toggleController, curve: Curves.easeInOut));
    _colorAnimation = ColorTween(
      begin: color.contrast,
      end: color.style,
    ).animate(_colorController)
      ..addListener(() {
        setState(() {
          //
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _toggleController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_toggleController.isCompleted) {
              _toggleController.reverse();
              _colorController.reverse();
            } else {
              _toggleController.forward();
              _colorController.forward();
            }
            widget.value == false
                ? widget.onToggle(true)
                : widget.onToggle(false);
          },
          child: Container(
            width: 56,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: color.chooser(
                lightMode: Colors.grey,
                darkMode: Colors.red,
              ),
            ),
            child: Container(
              alignment: _toggleAnimation.value,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _colorAnimation.value,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
