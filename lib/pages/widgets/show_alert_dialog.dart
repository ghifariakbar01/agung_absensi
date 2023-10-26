part of alert_dialogs;

Future<bool?> showAlertDialog({
  String? content,
  required String title,
  required BuildContext context,
  //
}) async {
  return showDialog(
    context: context,
    builder: (context) => VSimpleDialog(
      label: title,
      color: Palette.red,
      asset: Assets.iconCrossed,
      labelDescription: content != null ? content : '',
    ),
  );
}
