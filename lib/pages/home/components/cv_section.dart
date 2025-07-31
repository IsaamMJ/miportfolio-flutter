import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../models/design_process.dart';
import '../../../utils/constants.dart';
import '../../../utils/screen_helper.dart';

final List<DesignProcess> designProcesses = [
  DesignProcess(
    title: "DESIGN",
    imagePath: "assets/design.png",
    subtitle:
    "Crafting sleek, intuitive UI/UX for cross-platform apps that users love to use.",
  ),
  DesignProcess(
    title: "DEVELOP",
    imagePath: "assets/develop.png",
    subtitle:
    "Building high-performance Flutter apps with clean architecture and scalable code.",
  ),
  DesignProcess(
    title: "WRITE",
    imagePath: "assets/write.png",
    subtitle:
    "Writing maintainable, efficient Dart code that powers seamless mobile experiences.",
  ),
  DesignProcess(
    title: "PROMOTE",
    imagePath: "assets/promote.png",
    subtitle:
    "Optimizing apps for visibility, performance, and user growth on the Play Store.",
  ),
];

class CvSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ScreenHelper(
        desktop: _buildUi(context, kDesktopMaxWidth),
        tablet: _buildUi(context, kTabletMaxWidth),
        mobile: _buildUi(context, getMobileMaxWidth(context)),
      ),
    );
  }

  Widget _buildUi(BuildContext context, double width) {
    return Container(
      alignment: Alignment.center,
      child: MaxWidthBox(
        maxWidth: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "BETTER DESIGN,\nBETTER EXPERIENCES",
                  style: GoogleFonts.oswald(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    height: 1.8,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 50.0),
            LayoutBuilder(
              builder: (_context, constraints) {
                return ResponsiveGridView.builder(
                  padding: EdgeInsets.all(0.0),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  alignment: Alignment.topCenter,
                  gridDelegate: ResponsiveGridDelegate(
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 20.0,
                    maxCrossAxisExtent: ScreenHelper.isTablet(context) ||
                        ScreenHelper.isMobile(context)
                        ? constraints.maxWidth / 2.0
                        : 250.0,
                    childAspectRatio: ScreenHelper.isDesktop(context)
                        ? 1
                        : MediaQuery.of(context).size.aspectRatio * 1.5,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              designProcesses[index].imagePath,
                              width: 40.0,
                            ),
                            SizedBox(width: 15.0),
                            Text(
                              designProcesses[index].title,
                              style: GoogleFonts.oswald(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          designProcesses[index].subtitle,
                          style: TextStyle(
                            color: kCaptionColor,
                            height: 1.5,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    );
                  },
                  itemCount: designProcesses.length,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
