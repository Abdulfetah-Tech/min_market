// Material 3 Theme configuration with full Dark/Light mode support
// Category colors and icons as ThemeExtensions for type-safe access

import 'package:flutter/material.dart';

/// Category color scheme as a ThemeExtension
@immutable
class CategoryTheme extends ThemeExtension<CategoryTheme> {
  const CategoryTheme({
    required this.colors,
    required this.icons,
  });

  final Map<String, Color> colors;
  final Map<String, IconData> icons;

  static const CategoryTheme light = CategoryTheme(
    colors: {
      'smartphones': Color(0xFF2563EB), // blue
      'audio': Color(0xFF059669), // green
      'clothing': Color(0xFFC2410C), // orange
      'computers': Color(0xFF7C3AED), // purple
      'photography': Color(0xFF4D7C0F), // olive
      'accessories': Color(0xFFBE185D), // pink
      'furniture': Color(0xFFB45309), // amber
      'default': Color(0xFF475569), // slate
    },
    icons: {
      'smartphones': Icons.phone_iphone,
      'audio': Icons.headphones,
      'clothing': Icons.checkroom,
      'computers': Icons.laptop_mac,
      'photography': Icons.photo_camera,
      'accessories': Icons.backpack,
      'furniture': Icons.light,
      'default': Icons.shopping_bag,
    },
  );

  static const CategoryTheme dark = CategoryTheme(
    colors: {
      'smartphones': Color(0xFF60A5FA), // blue-400
      'audio': Color(0xFF34D399), // green-400
      'clothing': Color(0xFFFB923C), // orange-400
      'computers': Color(0xFFA78BFA), // purple-400
      'photography': Color(0xFF84CC16), // lime-400
      'accessories': Color(0xFFF472B6), // pink-400
      'furniture': Color(0xFFFBBF24), // amber-400
      'default': Color(0xFF94A3B8), // slate-400
    },
    icons: {
      'smartphones': Icons.phone_iphone,
      'audio': Icons.headphones,
      'clothing': Icons.checkroom,
      'computers': Icons.laptop_mac,
      'photography': Icons.photo_camera,
      'accessories': Icons.backpack,
      'furniture': Icons.light,
      'default': Icons.shopping_bag,
    },
  );

  Color colorFor(String category) => colors[category] ?? colors['default']!;
  IconData iconFor(String category) => icons[category] ?? icons['default']!;

  @override
  CategoryTheme copyWith({
    Map<String, Color>? colors,
    Map<String, IconData>? icons,
  }) => CategoryTheme(
      colors: colors ?? this.colors,
      icons: icons ?? this.icons,
    );

  @override
  CategoryTheme lerp(ThemeExtension<CategoryTheme>? other, double t) {
    if (other is! CategoryTheme) return this;
    return CategoryTheme(
      colors: {
        for (final key in colors.keys)
          key: Color.lerp(colors[key], other.colors[key], t)!,
      },
      icons: icons, // Icons don't lerp
    );
  }
}

/// App spacing and sizing constants
@immutable
class AppSpacing extends ThemeExtension<AppSpacing> {
  const AppSpacing();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;

  static const double elevationLow = 1;
  static const double elevationMed = 4;
  static const double elevationHigh = 8;

  @override
  AppSpacing copyWith() => const AppSpacing();

  @override
  ThemeExtension<AppSpacing> lerp(ThemeExtension<AppSpacing>? other, double t) =>
      const AppSpacing();
}

/// Main theme builder
class AppTheme {
  static ThemeData light() => _buildTheme(Brightness.light);
  static ThemeData dark() => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = isDark ? _darkColorScheme : _lightColorScheme;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      extensions: [
        if (isDark) CategoryTheme.dark else CategoryTheme.light,
        const AppSpacing(),
      ],
      textTheme: _textTheme(colorScheme),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: _textTheme(colorScheme).headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      cardTheme: CardThemeData(
        elevation: AppSpacing.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        color: colorScheme.surfaceContainerHigh,
        surfaceTintColor: colorScheme.surfaceTint,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          elevation: 0,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: _textTheme(colorScheme).labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          side: BorderSide(color: colorScheme.outline),
          foregroundColor: colorScheme.primary,
          textStyle: _textTheme(colorScheme).labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        side: BorderSide(color: colorScheme.outline),
        labelStyle: TextStyle(color: colorScheme.onSurface),
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.primaryContainer,
        secondarySelectedColor: colorScheme.secondaryContainer,
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: colorScheme.errorContainer,
        textColor: colorScheme.onErrorContainer,
        largeSize: 20,
        smallSize: 16,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: TextStyle(color: colorScheme.onInverseSurface),
        actionTextColor: colorScheme.primary,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
        ),
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        modalBackgroundColor: colorScheme.surface,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 64,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        indicatorColor: colorScheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            );
          }
          return TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 12,
          );
        }),
      ),
    );
  }

  static const _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF2563EB),
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFDBEAFE),
    onPrimaryContainer: Color(0xFF1E3A8A),
    secondary: Color(0xFF059669),
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFD1FAE5),
    onSecondaryContainer: Color(0xFF064E3B),
    tertiary: Color(0xFF7C3AED),
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFEDE9FE),
    onTertiaryContainer: Color(0xFF4C1D95),
    error: Color(0xFFDC2626),
    onError: Colors.white,
    errorContainer: Color(0xFFFEF2F2),
    onErrorContainer: Color(0xFF991B1B),
    surface: Colors.white,
    onSurface: Color(0xFF0F172A),
    surfaceContainerHighest: Color(0xFFF1F5F9),
    surfaceContainerHigh: Color(0xFFE2E8F0),
    surfaceContainer: Color(0xFFF8FAFC),
    surfaceContainerLow: Color(0xFFFFFFFF),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    onSurfaceVariant: Color(0xFF475569),
    outline: Color(0xFFCBD5E1),
    outlineVariant: Color(0xFFE2E8F0),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF0F172A),
    onInverseSurface: Color(0xFFF8FAFC),
    inversePrimary: Color(0xFF93C5FD),
    surfaceTint: Color(0xFF2563EB),
  );

  static const _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF60A5FA),
    onPrimary: Color(0xFF1E3A8A),
    primaryContainer: Color(0xFF1E3A8A),
    onPrimaryContainer: Color(0xFFDBEAFE),
    secondary: Color(0xFF34D399),
    onSecondary: Color(0xFF064E3B),
    secondaryContainer: Color(0xFF064E3B),
    onSecondaryContainer: Color(0xFFD1FAE5),
    tertiary: Color(0xFFA78BFA),
    onTertiary: Color(0xFF4C1D95),
    tertiaryContainer: Color(0xFF4C1D95),
    onTertiaryContainer: Color(0xFFEDE9FE),
    error: Color(0xFFF87171),
    onError: Color(0xFF991B1B),
    errorContainer: Color(0xFF991B1B),
    onErrorContainer: Color(0xFFFEF2F2),
    surface: Color(0xFF0F172A),
    onSurface: Color(0xFFF8FAFC),
    surfaceContainerHighest: Color(0xFF1E293B),
    surfaceContainerHigh: Color(0xFF334155),
    surfaceContainer: Color(0xFF1E293B),
    surfaceContainerLow: Color(0xFF0F172A),
    surfaceContainerLowest: Color(0xFF020617),
    onSurfaceVariant: Color(0xFF94A3B8),
    outline: Color(0xFF475569),
    outlineVariant: Color(0xFF334155),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFF8FAFC),
    onInverseSurface: Color(0xFF0F172A),
    inversePrimary: Color(0xFF2563EB),
    surfaceTint: Color(0xFF60A5FA),
  );

  static TextTheme _textTheme(ColorScheme colorScheme) => TextTheme(
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
          color: colorScheme.onSurface,
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          color: colorScheme.onSurface,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          color: colorScheme.onSurface,
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: colorScheme.onSurface,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: colorScheme.onSurface,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: colorScheme.onSurface,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
          color: colorScheme.onSurface,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
          color: colorScheme.onSurface,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: colorScheme.onSurface,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          color: colorScheme.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          color: colorScheme.onSurface,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          color: colorScheme.onSurfaceVariant,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: colorScheme.onSurface,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: colorScheme.onSurfaceVariant,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: colorScheme.onSurfaceVariant,
        ),
      );
}