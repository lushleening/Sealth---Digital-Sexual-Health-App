// Used when a page requires async loading
// Will make the page blank and show an error on async get error

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/common_widgets/safe_container.dart';
import 'package:sddp_dsh/helper/colors.dart';
import 'package:sddp_dsh/helper/constants.dart';
import 'package:sddp_dsh/logging/app_loggers.dart';

class AsyncPage<T> extends StatelessWidget {
  final AsyncValue<T> state;
  final Widget Function(T data) pageContent;
  final String Function(Object e, StackTrace st) logTextOnError;
  final Widget onLoading;
  final Widget whenError;

  const AsyncPage({
    super.key,
    required this.state,
    required this.pageContent,
    required this.logTextOnError,
    this.onLoading = const LoadingCircleMainColor(),
    this.whenError = const BlankPageWithError(),
  });

  @override
  Widget build(BuildContext context) {
    return state.when(
      data: (data) => pageContent(data),
      error: (e, st) {
        uiLogger.severe(logTextOnError(e, st));
        return const BlankPageWithError();
      },
      loading: () => const LoadingCircleMainColor(),
    );
  }
}

class BlankPageWithError extends StatelessWidget {
  const BlankPageWithError({super.key});

  @override
  Widget build(BuildContext context) => SafeContainer(
    child: Center(
      child: Text(
        unexpectedInformDev,
        style: TextStyle(color: context.colors.textPrimary),
      ),
    ),
  );
}

class LoadingCircleMainColor extends StatelessWidget {
  const LoadingCircleMainColor({super.key});

  @override
  Widget build(BuildContext context) =>
      Center(child: CircularProgressIndicator(color: context.colors.mainColor));
}
