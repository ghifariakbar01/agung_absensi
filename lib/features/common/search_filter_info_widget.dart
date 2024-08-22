import 'package:flutter/material.dart';

import '../../style/style.dart';

class SearchFilterInfoWidget extends StatelessWidget {
  const SearchFilterInfoWidget({
    Key? key,
    required this.d1,
    required this.d2,
    required this.lastSearch,
    required this.isBottom,
    required this.isScrolling,
    required this.isSearchVisible,
    this.onTapName,
    this.onTapDate,
  }) : super(key: key);

  final String d1;
  final String d2;
  final bool isBottom;
  final bool isScrolling;
  final String lastSearch;
  final bool? isSearchVisible;
  final Function()? onTapName;
  final Function()? onTapDate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isBottom
          ? Container()
          : Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isScrolling
                    ? Palette.primaryColor.withOpacity(0.25)
                    : Palette.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isSearchVisible == null
                      ? Container()
                      : Ink(
                          child: InkWell(
                            onTap: onTapName,
                            child: Text(
                              ' 🧑 : $lastSearch',
                              style: Themes.customColor(
                                14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                  Ink(
                    child: InkWell(
                      onTap: onTapDate,
                      child: Text(
                        ' 🗓️ : $d1 - $d2',
                        style: Themes.customColor(
                          14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
    );
  }
}
