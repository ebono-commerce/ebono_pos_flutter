import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:ebono_pos/ui/Common_button.dart';

ThemeData themeData(BuildContext context) {
  return ThemeData(
      useMaterial3: true,
      primaryColor: CustomColors.primaryColor,
      colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: CustomColors.primaryColor,
          onPrimary: Colors.black,
          secondary: CustomColors.secondaryColor,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black),
      textTheme: GoogleFonts.interTextTheme(
        Theme.of(context).textTheme,
      ).copyWith(
        // displayLarge: GoogleFonts.inter(), // 57px
        // displayMedium: GoogleFonts.inter(), // 45px
        // displaySmall: GoogleFonts.inter(), // 36px
        // headlineLarge: GoogleFonts.inter(), // 36px
        // headlineMedium: GoogleFonts.inter(), // 28px
        // headlineSmall: GoogleFonts.inter(), // 24px
        // titleLarge: GoogleFonts.inter(), // 32px
        // titleMedium: GoogleFonts.inter(), // 20px
        // titleSmall: GoogleFonts.inter(), // 16px
        // bodyLarge: GoogleFonts.inter(), // 24px
        // bodyMedium: GoogleFonts.inter(), // 16px
        // bodySmall: GoogleFonts.inter(), // 14px
        // labelLarge: GoogleFonts.inter(), // 14px
        // labelMedium: GoogleFonts.inter(), // 12px
        // labelSmall: GoogleFonts.inter(), // 11px,

        displayLarge: GoogleFonts.inter(fontSize: 57), // Display Large - 57px
        displayMedium: GoogleFonts.inter(fontSize: 45), // Display Medium - 45px
        displaySmall: GoogleFonts.inter(fontSize: 36), // Display Small - 36px

        headlineLarge: GoogleFonts.inter(fontSize: 32), // Headline Large - 32px
        headlineMedium:
            GoogleFonts.inter(fontSize: 28), // Headline Medium - 28px
        headlineSmall: GoogleFonts.inter(fontSize: 24), // Headline Small - 24px

        titleLarge: GoogleFonts.inter(fontSize: 22), // Title Large - 22px
        titleMedium: GoogleFonts.inter(fontSize: 16), // Title Medium - 16px
        titleSmall: GoogleFonts.inter(fontSize: 14), // Title Small - 14px

        bodyLarge: GoogleFonts.inter(fontSize: 16), // Body Large - 16px
        bodyMedium: GoogleFonts.inter(fontSize: 14), // Body Medium - 14px
        bodySmall: GoogleFonts.inter(fontSize: 12), // Body Small - 12px

        labelLarge: GoogleFonts.inter(fontSize: 14), // Label Large - 14px
        labelMedium: GoogleFonts.inter(fontSize: 12), // Label Medium - 12px
        labelSmall: GoogleFonts.inter(fontSize: 11), // Label Small - 11px
      ),
      buttonTheme: ButtonThemeData(buttonColor: Theme.of(context).primaryColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: commonElevatedButtonStyle(
            theme: Theme.of(context),
            textStyle: Theme.of(context).textTheme.bodyMedium,
            padding: EdgeInsets.all(10)),
      ));
}
