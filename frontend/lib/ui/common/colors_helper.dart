import 'package:flutter/material.dart';

// example usage
/*
import '../../../../ui/common/colors_helper.dart';

final combo = AppThemeCombos.combos['mintGreen_softWhite'];
Text(
  'Finsplore',
  style: TextStyle(
    color: combo?.foreground,
    fontFamily: 'Georgia',
    fontWeight: FontWeight.bold,
    fontSize: 20,
  ),
);
Container(
  color: combo?.background,
  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
  child: const Text('Finsplore'),
);

*/

class AppThemeCombos {
  // Exact brand color references
  static const Color deepTeal = Color(0xFF094141);
  static const Color teal = Color(0xFF008080);
  static const Color softWhite = Color(0xFFF8F8FF);
  static const Color aqua = Color(0xFFCFFDFE);
  static const Color skyBlue = Color(0xFFC5E6FF);
  static const Color lavender = Color(0xFFE5DEFE);
  static const Color mintGreen = Color(0xFF9CDCB7);

  /// Named button color pairs (background + foreground)
  static const Map<String, ColorCombo> combos = {
    'deepTeal_softWhite': ColorCombo(
      background: deepTeal,
      foreground: softWhite,
    ),
    'aqua_deepTeal': ColorCombo(
      background: aqua,
      foreground: deepTeal,
    ),
    'lavender_deepTeal': ColorCombo(
      background: lavender,
      foreground: deepTeal,
    ),
    'teal_softWhite': ColorCombo(
      background: teal,
      foreground: softWhite,
    ),
    'softWhite_deepTeal': ColorCombo(
      background: softWhite,
      foreground: deepTeal,
    ),
    'mintGreen_softWhite': ColorCombo(
      background: mintGreen,
      foreground: softWhite,
    ),
  };
}

class ColorCombo {
  final Color background;
  final Color foreground;

  const ColorCombo({
    required this.background,
    required this.foreground,
  });
}
