part of alert_dialogs;

Future<void> showExceptionAlertDialog({
  required String title,
  required dynamic exception,
  required BuildContext context,
}) =>
    showAlertDialog(
      title: title,
      context: context,
      content: _message(exception),
    );

String _message(dynamic exception) {
  return exception.toString();
}
