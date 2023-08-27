import 'package:flutter/material.dart';
import 'package:twitter_clone/src/theme/palette.dart';

class AuthField extends StatefulWidget {
  const AuthField({
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
    this.hintText,
    this.textInputAction,
    this.keyboardType,
    this.onFieldSubmitted,
    this.isPassword = false,
  });
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final String? hintText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final void Function(String)? onFieldSubmitted;
  final bool isPassword;

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  late bool _obscureText;

  @override
  void initState() {
    _obscureText = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      obscureText: _obscureText,
      decoration: InputDecoration(
        isDense: widget.isPassword,
        suffixIcon: widget.isPassword
            ? IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Pallete.greyColor,
                ),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : null,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Pallete.blueColor,
            width: 3,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Pallete.greyColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Pallete.greyColor,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Pallete.redColor,
            width: 3,
          ),
        ),
        contentPadding: const EdgeInsets.all(22),
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
