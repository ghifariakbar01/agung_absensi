import 'dart:convert';
import 'dart:developer';

import 'package:face_net_authentication/send_wa/application/send_wa_notifier.dart';
import 'package:face_net_authentication/widgets/v_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/providers.dart';

import '../../constants/assets.dart';
import '../../infrastructure/cache_storage/wa_regist_storage.dart';
import '../../infrastructure/credentials_storage/credentials_storage.dart';
import '../../send_wa/application/phone_num.dart';
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
class CurrentlySavedPhoneNumberNotifier
    extends _$CurrentlySavedPhoneNumberNotifier {
  @override
  FutureOr<PhoneNum> build() async {
    final idUser = ref.read(userNotifierProvider).user.idUser!;
    return ref
        .read(sendWaNotifierProvider.notifier)
        .getPhoneById(idUser: idUser);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final idUser = ref.read(userNotifierProvider).user.idUser!;
      return ref
          .read(sendWaNotifierProvider.notifier)
          .getPhoneById(idUser: idUser);
    });
  }
}

@riverpod
class WaRegisterNotifier extends _$WaRegisterNotifier {
  @override
  FutureOr<WaRegister> build() async {
    final response =
        await ref.read(waRegisterRepositoryProvider).getWaRegister();

    if (response == null) {
      // debugger();
      return WaRegister.initial();
    }

    final fromJsonResponse = jsonDecode(response);

    return WaRegister.fromJson(fromJsonResponse);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard<WaRegister>(() async {
      final response =
          await ref.read(waRegisterRepositoryProvider).getWaRegister();

      if (response == null) {
        return WaRegister.initial();
      }

      final fromJsonResponse = jsonDecode(response);

      return WaRegister.fromJson(fromJsonResponse);
    });
  }

  Future<WaRegister> getCurrentRegisteredWa() async {
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

  Future<void> retryRegisterWa({
    required BuildContext context,
  }) async {
    // await ref.read(waRegisterRepositoryProvider).clear();
    return confirmRegisterWa(context: context);
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

    return KeyboardDismissOnTap(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          color: Colors.transparent,
          height: MediaQuery.of(context).size.height / 3,
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              children: [
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text:
                            'Isi dengan nomor HP yang ingin digunakan untuk menerima notifikasi pesan via ',
                        style: Themes.customColor(9, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'WhatsApp',
                              style:
                                  Themes.customColor(9, color: Colors.green)),
                        ],
                      ),
                    )),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.all(16.0),
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
      ),
    );
  }
}

class WaRegisterDialog extends HookConsumerWidget {
  const WaRegisterDialog();

  //
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Container(
        color: theme.canvasColor,
        // padding: EdgeInsets.all(4),
        child: Column(
          children: [
            Container(
              height: 48,
              width: MediaQuery.of(context).size.width,
              color: Palette.primaryColor,
              child: Center(
                child: Text(
                  'Register Notifikasi WhatsApp',
                  style: Themes.customColor(18,
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Apakah sudah pernah meregistrasi nomor anda ke ',
                    style: Themes.customColor(9, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: '+852 5420 1273',
                          style: Themes.customColor(9,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: '  ? (Contoh gambar di bawah)',
                          style: Themes.customColor(
                            9,
                            color: Colors.black,
                          )),
                    ],
                  ),
                )),
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
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Jika belum, pilih ',
                    style: Themes.customColor(9, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Tombol Belum',
                          style: Themes.customColor(9,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                              ' dan kirim pesan “hi” yang sudah diketik ke nomor tersebut.',
                          style: Themes.customColor(
                            9,
                            color: Colors.black,
                          )),
                    ],
                  ),
                )),
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
                          builder: (context) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Dialog(
                                  // backgroundColor: Theme.of(context).primaryColor,
                                  // alignment: Alignment.center,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    height: 234,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            height: 36,
                                            width: 36,
                                            child: SvgPicture.asset(
                                                Assets.iconWa)),
                                        SizedBox(
                                          height: 13,
                                        ),
                                        RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            text: 'Membuka ',
                                            style: Themes.customColor(11,
                                                color: Palette.primaryColor),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: 'WhatsApp...',
                                                  style: Themes.customColor(
                                                    11,
                                                    color: Colors.green,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                            'Beberapa saat lagi anda akan diarahkan ke aplikasi WhatsApp',
                                            textAlign: TextAlign.center,
                                            style: Themes.customColor(11,
                                                color: Palette.primaryColor)),
                                      ],
                                    ),
                                  ),
                                  // after show dialog
                                ),
                              ))
                      .then((_) => context.pop(true))
                      // after show dialog dismissed

                      .then((_) => context.pop(true))),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              " Jika sudah, anda tidak perlu melakukan tahap selanjutnya. "
              " Anda sudah bisa menerima pesan Wa. Terimakasih!",
              textAlign: TextAlign.center,
              style: Themes.customColor(
                9,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            VButton(label: 'Sudah', onPressed: () => context.pop(true))
          ],
        ),
      ),
    );
  }
}
