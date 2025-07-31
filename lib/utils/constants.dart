import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xFF1E3A8A);        // Deep Indigo (professional, strong)
const Color kBackgroundColor = Color(0xFFF9FAFB);     // Soft off-white (light, clean)
const Color kDangerColor = Color(0xFFE11D48);         // Elegant crimson red (for buttons)
const Color kCaptionColor = Color(0xFF374151);        // Dark slate gray (smoother than black)


// Lets replace all static sizes
const double kDesktopMaxWidth = 1000.0;
const double kTabletMaxWidth = 760.0;
double getMobileMaxWidth(BuildContext context) =>
    MediaQuery.of(context).size.width * .8;
