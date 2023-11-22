import 'package:flutter/material.dart';

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget(
    this.errorMessage,
  );
  final String errorMessage;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        errorMessage,
        style:
            Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.red),
      ),
    );
  }
}
