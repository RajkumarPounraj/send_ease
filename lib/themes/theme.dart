import 'package:flutter/material.dart';
import 'package:send_ease/themes/app_colors.dart';

class CustomAppTheme
{
  static final CustomAppTheme customAppTheme = CustomAppTheme._internal();

  factory CustomAppTheme()
  {
    return customAppTheme;
  }

  CustomAppTheme._internal();


  static ThemeData lightAppTheme = ThemeData.light().copyWith(
    primaryColor: primaryColor,
    brightness: Brightness.light,
    appBarTheme:  AppBarTheme(
        elevation: 2,
        surfaceTintColor: Colors.white,
        color: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black), toolbarTextStyle:  const TextTheme(
            titleMedium: TextStyle(color: Colors.black),
            bodySmall: TextStyle(color: Colors.black)).bodyMedium, titleTextStyle:  const TextTheme(
            titleMedium: TextStyle(color: Colors.black),
            bodySmall: TextStyle(color: Colors.black)).titleLarge),
    primaryTextTheme: const TextTheme(titleMedium: TextStyle(color: Colors.black)),
    hoverColor: lightIconBackgroundColor,
    dividerColor: lightIconBackgroundColor,
    canvasColor: lightBackgroundColor,
    sliderTheme: const SliderThemeData(),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: Colors.white),
    bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: lightBackgroundColor,
        modalBackgroundColor: lightBackgroundColor),
    textTheme:  const TextTheme(
      titleLarge: TextStyle(
        color: primaryColor,
      ),
      bodyMedium: TextStyle(
        color: primaryColor,
      ),
      titleMedium: TextStyle(
        color: primaryColor,
      ),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    }),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: primaryColor).copyWith(background: lightBackgroundColor),
  );

  static String interBold =  "Inter Bold";



}

