import 'package:flutter/material.dart';

import '../global.dart';

class AppButton extends StatelessWidget {
  final String buttonText;
  final Color? splashColor;
  final Color? buttonColor;
  final Color? textColor;
  final double? fontSize;
  final VoidCallback? onTap;
  final double? height;
  final double? width;
  final double? gap;
  final Widget? icon;
  final double? borderRadius;
  final Alignment? align; 
  final MainAxisAlignment? mainAxisAlignment;
  AppButton({
    required this.buttonText,
    this.buttonColor,
    this.splashColor,
    this.textColor,
    this.fontSize,
    required this.onTap,
    this.height,
    this.width,
    this.gap,
    this.icon,
    this.borderRadius,
    this.align,
    this.mainAxisAlignment,
  });
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 7),
      child: SizedBox(
        width: width ?? MediaQuery.of(context).size.width,
        height: height ?? 50,
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Material(
            color: buttonColor ?? color.style,
            child: InkWell(
              splashColor: splashColor ?? color.main.withOpacity(0.2),
              child: Container(
                alignment: align ?? Alignment.center,
                width: width ?? MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(
                  vertical: (height == null) ? (10) : (height! / 5),
                ),
                child: (icon == null)
                    ? (Text(
                        buttonText,
                        style: style.body.copyWith(
                          fontSize: 10,
                          color: textColor ?? color.light,
                        ),
                      ))
                    : (Row(
                      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: height ?? 40,
                            width: (width == null) ? (40) : (width! / 10),
                            child: FittedBox(
                              child: icon!,
                            ),
                          ),
                          SizedBox(
                            width: gap ?? 10,
                          ),
                          Text(
                            buttonText,
                            style: (fontSize != null)
                                ? (style.body
                                    .copyWith(fontSize: fontSize, color: textColor ?? color.light))
                                : (style.body
                                    .copyWith(fontSize: 19, color: textColor ?? color.light)),
                          ),
                        ],
                      )),
              ),
              onTap: onTap,
            ),
          ),
        ),
      ),
    );
  }
}
