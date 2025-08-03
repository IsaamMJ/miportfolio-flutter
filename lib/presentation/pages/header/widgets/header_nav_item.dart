import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/models/header_item.dart';
import '../../../../utils/responsive_helper.dart';

class HeaderNavItem extends StatelessWidget {
  final HeaderItem item;
  final bool isHovered;
  final bool isActive;
  final bool isScrolled;
  final VoidCallback onTap;
  final VoidCallback onEnter;
  final VoidCallback onExit;

  const HeaderNavItem({
    Key? key,
    required this.item,
    required this.isHovered,
    required this.isActive,
    required this.isScrolled,
    required this.onTap,
    required this.onEnter,
    required this.onExit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fontSize = ResponsiveHelper.getResponsiveFontSize(
      context,
      mobile: 13,
      tablet: 14,
      desktop: 14,
    );

    final rightMargin = ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: 16,
      tablet: 20,
      desktop: 28,
    );

    final horizontalPadding = ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: 10,
      tablet: 12,
      desktop: 16,
    );

    if (item.isButton) {
      return _buildCTA(context, fontSize);
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onEnter(),
      onExit: (_) => onExit(),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.only(right: rightMargin),
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10),
          decoration: BoxDecoration(
            color: isHovered || isActive
                ? Colors.blue[50]?.withOpacity(isScrolled ? 0.8 : 0.6)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isActive
                ? Border(
              bottom: BorderSide(
                color: Colors.blue[600]!,
                width: 2.5,
              ),
            )
                : null,
          ),
          child: Text(
            item.title,
            style: GoogleFonts.inter(
              color: isHovered || isActive
                  ? Colors.blue[700]
                  : isScrolled
                  ? Colors.grey[700]
                  : Colors.grey[600],
              fontSize: fontSize,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCTA(BuildContext context, double fontSize) {
    final isHovered = this.isHovered;

    final horizontalPadding = ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: 18,
      tablet: 20,
      desktop: 28,
    );

    final verticalPadding = ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: 10,
      tablet: 12,
      desktop: 14,
    );

    final iconSpacing = ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: 6,
      tablet: 7,
      desktop: 8,
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onEnter(),
      onExit: (_) => onExit(),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isHovered
                  ? [Colors.orange[400]!, Colors.red[400]!]
                  : [Colors.orange[500]!, Colors.red[500]!],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.orange[300]!.withOpacity(isHovered ? 0.5 : 0.4),
                blurRadius: isHovered ? 20 : 15,
                offset: Offset(0, isHovered ? 8 : 5),
                spreadRadius: isHovered ? 1 : 0,
              ),
            ],
          ),
          transform: isHovered
              ? Matrix4.translationValues(0, -2, 0)
              : Matrix4.identity(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.work_outline, color: Colors.white, size: fontSize + 4),
              SizedBox(width: iconSpacing),
              Text(
                item.title,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
