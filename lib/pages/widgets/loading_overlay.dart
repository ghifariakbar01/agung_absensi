import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({required this.isLoading, this.loadingMessage});

  final bool isLoading;
  final String? loadingMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQueryData = MediaQuery.of(context);

    return IgnorePointer(
      ignoring: !isLoading,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: isLoading ? Colors.black.withOpacity(0.8) : Colors.transparent,
        width: mediaQueryData.size.width,
        height: mediaQueryData.size.height,
        child: Visibility(
          visible: isLoading,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircularProgressIndicator(
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                loadingMessage ?? 'Please Wait',
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
