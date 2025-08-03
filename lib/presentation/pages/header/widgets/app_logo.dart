// lib/presentation/widgets/app_logo.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/responsive_helper.dart';

class AppLogo extends StatelessWidget {
  final bool isScrolled;

  const AppLogo({Key? key, required this.isScrolled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logoSize = ResponsiveHelper.getResponsiveFontSize(
      context,
      mobile: 22.0,
      tablet: 24.0,
      desktop: 26.0,
    );

    final logoPadding = ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: 8.0,
      tablet: 9.0,
      desktop: 10.0,
    );

    final logoVerticalPadding = ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: 5.0,
      tablet: 6.0,
      desktop: 6.0,
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Scrollable.ensureVisible(
          context,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        ),
        child: TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300),
          tween: Tween(begin: 0.0, end: isScrolled ? 1.0 : 0.0),
          builder: (context, value, child) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(
                horizontal: logoPadding + (value * 2),
                vertical: logoVerticalPadding + (value * 2),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue[600]!,
                    Colors.purple[600]!,
                  ],
                ),
                borderRadius: BorderRadius.circular(10.0 + (value * 3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue[300]!.withOpacity(0.3 + (value * 0.2)),
                    blurRadius: 12.0 + (value * 8),
                    offset: Offset(0, 4 + (value * 2)),
                  ),
                ],
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "M",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: logoSize + (value * 2),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: ".",
                      style: GoogleFonts.inter(
                        color: Colors.yellow[300],
                        fontSize: logoSize + 4 + (value * 2),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
