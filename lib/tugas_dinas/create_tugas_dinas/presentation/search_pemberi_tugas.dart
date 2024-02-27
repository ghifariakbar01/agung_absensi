import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../style/style.dart';
import '../../../widgets/v_async_widget.dart';
import '../../../widgets/v_scaffold_widget.dart';
import '../application/create_tugas_dinas_notifier.dart';
import '../application/user_list.dart';

final isSearchingProvider = StateProvider<bool>((ref) {
  return false;
});

final searchPageProvider = StateProvider<int>((ref) {
  return 1;
});

final lastSearchedProvider = StateProvider<String>((ref) {
  return '';
});

final _whitespaceRE = RegExp(r'\s+');

class SearchPemberiTugas extends HookConsumerWidget {
  const SearchPemberiTugas();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final searchFocus = useFocusNode();
    // final isSearching = useState(false);

    final timerTick = useState(1);
    final justSearched = useState(false);
    final searchController = useTextEditingController(text: '');

    useEffect(
      () {
        final timer = Timer.periodic(
            const Duration(milliseconds: 750),
            (_) => _onTimerIsUp(
                  ref,
                  timerTick,
                  justSearched,
                  searchController,
                ));

        return timer.cancel;
      },
      [justSearched.value],
    );

    final pemberiTugas = ref.watch(pemberiTugasDinasNotifierProvider);

    return VScaffoldWidget(
      scaffoldTitle: 'Search Pemberi Tugas',
      scaffoldBody: KeyboardDismissOnTap(
        child: ListView(
          children: [
            TextFormField(
              controller: searchController,
              onChanged: (value) {
                log('value $value');
                if (value.isNotEmpty) {
                  timerTick.value = 2;

                  justSearched.value = true;
                } else {
                  justSearched.value = false;
                }
              },
              decoration: Themes.formStyle(
                'Search Pemberi Tugas',
              ),
            ),
            SizedBox(
              height: 16,
            ),
            VAsyncValueWidget<List<UserList>>(
              value: pemberiTugas,
              data: (list) => Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white.withOpacity(0.1)),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (context, index) => SizedBox(
                      height: 16,
                    ),
                    itemBuilder: (context, index) {
                      if (list.isEmpty) return Container();

                      final nama = list[index].fullname!;

                      if (nama.isEmpty) return Container();

                      return Ink(
                          decoration: BoxDecoration(
                            color: Palette.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                              onTap: () {
                                context.pop(list[index]);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  nama,
                                  style: Themes.customColor(9,
                                      color: Colors.white),
                                ),
                              )));
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _onTimerIsUp(
  WidgetRef ref,
  ValueNotifier<int> timerTick,
  ValueNotifier<bool> justSearched,
  TextEditingController searchController,
) async {
  {
    timerTick.value--;
    if (timerTick.value == 0) {
      final String searchTrimmed = searchController.value.text
          .trimLeft()
          .trimRight()
          .replaceAll(_whitespaceRE, ' ');

      if (justSearched.value && searchController.value.text.isNotEmpty) {
        ref
            .read(pemberiTugasDinasNotifierProvider.notifier)
            .getPemohonListNamed(searchTrimmed);
        ref.read(lastSearchedProvider.notifier).state = searchTrimmed;

        justSearched.value = false;
      }

      timerTick.value = 2;
    }
  }
}
