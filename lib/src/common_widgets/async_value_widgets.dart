import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/src/common_widgets/common_widgets.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.data,
    required this.value,
  });
  final AsyncValue<T> value;
  final Widget Function(T data) data;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (error, _) => Center(child: Text(error.toString())),
      loading: () => const Center(child: Loader()),
    );
  }
}

class AsyncValueScreen<T> extends StatelessWidget {
  const AsyncValueScreen({super.key, required this.value, required this.data});

  final AsyncValue<T> value;
  final Widget Function(T data) data;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (error, _) => Scaffold(
        body: Center(child: Text(error.toString())),
      ),
      loading: () => const LoadingPage(),
    );
  }
}
