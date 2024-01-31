import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../shared/providers.dart';
import '../../style/style.dart';

class ErrorMessageWidget extends ConsumerWidget {
  const ErrorMessageWidget(
    this.errorMessage,
  );
  final String errorMessage;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true),
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.error,
                size: 50,
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Center(
              child: Text(
            'Oops. Something Went Wrong.',
            style: Themes.customColor(
              18,
              fontWeight: FontWeight.bold,
            ),
          )),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Palette.grey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Theme(
                data: ThemeData(
                  dividerColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  iconColor: Colors.black,
                  collapsedIconColor: Colors.black,
                  title: Text(
                    'Display Error',
                    style: Themes.customColor(
                      14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Error & Stack Trace',
                    style: Themes.customColor(
                      14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'idKary: ${ref.read(userNotifierProvider).user.IdKary}\n '
                        'Error: $errorMessage \n',
                        style: Themes.customColor(
                          12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
