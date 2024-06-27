import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({required this.isLoading, this.loadingMessage});

  final bool isLoading;
  final String? loadingMessage;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isLoading,
      child: Visibility(
        visible: isLoading,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
            appBar: AppBar(iconTheme: IconThemeData(color: Colors.white)),
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
