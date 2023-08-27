import 'package:flutter/material.dart';

import '../theme/palette.dart';

/// Primary button based on [ElevatedButton].
/// Useful for CTAs in the app.
/// @param text - text to display on the button.
/// @param isLoading - if true, a loading indicator will be displayed instead of
/// the text.
/// @param onPressed - callback to be called when the button is pressed.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    this.isLoading = false,
    this.onPressed,
    this.width,
    this.height,
    this.textStyle,
    this.backgroundColor,
    this.borderRadius,
    this.elevation,
    this.hasRippleEffect = true,
  });
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final double? elevation;
  final bool hasRippleEffect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll(backgroundColor ?? Pallete.blueColor),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(8))),
            elevation: MaterialStatePropertyAll(elevation ?? 3),
            overlayColor: MaterialStatePropertyAll(
                hasRippleEffect ? null : Colors.transparent)),
        child: isLoading
            ? const CircularProgressIndicator()
            : Text(
                text,
                textAlign: TextAlign.center,
                style: textStyle ??
                    const TextStyle(
                      fontSize: 18,
                      color: Pallete.whiteColor,
                      fontWeight: FontWeight.w500,
                    ),
              ),
      ),
    );
  }
}
