import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sddp_dsh/backend/constants/text_hints.dart';
import 'package:sddp_dsh/backend/constants/ui_design.dart';
import 'package:sddp_dsh/frontend/common_widgets/email_support_btn.dart';
import 'package:sddp_dsh/frontend/common_widgets/safe_container.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/logging/app_loggers.dart';

// Used when a page requires async loading
// Shows loading / error widgets on data loading / error
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
        return BlankPageWithError();
      },
      loading: () => const LoadingCircleMainColor(),
    );
  }
}

// Helpers for AsyncPage, can also be used individually
class BlankPageWithError extends StatelessWidget {
  const BlankPageWithError({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeContainer(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: baseLength / 2,
            children: [
              Text(
                unexpectedInformDev,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const EmailSupportBtn(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingCircleMainColor extends StatelessWidget {
  const LoadingCircleMainColor({super.key});
  @override
  Widget build(BuildContext context) => SafeContainer(
    child: Center(
      child: CircularProgressIndicator(color: context.colors.mainColor),
    ),
  );
}
