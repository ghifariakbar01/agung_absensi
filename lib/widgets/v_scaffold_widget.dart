import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../helper.dart';
import '../style/style.dart';
import '../utils/dialog_helper.dart';

class VScaffoldWidget extends StatelessWidget {
  const VScaffoldWidget(
      {required this.scaffoldTitle,
      required this.scaffoldBody,
      this.scaffoldFAB,
      this.appbarColor,
      this.isLoading});
  final bool? isLoading;
  final Color? appbarColor;
  final String scaffoldTitle;
  final Widget scaffoldBody;
  final Widget? scaffoldFAB;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading:
              isLoading == null ? true : isLoading == false,
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
            // NetworkWidget(),
            // SizedBox(
            //   width: 24,
            // )
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

class VScaffoldTabLayout extends HookWidget with DialogHelper, CalendarHelper {
  const VScaffoldTabLayout({
    required this.scaffoldTitle,
    required this.scaffoldBody,
    required this.onPageChanged,
    required this.onFilterSelected,
    required this.onDropdownChanged,
    required this.onFieldSubmitted,
    required this.scaffoldFAB,
    required this.currPT,
    required this.initialDateRange,
    required this.isSearchVisible,
    this.bottomLeftWidget,
    this.isSearching,
    this.searchFocus,
    this.additionalInfo,
    this.appbarColor,
    this.length,
    this.mapPT,
  });

  final int? length;

  final Color? appbarColor;
  final String scaffoldTitle;
  final List<String> currPT;
  final Map<String, List<String>>? mapPT;
  final List<Widget> scaffoldBody;
  final Widget scaffoldFAB;
  final Widget? additionalInfo;
  final Widget? bottomLeftWidget;
  //
  final bool isSearchVisible;
  final ValueNotifier<bool>? isSearching;
  final FocusNode? searchFocus;
  final DateTimeRange initialDateRange;
  final Future<void> Function() onPageChanged;
  final Future<void> Function(String value) onFieldSubmitted;
  final Future<void> Function(List<String> value) onDropdownChanged;
  final Future<void> Function(DateTimeRange value) onFilterSelected;

  @override
  Widget build(BuildContext context) {
    final _isSearching = isSearching ?? useState(false);
    final _searchFocus = searchFocus ?? useFocusNode();

    final _searchController = useTextEditingController();

    final controller = useTabController(
        initialLength: length == null
            ? _isSearching.value
                ? 1
                : 3
            : _isSearching.value
                ? 1
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

    final _mapPTValues = mapPT == null
        ? {
            'gs_12': ['ACT', 'Transina', 'ALR'],
            'gs_14': ['Tama Raya'],
            'gs_18': ['ARV'],
            'gs_21': ['AJL'],
          }.values
        : mapPT!.values;

    final _currPt = useState(currPT);

    return DefaultTabController(
      length: length == null
          ? _isSearching.value
              ? 1
              : 3
          : _isSearching.value
              ? 1
              : length!,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: appbarColor ?? Palette.primaryColor,
            iconTheme: IconThemeData(color: Colors.white),
            bottom: _isSearching.value
                ? PreferredSize(
                    preferredSize: Size(double.infinity, 16), child: SizedBox())
                : TabBar(
                    padding: EdgeInsets.only(bottom: 5),
                    controller: controller,
                    onTap: (value) {
                      controller.animateTo(value);
                    },
                    dividerColor: Colors.transparent,
                    indicatorColor: Colors.transparent,
                    overlayColor: WidgetStatePropertyAll(Colors.transparent),
                    tabs: [
                      for (int i = 0;
                          i < (length == null ? 3 : length!);
                          i++) ...[tabs()[i]]
                    ],
                  ),
            leadingWidth: 65,
            leading: _isSearching.value ? Container() : null,
            title: _isSearching.value
                ? Container()
                : Text(
                    scaffoldTitle,
                    style: Themes.customColor(
                      15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
            titleSpacing: 0,
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
                      onTap: () {
                        _isSearching.value = true;
                        _searchFocus.requestFocus();
                      },
                      onFieldSubmitted: (value) {
                        onFieldSubmitted(value);
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
                    child: DropdownButtonFormField<List<String>>(
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
                      value: _mapPTValues.toList().firstWhere(
                            (element) => _equal(element, _currPt.value),
                            orElse: () => _mapPTValues.toList().first,
                          ),
                      onChanged: (List<String>? value) {
                        if (value != null) {
                          if (value == _currPt.value) {
                            return;
                          }

                          _currPt.value = value;
                          onDropdownChanged(value);
                        }
                      },
                      isExpanded: true,
                      items: _mapPTValues.map<DropdownMenuItem<List<String>>>(
                          (List<String> value) {
                        return DropdownMenuItem<List<String>>(
                          value: value,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 3),
                            child: Text(
                              "${value.map((e) => e
                                ..replaceAll('[', '(')
                                ..replaceAll(']', ')'))..toList()}",
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
                    onPressed: () => CalendarHelper.callCalendar(
                          context,
                          onFilterSelected,
                        ),
                    icon: Icon(Icons.sort)),

                /*
                  Search bar
                */
                if (isSearchVisible)
                  IconButton(
                      onPressed: () {
                        _isSearching.value
                            ? _isSearching.value = false
                            : _isSearching.value = true;

                        _searchFocus.requestFocus();
                      },
                      color: _searchController.text.isNotEmpty
                          ? Palette.orange
                          : null,
                      icon: Icon(Icons.search)),
                additionalInfo != null ? additionalInfo! : Container(),
                SizedBox(
                  width: 16,
                ),
              ]
            ],
          ),
          resizeToAvoidBottomInset: false,
          floatingActionButton: scaffoldFAB,
          body: Stack(
            children: [
              TabBarView(
                controller: controller,
                children: [...scaffoldBody],
              ),
              Positioned(
                bottom: 20,
                left: 10,
                child: bottomLeftWidget ?? Container(),
              )
            ],
          )),
    );
  }

  _equal(List<String> serv, List<String> serv2) {
    return serv.first == serv2.first;
  }
}
