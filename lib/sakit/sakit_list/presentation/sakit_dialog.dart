import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DialogHelper<T> {
  Future<String?> showFormDialog({
    required String label,
    required BuildContext context,
  }) async {
    TextEditingController? formController;

    formController = TextEditingController();

    final String? result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => VFormDialog(
        label: label,
        formController: formController!,
      ),
    );

    formController = null;
    if (result != null) {
      return result;
    }

    return null;
  }
}

class VFormDialog<T> extends ConsumerWidget {
  const VFormDialog({
    Key? key,
    this.isLoading = false,
    required this.label,
    required this.formController,
    this.onBackPressed,
    this.backPressedLabel,
    this.pressedLabel,
  }) : super(key: key);

  final bool isLoading;

  final String label;
  final String? backPressedLabel;
  final String? pressedLabel;

  final Function()? onBackPressed;
  final TextEditingController formController;
  //

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
        child: AlertDialog(
      elevation: 10,
      backgroundColor: Theme.of(context).primaryColor,
      alignment: Alignment.center,
      actionsAlignment: MainAxisAlignment.spaceAround,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        label,
        style: Themes.customColor(
          20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Palette.containerBackgroundColor.withOpacity(0.1)),
        padding: EdgeInsets.all(8),
        child: TextFormField(
          maxLines: 5,
          controller: formController,
        ),
      ),
      actionsOverflowButtonSpacing: 2,
      actions: [
        InkWell(
          onTap: () => context.pop(formController.text),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              pressedLabel ?? 'Ok',
              style: Themes.customColor(
                15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: onBackPressed ?? () => context.pop(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              backPressedLabel ?? 'Cancel',
              style: Themes.customColor(
                15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
