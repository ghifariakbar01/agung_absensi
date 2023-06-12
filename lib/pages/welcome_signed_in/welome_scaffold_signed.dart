import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../style/style.dart';
import '../../../core/application/routes/route_names.dart';

import '../absen/widgets/user_info.dart';
import '../welcome/presentation/widget/app_logo.dart';
import '../welcome/presentation/widget/proceed_widget.dart';

class WelcomeScaffoldSigned extends ConsumerWidget {
  const WelcomeScaffoldSigned();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AppLogo(),
              const SizedBox(height: 24),
              const UserInfo(title: 'Selamat datang'),
              const SizedBox(height: 56),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ProceedWidget(
                      () => context.pushNamed(RouteNames.homeNameRoute),
                      'Lanjutkan sebagai agung'),
                ],
              ),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }
}
