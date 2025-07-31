import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../models/header_item.dart';
import '../../../utils/constants.dart';
import '../../../utils/globals.dart';
import '../../../utils/screen_helper.dart';

List<HeaderItem> headerItems = [
  HeaderItem(title: "HOME", onTap: () {}),
  HeaderItem(title: "MY INTRO", onTap: () {}),
  HeaderItem(title: "SERVICES", onTap: () {}),
  HeaderItem(title: "PORTFOLIO", onTap: () {}),
  HeaderItem(title: "TESTIMONIALS", onTap: () {}),
  HeaderItem(title: "BLOGS", onTap: () {}),
  HeaderItem(
    title: "HIRE ME",
    onTap: () {},
    isButton: true,
  ),
];

class HeaderLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {},
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "M",
                style: GoogleFonts.oswald(
                  color: Colors.black,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ".",
                style: GoogleFonts.oswald(
                  color: kPrimaryColor,
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveVisibility(
      visible: true,
      hiddenConditions: [Condition.smallerThan(name: MOBILE)], // or DESKTOP depending on your breakpoint
      child: Row(
        children: headerItems.map((item) {
          return item.isButton
              ? MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              decoration: BoxDecoration(
                color: kDangerColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: TextButton(
                onPressed: item.onTap,
                child: Text(
                  item.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
              : MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              margin: EdgeInsets.only(right: 30.0),
              child: GestureDetector(
                onTap: item.onTap,
                child: Text(
                  item.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}


class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenHelper(
      desktop: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: buildHeader(),
      ),
      tablet: buildHeader(),
      mobile: buildMobileHeader(),
    );
  }

  Widget buildMobileHeader() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HeaderLogo(),
            GestureDetector(
              onTap: () {
                Globals.scaffoldKey.currentState?.openEndDrawer();
              },
              child: Icon(
                FeatherIcons.menu,
                color: Colors.black,
                size: 28.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HeaderLogo(),
          HeaderRow(),
        ],
      ),
    );
  }
}
