import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:html' as html; // <-- added

import '../../../models/education.dart';
import '../../../utils/constants.dart';
import '../../../utils/screen_helper.dart';

final List<Education> educationList = [
  Education(
    description:
    "Built cross-platform apps with RESTful APIs for data handling and state management via GetX. Optimized widgets and applied lazy loading to boost performance and cut load time by 30%.",
    linkName: "G10X, KOCHI",
    link: "https://g10x.com/",
    period: "MAR 2025 - JUN 2025",
  ),
  Education(
    description:
    "Utilized cutting-edge Deep Learning techniques to tackle diverse challenges, thereby gaining practical experience in the evolving field of data-driven decision-making.",
    linkName: "CDAC, TRIVANDUM",
    link: "https://www.cdac.in/",
    period: "JUN 2024 - JUL 2024",
  ),
  Education(
    description:
    "Enrolled in a hands-on course at Inceptez, gaining experience in Hadoop, Spark, Kafka, cloud platforms, real-time streaming, integration, data governance, and DevOps tools for end-to-end data engineering.",
    linkName: "INCEPTEZ, CHENNAI",
    link: "https://www.inceptez.in/",
    period: "MAR 2024 - JAN 2025",
  ),
  Education(
    description:
    "Designed responsive web interfaces using HTML and CSS, ensuring cross-browser compatibility and contributing to functional enhancements in collaboration with the team.",
    linkName: "ENTERKEY SOLUTIONS, NAGERCOIL",
    link: "https://enterkeysolutions.com/",
    period: "JUN 2023 - JUL 2023",
  ),
];

class EducationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScreenHelper(
        desktop: _buildUi(kDesktopMaxWidth),
        tablet: _buildUi(kTabletMaxWidth),
        mobile: _buildUi(getMobileMaxWidth(context)),
      ),
    );
  }

  Widget _buildUi(double width) {
    return Container(
      alignment: Alignment.center,
      child: MaxWidthBox(
        maxWidth: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "INTERNSHIP'S AND TRAINING",
              style: GoogleFonts.oswald(
                color: Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 30.0,
                height: 1.3,
              ),
            ),
            SizedBox(height: 5.0),
            Wrap(
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 400.0),
                  child: Text(
                    "Each internship was a stepping stone — turning theory into practice, and curiosity into capability.",
                    style: TextStyle(
                      color: Colors.black,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.0),
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  child: Wrap(
                    spacing: 20.0,
                    runSpacing: 20.0,
                    children: educationList
                        .map(
                          (education) => Container(
                        width: constraints.maxWidth / 2.0 - 20.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              education.period,
                              style: GoogleFonts.oswald(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              education.description,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: kCaptionColor,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 20.0),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  final url = education.link.startsWith('http')
                                      ? education.link
                                      : 'https://${education.link}';
                                  html.window.open(url, '_blank');
                                },
                                child: Text(
                                  education.linkName,
                                  style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 40.0),
                          ],
                        ),
                      ),
                    )
                        .toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
