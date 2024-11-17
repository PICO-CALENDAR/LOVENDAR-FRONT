import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF9F7965);
  static const Color primaryColorLight = Color(0xFFD2B8A5);
  static const Color primaryColorDark = Color(0xFF6E5444);
  static const Color accentColor = Color(0xFFA3AB7D);
  static const Color backgroundColor = Color(0xFFF4EDE6);
  static const Color scaffoldBackgroundColor = Color(0xFFFAF8F5);
  static const Color scaffoldBackgroundColorDark = Color(0xFFF7F3EE);

  static const Color textColor = Color(0xFF333333);
  static const Color greyColor = Color(0xFFF2F2F2);

  static const Color blueColor = Color(0xFF5DA7D8); // 조금 더 톤 다운된 블루
  static const Color redColor = Color(0xFFE76F61); // 조금 더 부드럽고 어두운 레드
  // static const Color lightBlueColor = Color(0xFF87CEEB);
  // static const Color listRedColor = Color(0xFFFA8072);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Pretendard',
      primaryColor: primaryColor,
      primaryColorLight: primaryColorLight,
      primaryColorDark: primaryColorDark,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      listTileTheme: const ListTileThemeData(
        visualDensity: VisualDensity(vertical: -3),
        textColor: textColor,
        iconColor: textColor,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textColor),
        bodyMedium: TextStyle(color: textColor),
        displayLarge: TextStyle(color: primaryColorDark),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: greyColor,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0), // Rounded corners
          borderSide: BorderSide.none, // No border outline
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(
            color: primaryColor, // Set focused border color here
            width: 2.0, // Set the border width if desired
          ),
        ),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: primaryColor,
        textTheme: ButtonTextTheme.primary,
      ),
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(
            primary: primaryColor,
            secondary: accentColor,
            surface: scaffoldBackgroundColor,
          )
          .copyWith(secondary: accentColor)
          .copyWith(surface: backgroundColor),
    );
  }
}
