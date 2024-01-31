import 'dart:convert';
import 'dart:developer';

import 'package:face_net_authentication/pages/widgets/v_button.dart';
import 'package:face_net_authentication/pages/widgets/v_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/providers.dart';

import '../../constants/assets.dart';
import '../../infrastructure/cache_storage/wa_regist_storage.dart';
import '../../infrastructure/credentials_storage/credentials_storage.dart';
import '../../style/style.dart';
import '../infrastructure/wa_register_repository.dart';
import 'wa_register.dart';

part 'wa_register_notifier.g.dart';

final waStorageProvider = Provider<CredentialsStorage>(
  (ref) => WaStorage(ref.watch(flutterSecureStorageProvider)),
);

@Riverpod(keepAlive: true)
WaRegisterRepository waRegisterRepository(WaRegisterRepositoryRef ref) {
  return WaRegisterRepository(
    ref.watch(waStorageProvider),
  );
}

@riverpod
class WaRegisterNotifier extends _$WaRegisterNotifier {
  @override
  FutureOr<WaRegister> build() async {
    final response =
        await ref.read(waRegisterRepositoryProvider).getWaRegister();

    if (response == null) {
      debugger();
      return WaRegister.initial();
    }

    final fromJsonResponse = jsonDecode(response);

    return WaRegister.fromJson(fromJsonResponse);
  }

  Future<void> confirmRegisterWa({
    required BuildContext context,
  }) async {
    try {
      final String? phone = ref.read(userNotifierProvider).user.noTelp1;

      final String? newPhone =
          await showWaBottomSheet(phone: phone ?? "", context: context);

      if (newPhone != null) {
        await _registerWaForNotif(phone, newPhone, context);
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> _registerWaForNotif(
    String? phone,
    String newPhone,
    BuildContext context,
  ) async {
    state = const AsyncLoading();

    try {
      final bool? isRegistered =
          await showWaDialog(phone: phone ?? "", context: context);

      debugger();

      if (isRegistered != null) {
        final WaRegister waRegister =
            WaRegister(phone: newPhone, isRegistered: isRegistered);

        final waRegisterJsonEncode = jsonEncode(waRegister);

        state = await AsyncValue.guard(() async {
          await ref
              .read(waRegisterRepositoryProvider)
              .save(waRegisterJsonEncode);

          debugger();
          return waRegister;
        });

        //
      } else {
        state = AsyncError(
            AssertionError('Failed Registration'), StackTrace.current);
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

Future<String?> showWaBottomSheet({
  required String phone,
  required BuildContext context,
}) async {
  TextEditingController? formController;

  formController = TextEditingController(text: phone);

  final String? result = await showModalBottomSheet(
    context: context,
    isDismissible: false,
    builder: (_) => WaPhoneBottomSheet(
      formController: formController!,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
    ),
  );

  formController = null;
  if (result != null) {
    return result;
  }

  return null;
}

Future<bool?> showWaDialog({
  required String phone,
  required BuildContext context,
}) async {
  final bool? result = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => WaRegisterDialog(),
  );

  if (result != null) {
    return result;
  }

  return null;
}

class WaPhoneBottomSheet extends HookConsumerWidget {
  WaPhoneBottomSheet({required this.formController});

  final TextEditingController formController;

  //
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = useMemoized(GlobalKey<FormState>.new, const []);

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height / 3,
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Gunakan nomor hp ini untuk menerima pesan Whatsapp ',
                  style: Themes.customColor(12),
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: formController,
                  decoration: Themes.formStyleBordered('Nomor hp'),
                  validator: (value) {
                    if (value == null) {
                      return 'Tidak boleh kosong';
                    }

                    if (!value.startsWith('62')) {
                      return ' Nomor harus diawal 62 (Contoh 62896xxxxxxxx)';
                    }

                    return null;
                  },
                ),
              ),
              Expanded(child: Container()),
              VButton(
                  label: 'Konfirmasi',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      context.pop(formController.text);
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class WaRegisterDialog extends HookConsumerWidget {
  const WaRegisterDialog();

  //
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.all(4),
      child: Column(
        children: [
          Text(
            'Apakah sudah pernah meregistrasi nomor anda ke +852 5420 1273 ? (Contoh gambar di bawah)',
            style: Themes.customColor(12, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 4,
          ),
          SizedBox(
            height: 200,
            width: 200,
            child: Image.asset(Assets.imgRegisterWa),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            " Jika belum, pilih Belum dan kirim pesan 'hi' yang sudah diketik ke nomor tersebut. ",
            style: Themes.customColor(12),
          ),
          SizedBox(
            height: 4,
          ),
          VButton(
              label: 'Belum',
              onPressed: () => launchUrl(
                      Uri.parse("https://wa.me/+85254201273?text=hi"),
                      mode: LaunchMode.externalApplication)
                  // show dialog
                  .then((_) => showDialog(
                            context: context,
                            builder: (context) => VSimpleDialog(
                              asset: Assets.iconChecked,
                              label: 'Menunggu...',
                              labelDescription:
                                  'Jika anda sudah mengirim pesan, anda sudah bisa menerima pesan wa. Selamat!',
                            ),
                            // after show dialog
                          ).then((_) => context.pop(true))
                      // after show dialog dismissed
                      )
                  .then((_) => context.pop(true))),
          SizedBox(
            height: 12,
          ),
          Text(
            " Jika sudah, anda tidak perlu melakukan tahap selanjutnya. "
            " Anda sudah bisa menerima pesan Wa. Terimakasih!",
            style: Themes.customColor(12),
          ),
          VButton(label: 'Sudah', onPressed: () => context.pop(true))
        ],
      ),
    );
  }
}
