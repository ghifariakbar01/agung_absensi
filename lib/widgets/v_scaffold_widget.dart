import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../style/style.dart';
import 'network_widget.dart';

class VScaffoldWidget extends StatelessWidget {
  const VScaffoldWidget(
      {required this.scaffoldTitle,
      required this.scaffoldBody,
      this.scaffoldFAB,
      this.appbarColor});
  final Color? appbarColor;
  final String scaffoldTitle;
  final Widget scaffoldBody;
  final Widget? scaffoldFAB;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appbarColor ?? Palette.primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            scaffoldTitle,
            style: Themes.customColor(15,
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          toolbarHeight: 45,
          actions: [
            NetworkWidget(),
          ],
        ),
        resizeToAvoidBottomInset: false,
        floatingActionButton: scaffoldFAB,
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Palette.containerBackgroundColor.withOpacity(0.1)),
              padding: EdgeInsets.all(8),
              child: scaffoldBody,
            )));
  }
}

class VTab extends StatelessWidget {
  final Color color;
  final String text;
  final bool isCurrent;
  final double? height = 20;

  const VTab({
    Key? key,
    required this.color,
    required this.text,
    required this.isCurrent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: isCurrent ? color : Colors.transparent,
          border: isCurrent ? null : Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Text(
          text,
          style: Themes.customColor(10,
              color: isCurrent ? Colors.white : Colors.grey,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  // @override
  // Size get preferredSize {
  //   return Size.fromHeight(height!);
  // }
}

class VScaffoldTabLayout extends HookWidget {
  const VScaffoldTabLayout(
      {required this.scaffoldTitle,
      required this.scaffoldBody,
      required this.onPageChanged,
      this.onFilterSelected,
      this.onDropdownChanged,
      this.onFieldSubmitted,
      this.length,
      this.scaffoldFAB,
      this.appbarColor,
      this.additionalInfo,
      this.initialDateRange});
  final int? length;
  final Color? appbarColor;
  final String scaffoldTitle;
  final List<Widget> scaffoldBody;
  final Widget? scaffoldFAB;
  final Widget? additionalInfo;
  final DateTimeRange? initialDateRange;
  final Future<void> Function() onPageChanged;
  final Future<void> Function(String value)? onDropdownChanged;
  final Future<void> Function(String value)? onFieldSubmitted;
  final Future<void> Function(DateTimeRange value)? onFilterSelected;

  @override
  Widget build(
    BuildContext context,
  ) {
    final _isSearching = useState(false);
    final _searchFocus = useFocusNode();
    final _searchController = useTextEditingController();

    final controller = useTabController(
        initialLength: length == null
            ? _isSearching.value
                ? 1
                : 3
            : length!);

    final changingIndex = useState(0);

    useEffect(() {
      controller.addListener(() async {
        changingIndex.value = controller.index;
        await onPageChanged();
      });
      return () => controller.removeListener(() async {
            changingIndex.value = controller.index;
            await onPageChanged();
          });
    }, [controller]);

    List<Widget> tabs() => [
          VTab(
            isCurrent: changingIndex.value == 0,
            color: Palette.orange,
            text: '   Waiting   ',
          ),
          VTab(
            isCurrent: changingIndex.value == 1,
            color: Palette.green,
            text: '  Approved  ',
          ),
          VTab(
            isCurrent: changingIndex.value == 2,
            color: Palette.red2,
            text: ' Cancelled ',
          ),
        ];

    final _listPt = ['ACT', 'AJL', 'ARV'];
    final _currPt = useState('ACT');

    return DefaultTabController(
      length: length == null
          ? _isSearching.value
              ? 1
              : 3
          : length!,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: appbarColor ?? Palette.primaryColor,
            iconTheme: IconThemeData(color: Colors.white),
            bottom: TabBar(
              padding: EdgeInsets.only(bottom: 5),
              controller: controller,
              onTap: (value) {
                controller.animateTo(value);
              },
              indicatorColor: Colors.transparent,
              overlayColor: MaterialStatePropertyAll(Colors.transparent),
              tabs: [
                if (_isSearching.value) ...[
                  tabs()[changingIndex.value]
                ] else ...[
                  for (int i = 0; i < (length == null ? 3 : length!); i++) ...[
                    tabs()[i]
                  ]
                ]
              ],
            ),
            leadingWidth: 20,
            leading: _isSearching.value ? Container() : null,
            title: _isSearching.value
                ? Container()
                : Text(
                    scaffoldTitle,
                    style: Themes.customColor(15,
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
            toolbarHeight: 45,
            actions: [
              if (_isSearching.value) ...[
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                    height: 45,
                    width: MediaQuery.of(context).size.width - 12,
                    child: TextFormField(
                      focusNode: _searchFocus,
                      controller: _searchController,
                      decoration: Themes.formStyle('Search Here',
                          textColor: Colors.white),
                      style: Themes.customColor(14, color: Colors.white),
                      onTapOutside: (_) {
                        _isSearching.value = false;
                        _searchFocus.unfocus();
                      },
                      onFieldSubmitted: (value) {
                        if (onFieldSubmitted != null) {
                          onFieldSubmitted!(value);
                        }
                      },
                    ),
                  ),
                )
              ],
              if (_isSearching.value == false) ...[
                /*
                  Dropdown bar
                */
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 100,
                    height: 50,
                    child: DropdownButtonFormField<String>(
                      elevation: 0,
                      iconSize: 20,
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.keyboard_arrow_down_rounded,
                          color: Palette.primaryTextColor),
                      validator: (value) {
                        if (value == null) {
                          return 'Form tidak boleh kosong';
                        }

                        return null;
                      },
                      decoration: Themes.dropdown(),
                      style: Themes.customColor(12, color: Colors.white),
                      value: _listPt.firstWhere(
                        (element) => element == _currPt.value,
                        orElse: () => _listPt.first,
                      ),
                      onChanged: (String? value) {
                        if (value != null) {
                          _currPt.value = value;
                          if (onDropdownChanged != null) {
                            onDropdownChanged!(value);
                          }
                        }
                      },
                      isExpanded: true,
                      items:
                          _listPt.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                            child: Text(
                              value,
                              style:
                                  Themes.customColor(14, color: Palette.orange),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                /*
                  Filter Icon
                */
                IconButton(
                    onPressed: () async {
                      final _oneYear = Duration(days: 365);
                      final _oneMonth = Duration(days: 30);

                      final picked = await showDateRangePicker(
                          context: context,
                          initialDateRange: initialDateRange ??
                              DateTimeRange(
                                  start: DateTime.now().subtract(_oneMonth),
                                  end: DateTime.now().add(_oneMonth)),
                          firstDate: DateTime.now().subtract(_oneYear),
                          lastDate: DateTime.now().add(_oneYear));

                      if (picked != null) {
                        print(picked);

                        if (onFilterSelected != null) {
                          onFilterSelected!(picked);
                        }
                      }
                    },
                    icon: Icon(Icons.sort)),

                /*
                  Search bar
                */
                IconButton(
                    onPressed: () {
                      _isSearching.value
                          ? _isSearching.value = false
                          : _isSearching.value = true;

                      _searchFocus.requestFocus();
                    },
                    icon: Icon(Icons.search)),
                additionalInfo != null ? additionalInfo! : Container(),
                NetworkWidget(),
              ]
            ],
          ),
          resizeToAvoidBottomInset: false,
          floatingActionButton: scaffoldFAB,
          body:
              TabBarView(controller: controller, children: [...scaffoldBody])),
    );
  }
}
