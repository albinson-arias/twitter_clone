import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:twitter_clone/src/common_widgets/common_widgets.dart';
import 'package:twitter_clone/src/common_widgets/rounded_small_button.dart';
import 'package:twitter_clone/src/constants/ui_constants.dart';
import 'package:twitter_clone/src/exceptions/localized_codes_messages.dart';
import 'package:twitter_clone/src/features/auth/controllers/auth_controller.dart';
import 'package:twitter_clone/src/features/auth/widgets/auth_field.dart';
import 'package:twitter_clone/src/l10n/app_localizations_context.dart';
import 'package:twitter_clone/src/routing/app_router.dart';
import 'package:twitter_clone/src/theme/palette.dart';

import '../../../core/core.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final AppBar appBar = UiConstants.appBar();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  // Keep track of whether the user has submitted the form
  bool submitted = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void submit() async {
    setState(() => submitted = true);
    // validate all the form fields
    if (formKey.currentState!.validate()) {
      final result = await ref
          .read(authControllerProvider.notifier)
          .signUpWithEmailAndPassword(
              emailController.text, passwordController.text);
      result.whenError(
        (error) => showSnackBar(
            context,
            error.code == 'unknown'
                ? error.message
                : getLocalizedErrorMessage(context, error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: appBar,
      body: state.isLoading
          ? const Loader()
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: formKey,
                    // Only validate the form when the user has submitted it
                    autovalidateMode: submitted
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    child: Column(
                      children: [
                        /// Email textfield
                        AuthField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          hintText: context.loc.emailHint,
                          validator: (value) => validateEmail(context, value),
                        ),
                        const SizedBox(height: 25),

                        /// Password textfield
                        AuthField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (p0) => submit(),
                          isPassword: true,
                          hintText: context.loc.passwordHint,
                          validator: (value) =>
                              validatePassword(context, value),
                        ),
                        const SizedBox(height: 40),
                        Align(
                          alignment: Alignment.centerRight,
                          child: RoundedSmallButton(
                            label: context.loc.signUp,
                            onPressed: () => submit(),
                            backGroundColor: Pallete.whiteColor,
                            textColor: Pallete.backgroundColor,
                          ),
                        ),
                        const SizedBox(height: 40),
                        RichText(
                          text: TextSpan(
                            text: context.loc.alreadyHaveAnAccount,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: ' ${context.loc.signIn}',
                                style: const TextStyle(
                                  color: Pallete.blueColor,
                                  fontSize: 16,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => context.pushReplacementNamed(
                                      AppRoute.login.name),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
