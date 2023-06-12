part of style;

mixin Themes {
  static void initUiOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Palette.primaryColor,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData.light().copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: const ColorScheme.light(
        primary: Palette.primaryColor,
        secondary: Palette.secondaryColor,
        onSecondary: Palette.secondaryTextColor,
      ),
      textTheme: GoogleFonts.latoTextTheme(
        Theme.of(context).textTheme,
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData.dark().copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: const ColorScheme.dark(
        primary: Palette.primaryColor,
        secondary: Palette.secondaryColor,
        onPrimary: Palette.primaryTextColor,
        onSecondary: Palette.secondaryTextColor,
      ),
      textTheme: GoogleFonts.latoTextTheme(
        Theme.of(context).textTheme,
      ),
    );
  }

  static TextStyle blue(FontWeight? fontWeight, double fontSize) {
    return GoogleFonts.poppins(
        color: Palette.secondaryColor,
        fontWeight: fontWeight,
        fontSize: fontSize);
  }

  static TextStyle black(FontWeight? fontWeight, double fontSize) {
    return GoogleFonts.poppins(
        color: Colors.black,
        fontWeight: fontWeight ?? FontWeight.normal,
        fontSize: fontSize);
  }

  static TextStyle blueSpaced(FontWeight fontWeight, double fontSize) {
    return GoogleFonts.poppins(
        color: Palette.secondaryColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
        letterSpacing: 4);
  }

  static TextStyle grey(FontWeight fontWeight, double fontSize) {
    return GoogleFonts.poppins(
        color: Palette.grey,
        fontWeight: fontWeight,
        fontSize: fontSize,
        letterSpacing: 4);
  }

  static TextStyle greyHint(FontWeight fontWeight, double fontSize) {
    return GoogleFonts.poppins(
      color: Palette.greyTwo,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  static TextStyle customColor(
      FontWeight? fontWeight, double fontSize, Color color) {
    return GoogleFonts.poppins(
        color: color,
        fontWeight: fontWeight ?? FontWeight.normal,
        fontSize: fontSize);
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

  static InputDecoration formStyle(String hintText) {
    return InputDecoration(
      enabledBorder: Themes.notFocused(),
      focusedBorder: Themes.focused(),
      contentPadding: const EdgeInsets.all(16),
      border: InputBorder.none,
      hintStyle: Themes.greyHint(FontWeight.normal, 16),
      hintText: hintText,
    );
  }

  static TextStyle blackItalic() {
    return GoogleFonts.poppins(
      color: Colors.black,
      fontSize: 12,
      fontStyle: FontStyle.italic,
      decoration: TextDecoration.underline,
    );
  }
}
