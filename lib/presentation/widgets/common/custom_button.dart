import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/constants.dart';
import '../../../utils/responsive_helper.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final IconData? icon;
  final Color? color;
  final double? width;
  final double? height;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
    this.icon,
    this.color,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? (isPrimary ? kPrimaryColor : Colors.white);
    final textColor = isPrimary ? Colors.white : (color ?? kPrimaryColor);

    return Container(
      width: width,
      height: height ?? (ResponsiveHelper.isMobile(context) ? 40 : 50),
      decoration: BoxDecoration(
        gradient: isPrimary ? LinearGradient(colors: [buttonColor, buttonColor.withOpacity(0.8)]) : null,
        color: isPrimary ? null : Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveHelper.isMobile(context) ? 20 : 25),
        border: isPrimary ? null : Border.all(color: buttonColor),
        boxShadow: [
          BoxShadow(
            color: isPrimary ? buttonColor.withOpacity(0.3) : Colors.black.withOpacity(0.05),
            blurRadius: isPrimary ? 15 : 5,
            offset: Offset(0, isPrimary ? 5 : 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(ResponsiveHelper.isMobile(context) ? 20 : 25),
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isMobile(context) ? 16 : 24),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: textColor, size: ResponsiveHelper.isMobile(context) ? 14 : 18),
                  SizedBox(width: ResponsiveHelper.isMobile(context) ? 4 : 8),
                ],
                Flexible(
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: textColor,
                      fontSize: ResponsiveHelper.getResponsiveFontSize(context, mobile: 12, tablet: 13, desktop: 14),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}