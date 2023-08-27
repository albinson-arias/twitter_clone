import 'package:flutter/material.dart';
import 'package:twitter_clone/src/theme/theme.dart';

class RoundedSmallButton extends StatelessWidget {
  const RoundedSmallButton({
    super.key,
    required this.label,
    this.onPressed,
    this.backGroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.isLoading = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final Color backGroundColor;
  final Color textColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Chip(
        backgroundColor: isLoading ? Pallete.greyColor : backGroundColor,
        label: Text(
          label,
          style: TextStyle(
            color: isLoading ? Pallete.whiteColor : textColor,
            fontSize: 16,
          ),
        ),
        labelPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
      ),
    );
  }
}
