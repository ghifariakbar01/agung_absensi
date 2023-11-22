part of style;

mixin Themes {
  static void initUiOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
    ));
  }

  static TextStyle customColor(FontWeight? fontWeight, double fontSize,
      {Color? color}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.normal,
    );
  }

  static OutlineInputBorder notFocused() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Palette.greyStroke));
  }

  static OutlineInputBorder focused() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Palette.primaryColor));
  }

  static InputDecoration formStyle(String hintText, {Widget? icon}) {
    return InputDecoration(
      hintText: hintText,
      suffixIcon: icon ?? null,
      border: InputBorder.none,
      focusedBorder: Themes.focused(),
      enabledBorder: Themes.notFocused(),
      contentPadding: const EdgeInsets.all(16),
      hintStyle: Themes.customColor(FontWeight.normal, 14),
      labelStyle: Themes.customColor(FontWeight.normal, 14),
    );
  }

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData.light().copyWith(
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white),
      scaffoldBackgroundColor: Colors.white,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: Colors.white,
      primaryColorLight: Colors.white,
      primaryColorDark: Palette.primaryColor,
      disabledColor: Colors.black.withOpacity(0.15),
      // Color Icon Lokasi Jarak Terdekat
      secondaryHeaderColor: Colors.black,
      // Color Riwayat Absen Text
      unselectedWidgetColor: Palette.secondaryColor,
      // Color Riwayat Absen Container
      cardColor: Palette.secondaryColor,
      colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        secondary: Colors.black,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData.dark().copyWith(
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(
          actionsIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: Colors.black,
      primaryColor: Colors.black,
      primaryColorLight: Colors.white,
      // Color Icon Lokasi Jarak Terdekat
      secondaryHeaderColor: Colors.white,
      // Color Riwayat Absen Text
      unselectedWidgetColor: Colors.white,
      // Color Riwayat Absen Container
      cardColor: Colors.white.withOpacity(0.05),
      primaryColorDark: Colors.white.withOpacity(0.05),
      disabledColor: Colors.white.withOpacity(0.15),
      colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        secondary: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
    );
  }
}
