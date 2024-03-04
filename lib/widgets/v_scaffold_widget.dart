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
            style: Themes.customColor(20,
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

class VTab extends StatelessWidget implements PreferredSizeWidget {
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
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: isCurrent ? color : Colors.transparent,
          border: isCurrent ? null : Border.all(width: 1, color: Colors.grey),
          borderRadius: BorderRadius.circular(8)),
      child: Text(
        text,
        style: Themes.customColor(10, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(height!);
  }
}

class VScaffoldTabLayout extends HookWidget {
  const VScaffoldTabLayout(
      {required this.scaffoldTitle,
      required this.scaffoldBody,
      required this.onPageChanged,
      this.scaffoldFAB,
      this.appbarColor,
      this.additionalInfo});
  final Color? appbarColor;
  final String scaffoldTitle;
  final List<Widget> scaffoldBody;
  final Widget? scaffoldFAB;
  final Widget? additionalInfo;
  final Future<void> Function() onPageChanged;

  @override
  Widget build(
    BuildContext context,
  ) {
    final controller = useTabController(initialLength: 3);
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

    return DefaultTabController(
      length: 3,
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
              ],
            ),
            title: Text(
              scaffoldTitle,
              style: Themes.customColor(20,
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
            toolbarHeight: 45,
            actions: [
              additionalInfo != null ? additionalInfo! : Container(),
              NetworkWidget(),
            ],
          ),
          resizeToAvoidBottomInset: false,
          floatingActionButton: scaffoldFAB,
          body:
              TabBarView(controller: controller, children: [...scaffoldBody])),
    );
  }
}
