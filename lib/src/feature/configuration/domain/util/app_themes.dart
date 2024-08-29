import 'package:flutter/material.dart';

class AppThemes {
  ThemeData light() {
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        shadow: Colors.redAccent.withOpacity(0.1),
      ),
      useMaterial3: true,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        constraints: const BoxConstraints(minHeight: 64),
        filled: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) return Colors.grey;
              return Colors.redAccent;
            },
          ),
          foregroundColor: const WidgetStatePropertyAll(Colors.white),
          shape: WidgetStateProperty.resolveWith((states) {
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: states.contains(WidgetState.disabled)
                    ? Colors.transparent
                    : Colors.red,
              ),
            );
          }),
        ),
      ),
      listTileTheme: ListTileThemeData(
        dense: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }

  ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
        primary: const Color(0xFFBB86FC),
        surface: const Color(0xFF2C2C2C),
        shadow: Colors.black.withOpacity(0.2),
      ),
      useMaterial3: true,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        constraints: const BoxConstraints(minHeight: 64),
        filled: true,
        fillColor: const Color(0xFF2E2E2E),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return const Color(0xFF555555);
              }
              return const Color(0xFFCF6679);
            },
          ),
          foregroundColor: const WidgetStatePropertyAll(Colors.white),
          shape: WidgetStateProperty.resolveWith((states) {
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: states.contains(WidgetState.disabled)
                    ? Colors.transparent
                    : const Color(0xFFCF6679),
              ),
            );
          }),
        ),
      ),
      listTileTheme: ListTileThemeData(
        dense: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: Color(0xFFBB86FC),
          ),
        ),
        tileColor: const Color(0xFF1E1E1E),
      ),
    );
  }
}
