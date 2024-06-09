import 'package:beehub_flutter_app/utils/theme/custom_themes/appbar_theme.dart';
import 'package:beehub_flutter_app/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:beehub_flutter_app/utils/theme/custom_themes/checkbox_theme.dart';
import 'package:beehub_flutter_app/utils/theme/custom_themes/chip_theme.dart';
import 'package:beehub_flutter_app/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:beehub_flutter_app/utils/theme/custom_themes/outline_button_theme.dart';
import 'package:beehub_flutter_app/utils/theme/custom_themes/text_field_theme.dart';
import 'package:beehub_flutter_app/utils/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class TAppTheme{
  TAppTheme._();
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.deepPurple,
    scaffoldBackgroundColor: Colors.white,
    textTheme: GoogleFonts.quicksandTextTheme(TTextTheme.lightTextTheme),
    chipTheme: TChipTheme.lightChipTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.deepPurple,
    scaffoldBackgroundColor: Colors.black,
    textTheme: GoogleFonts.quicksandTextTheme(TTextTheme.darkTextTheme),
    chipTheme: TChipTheme.darkChipTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme
  );
}