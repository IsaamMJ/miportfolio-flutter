import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/constants.dart';
import '../../../data/models/footer_item.dart';
import '../../../utils/constants.dart';
import '../../../utils/screen_helper.dart';

final List<FooterItem> footerItems = [
  FooterItem(
    iconPath: "assets/mappin.png",
    title: "ADDRESS",
    text1: "Tamilnadu, India",
    text2: "Nagercoil, Tamil Nadu",
  ),
  FooterItem(
    iconPath: "assets/phone.png",
    title: "PHONE",
    text1: "+91 9488894451",
    text2: "Available 9 AM - 6 PM",
  ),
  FooterItem(
    iconPath: "assets/email.png",
    title: "EMAIL",
    text1: "isaam.mj@gmail.com",
    text2: "Business inquiries",
  ),
];

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryColor,
      child: ScreenHelper(
        desktop: _buildUi(kDesktopMaxWidth, context),
        tablet: _buildUi(kTabletMaxWidth, context),
        mobile: _buildUi(getMobileMaxWidth(context), context),
      ),
    );
  }

  Widget _buildUi(double width, BuildContext context) {
    return Center(
      child: MaxWidthBox(
        maxWidth: width,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
          child: Column(
            children: [
              // Contact Info
              Wrap(
                alignment: WrapAlignment.center,
                spacing: ScreenHelper.isMobile(context) ? 20.0 : 60.0,
                runSpacing: 30.0,
                children: footerItems.map((item) => _buildContactItem(item)).toList(),
              ),

              const SizedBox(height: 40.0),

              // Divider
              Container(
                height: 1.0,
                color: Colors.white.withOpacity(0.2),
              ),

              const SizedBox(height: 30.0),

              // Bottom Row
              Flex(
                direction: ScreenHelper.isMobile(context) ? Axis.vertical : Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "© 2025 Mohamed Isaam M J. All rights reserved.",
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.8), // Fixed: Made visible
                      fontSize: 14.0,
                    ),
                  ),
                  if (ScreenHelper.isMobile(context)) const SizedBox(height: 16.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildSocialIcon(
                        Icons.facebook,
                        const Color(0xFF1877F2),
                        'https://www.facebook.com/yourprofile',
                      ),
                      const SizedBox(width: 12.0),
                      _buildSocialIcon(
                        Icons.send,
                        const Color(0xFF0088CC),
                        'https://t.me/yourusername',
                      ),
                      const SizedBox(width: 12.0),
                      _buildSocialIcon(
                        Icons.camera_alt,
                        const Color(0xFFE4405F),
                        'https://www.instagram.com/yourprofile',
                      ),
                      const SizedBox(width: 12.0),
                      _buildSocialIcon(
                        Icons.code,
                        Colors.white, // Fixed: Changed from light color to white
                        'https://github.com/yourusername',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(FooterItem item) {
    return MouseRegion(
      cursor: item.title == "EMAIL" || item.title == "PHONE"
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: () => _handleContactTap(item),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1), // Improved contrast
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Image.asset(
                item.iconPath,
                width: 16.0,
                height: 16.0,
                color: Colors.white, // Fixed: Made icon white for visibility
              ),
            ),
            const SizedBox(width: 12.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white, // Already correct
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  item.text1,
                  style: GoogleFonts.inter(
                    fontSize: 13.0,
                    color: Colors.white.withOpacity(0.8), // Fixed: Made more visible
                  ),
                ),
                // Added the missing text2 display
                if (item.text2.isNotEmpty) ...[
                  const SizedBox(height: 2.0),
                  Text(
                    item.text2,
                    style: GoogleFonts.inter(
                      fontSize: 12.0,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color, String url) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _launchURL(url),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15), // Slightly increased opacity
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
              color: color.withOpacity(0.3), // Added subtle border
              width: 1.0,
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: 18.0,
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  void _handleContactTap(FooterItem item) {
    switch (item.title) {
      case "EMAIL":
        _launchURL('mailto:${item.text1}');
        break;
      case "PHONE":
        _launchURL('tel:${item.text1}');
        break;
      default:
        break;
    }
  }
}