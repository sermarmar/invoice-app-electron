import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Roles semánticos:
///
///  primary      → twilight_indigo  Acciones principales, AppBar, botones rellenos
///  secondary    → muted_teal       Acciones secundarias, chips, toggles
///  tertiary     → apricot_cream    Destacados, badges, iconos de estado positivo
///  error        → burnt_peach      Errores, acciones destructivas
///  surface      → eggshell         Fondo de cards, diálogos, scaffolds
abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: _lightColorScheme,
        visualDensity: VisualDensity.compact,
        fontFamily: 'Segoe UI',
        cardTheme: const CardThemeData(
          color: AppColors.eggshell800,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.twilightIndigo,
          foregroundColor: AppColors.eggshell,
          elevation: 0,
          centerTitle: false,
        ),
        navigationRailTheme: const NavigationRailThemeData(
          backgroundColor: AppColors.twilightIndigo400,
          selectedIconTheme: IconThemeData(color: AppColors.apricotCream),
          unselectedIconTheme: IconThemeData(color: AppColors.twilightIndigo900),
          selectedLabelTextStyle: TextStyle(color: AppColors.apricotCream),
          unselectedLabelTextStyle: TextStyle(color: AppColors.twilightIndigo900),
          indicatorColor: AppColors.twilightIndigo500,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.burntPeach,
          foregroundColor: AppColors.eggshell,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.twilightIndigo,
            foregroundColor: AppColors.eggshell,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.twilightIndigo,
            side: const BorderSide(color: AppColors.twilightIndigo),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.twilightIndigo600,
          ),
        ),
        chipTheme: const ChipThemeData(
          backgroundColor: AppColors.mutedTeal900,
          labelStyle: TextStyle(color: AppColors.mutedTeal200),
          side: BorderSide(color: AppColors.mutedTeal700),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: AppColors.eggshell700,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: AppColors.twilightIndigo900),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: AppColors.twilightIndigo900),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: AppColors.twilightIndigo, width: 2),
          ),
          labelStyle: TextStyle(color: AppColors.twilightIndigo600),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.eggshell400,
          thickness: 1,
        ),
        badgeTheme: const BadgeThemeData(
          backgroundColor: AppColors.apricotCream400,
          textColor: AppColors.apricotCream100,
        ),
        textTheme: _textTheme,
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: _darkColorScheme,
        visualDensity: VisualDensity.compact,
        fontFamily: 'Segoe UI',
        cardTheme: const CardThemeData(
          color: AppColors.twilightIndigo400,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.twilightIndigo200,
          foregroundColor: AppColors.eggshell,
          elevation: 0,
          centerTitle: false,
        ),
        navigationRailTheme: const NavigationRailThemeData(
          backgroundColor: AppColors.twilightIndigo200,
          selectedIconTheme: IconThemeData(color: AppColors.apricotCream),
          unselectedIconTheme: IconThemeData(color: AppColors.twilightIndigo800),
          selectedLabelTextStyle: TextStyle(color: AppColors.apricotCream),
          unselectedLabelTextStyle: TextStyle(color: AppColors.twilightIndigo800),
          indicatorColor: AppColors.twilightIndigo400,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.burntPeach,
          foregroundColor: AppColors.eggshell,
        ),
        textTheme: _textTheme.apply(
          bodyColor: AppColors.eggshell600,
          displayColor: AppColors.eggshell,
        ),
      );

  // ---------------------------------------------------------------------------

  static const _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    // Primary — twilight indigo
    primary: AppColors.twilightIndigo,
    onPrimary: AppColors.eggshell,
    primaryContainer: AppColors.twilightIndigo900,
    onPrimaryContainer: AppColors.twilightIndigo100,
    // Secondary — muted teal
    secondary: AppColors.mutedTeal,
    onSecondary: AppColors.eggshell,
    secondaryContainer: AppColors.mutedTeal900,
    onSecondaryContainer: AppColors.mutedTeal200,
    // Tertiary — apricot cream
    tertiary: AppColors.apricotCream400,
    onTertiary: AppColors.apricotCream100,
    tertiaryContainer: AppColors.apricotCream900,
    onTertiaryContainer: AppColors.apricotCream200,
    // Error — burnt peach
    error: AppColors.burntPeach,
    onError: AppColors.eggshell,
    errorContainer: AppColors.burntPeach900,
    onErrorContainer: AppColors.burntPeach200,
    // Surface — eggshell
    surface: AppColors.eggshell800,
    onSurface: AppColors.twilightIndigo300,
    surfaceContainerHighest: AppColors.eggshell600,
    onSurfaceVariant: AppColors.twilightIndigo500,
    // Outline
    outline: AppColors.twilightIndigo900,
    outlineVariant: AppColors.eggshell400,
    // Misc
    shadow: AppColors.twilightIndigo200,
    scrim: AppColors.twilightIndigo100,
    inverseSurface: AppColors.twilightIndigo400,
    onInverseSurface: AppColors.eggshell,
    inversePrimary: AppColors.twilightIndigo800,
  );

  static const _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.twilightIndigo800,
    onPrimary: AppColors.twilightIndigo100,
    primaryContainer: AppColors.twilightIndigo400,
    onPrimaryContainer: AppColors.twilightIndigo900,
    secondary: AppColors.mutedTeal600,
    onSecondary: AppColors.mutedTeal100,
    secondaryContainer: AppColors.mutedTeal300,
    onSecondaryContainer: AppColors.mutedTeal900,
    tertiary: AppColors.apricotCream500,
    onTertiary: AppColors.apricotCream100,
    tertiaryContainer: AppColors.apricotCream300,
    onTertiaryContainer: AppColors.apricotCream900,
    error: AppColors.burntPeach600,
    onError: AppColors.burntPeach100,
    errorContainer: AppColors.burntPeach300,
    onErrorContainer: AppColors.burntPeach900,
    surface: AppColors.twilightIndigo300,
    onSurface: AppColors.eggshell600,
    surfaceContainerHighest: AppColors.twilightIndigo400,
    onSurfaceVariant: AppColors.eggshell400,
    outline: AppColors.twilightIndigo700,
    outlineVariant: AppColors.twilightIndigo500,
    shadow: AppColors.twilightIndigo100,
    scrim: AppColors.twilightIndigo100,
    inverseSurface: AppColors.eggshell700,
    onInverseSurface: AppColors.twilightIndigo400,
    inversePrimary: AppColors.twilightIndigo500,
  );

  static const _textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w300,
      color: AppColors.twilightIndigo,
      letterSpacing: -0.25,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w300,
      color: AppColors.twilightIndigo,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      color: AppColors.twilightIndigo,
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: AppColors.twilightIndigo,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: AppColors.twilightIndigo,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.twilightIndigo,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: AppColors.twilightIndigo,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.twilightIndigo,
      letterSpacing: 0.15,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.twilightIndigo,
      letterSpacing: 0.1,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.twilightIndigo500,
      letterSpacing: 0.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.twilightIndigo500,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.twilightIndigo600,
      letterSpacing: 0.4,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.twilightIndigo,
      letterSpacing: 0.1,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.twilightIndigo,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: AppColors.twilightIndigo,
      letterSpacing: 0.5,
    ),
  );
}
