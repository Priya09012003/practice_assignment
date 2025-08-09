import 'package:flutter/material.dart';

class AppSizes {
  // Static sizes for padding
  static const double paddingExtraSmall = 2.0;
  static const double paddingMidSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingMidMedium = 10.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 35.0;

  // Static sizes for margin
  static const double marginExtraSmall = 2.0;
  static const double marginMidSmall = 4.0;
  static const double marginSmall = 8.0;
  static const double marginMidMedium = 10.0;
  static const double marginMedium = 16.0;
  static const double marginLarge = 24.0;

  // Static sizes for font
  static const double extrafontSizeSmall = 9;
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMediumSmall = 10.0;
  static const double fontSizeExtraSmall = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeExtraMedium = 18.0;
  static const double fontSizeLarge = 20.0;

  // Static sizes for icon
  static const double iconSizeExtraSmall = 8.0;
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;

  // Static sizes for border radius
  static const double borderRadiusExtraSmall = 2.0;
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusExtraMedium = 10.0;
  static const double borderRadiusLarge = 16.0;

  // Static sizes for elevation
  static const double elevationLow = 2.0;
  static const double elevationMedium = 6.0;
  static const double elevationHigh = 12.0;

  // Function to get the screen size
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
}
