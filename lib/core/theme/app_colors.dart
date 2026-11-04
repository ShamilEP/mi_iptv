import 'package:flutter/material.dart';

/// Brand Theme 2026–27 color tokens. Prefer these over raw hex in widgets.
abstract final class AppColors {
  static const Color ink = Color(0xFF0A0D14);
  static const Color surface = Color(0xFF1A2130);
  static const Color panel = Color(0xFF11161F);
  static const Color border = Color(0xFF2A3447);
  static const Color cloud = Color(0xFFF0EEE9);
  static const Color mist = Color(0xFFA3AFC4);
  static const Color signal = Color(0xFF2BD9C8);
  static const Color ember = Color(0xFFFF7A4D);
  static const Color success = Color(0xFF6FDC8C);
  static const Color warning = Color(0xFFFFC857);
  static const Color error = Color(0xFFFF6B7A);

  /// Companion light-theme accents (legibility on [cloud]).
  static const Color companionPrimary = Color(0xFF0A6F68);
  static const Color companionLive = Color(0xFFB8431B);
  static const Color companionMuted = Color(0xFF3B4658);
}
