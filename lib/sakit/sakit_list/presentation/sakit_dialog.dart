import 'package:face_net_authentication/style/style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DialogHelper<T> {
  Future<String?> showFormDialog({
    String? label,
    required BuildContext context,
  }) async {
    TextEditingController? formController;

    formController = TextEditingController();

    final String? result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => VFormDialog(
        label: label ?? 'Note HRD',
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Dialog(
        // backgroundColor: Theme.of(context).primaryColor,
        // alignment: Alignment.center,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          height: 124,
          child: Stack(
            children: [
              Container(
                height: 124,
                decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(8),
                child: SizedBox(
                  height: 71,
                  child: TextFormField(
                    maxLines: 2,
                    controller: formController,
                    decoration: Themes.formStyle(label),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height: 25,
                  child: Row(
                    children: [
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: Ink(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Palette.red2,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10))),
                            child: InkWell(
                              onTap: onBackPressed ?? () => context.pop(),
                              child: Center(
                                child: Text(
                                  backPressedLabel ?? 'Cancel',
                                  style: Themes.customColor(
                                    12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: Ink(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Palette.green,
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10))),
                            child: InkWell(
                              onTap: () => context.pop(formController.text),
                              child: Center(
                                child: Text(
                                  pressedLabel ?? 'Ok',
                                  style: Themes.customColor(
                                    12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
