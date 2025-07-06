import 'package:flutter/material.dart';

/// Brand Colors
const Color kcPrimaryColor = Color(0xFF094141); // Deep Teal (Primary)
const Color kcPrimaryColorAlt = Color(0xFF008080); // Secondary Teal

/// Secondary Palette
const Color kcSoftWhite = Color(0xFFF8F8FF);
const Color kcAqua = Color(0xFFCFFDFE);
const Color kcSkyBlue = Color(0xFFC5E6FF);
const Color kcLavender = Color(0xFFE5DEFE);
const Color kcMintGreen = Color(0xFF9CDCB7);

/// Greyscale & Backgrounds
const Color kcDarkGreyColor = Color(0xFF1A1B1E);
const Color kcMediumGrey = Color(0xFF474A54);
const Color kcLightGrey = Color.fromARGB(255, 187, 187, 187);
const Color kcVeryLightGrey = Color(0xFFE3E3E3);
const Color kcBackgroundColor = kcDarkGreyColor;

// Consistent with the combination file definition
const Color deepTeal = Color(0xFF094141);
const Color teal = Color(0xFF008080);
const Color softWhite = Color(0xFFF8F8FF);
const Color aqua = Color(0xFFCFFDFE);
const Color skyBlue = Color(0xFFC5E6FF);
const Color lavender = Color(0xFFE5DEFE);
const Color mintGreen = Color(0xFF9CDCB7);

/// Modern gradient colors for enhanced UI
const LinearGradient primaryGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF094141), Color(0xFF008080)],
);

const LinearGradient cardGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFF8F8FF), Color(0xFFCFFDFE)],
);

const LinearGradient backgroundGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xFFF8F8FF), Color(0xFFE5DEFE)],
);

/// Status colors
const Color successColor = Color(0xFF4CAF50);
const Color warningColor = Color(0xFFFF9800);
const Color errorColor = Color(0xFFF44336);
const Color infoColor = Color(0xFF2196F3);
