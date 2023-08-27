import 'package:flutter/material.dart';
import 'package:twitter_clone/src/l10n/app_localizations_context.dart';
import '../common_widgets/empty_placeholder.dart';

/// Simple not found screen used for 404 errors (page not found on web)
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: EmptyPlaceholderWidget(
        message: context.loc.pageNotFound,
      ),
    );
  }
}
