import 'package:face_net_authentication/widgets/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../err_log/application/err_log_notifier.dart';
import '../../widgets/v_async_widget.dart';
import 'home_scaffold.dart';

class HomeSaved extends ConsumerStatefulWidget {
  const HomeSaved();

  @override
  ConsumerState<HomeSaved> createState() => _HomeSavedState();
}

class _HomeSavedState extends ConsumerState<HomeSaved> {
  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(errLogControllerProvider, (_, state) async {
      return state.showAlertDialogOnError(context, ref);
    });

    final errLog = ref.watch(errLogControllerProvider);

    return VAsyncWidgetScaffold<void>(
      value: errLog,
      data: (_) => HomeScaffold(),
    );
  }
}
