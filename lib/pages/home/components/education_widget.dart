import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:html' as html;

import '../../../data/models/education_model.dart';
import '../../../data/models/internship_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/screen_helper.dart';

final List<Education> educationList = [
  Education(
    orgName: "B S Abdur Rahman Crescent University, Chennai",
    courseName: "B.TECH CSE",
    link: "https://crescent.education/",
    period: "APR 2021 - APR 2025",
  ),
  Education(
    orgName: "Pearl Matriculation Higher Secondary School, Kanyakumari",
    courseName: "Grade VIII-XII",
    link: "https://www.pearlmatricschool.com/",
    period: "JUN 2016 - APR 2021",
  ),
  Education(
    orgName: "International Indian School Dammam, Saudi Arabia",
    courseName: "KG - VII",
    link: "https://iisdammam.edu.sa/",
    period: "APR 2008 - APR 2016",
  ),
];

class EduSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[50]!,
            Colors.white,
            Colors.blue[50]!.withOpacity(0.3),
          ],
        ),
      ),
      child: ScreenHelper(
        desktop: _buildUi(kDesktopMaxWidth, context),
        tablet: _buildUi(kTabletMaxWidth, context),
        mobile: _buildUi(getMobileMaxWidth(context), context),
      ),
    );
  }

  Widget _buildUi(double width, BuildContext context) {
    final bool isMobile = width < 600;

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        vertical: 80.0,
        horizontal: isMobile ? 20.0 : 40.0,
      ),
      child: MaxWidthBox(
        maxWidth: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Section Header
            _buildSectionHeader(),
            SizedBox(height: 60.0),

            // Education Timeline
            _buildEducationTimeline(context, isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.blue[100]!.withOpacity(0.7),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Text(
            "EDUCATION",
            style: GoogleFonts.inter(
              color: Colors.blue[800],
              fontWeight: FontWeight.w600,
              fontSize: 14.0,
              letterSpacing: 1.2,
            ),
          ),
        ),
        SizedBox(height: 16.0),
        Text(
          "My Academic Journey",
          style: GoogleFonts.inter(
            color: Colors.grey[800],
            fontWeight: FontWeight.w800,
            fontSize: 36.0,
            height: 1.2,
          ),
        ),
        SizedBox(height: 16.0),
        Container(
          constraints: BoxConstraints(maxWidth: 500.0),
          child: Text(
            "From early foundation to specialized technical education, here's my educational pathway that shaped my expertise in computer science and technology.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: Colors.grey[600],
              fontSize: 16.0,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEducationTimeline(BuildContext context, bool isMobile) {
    return Column(
      children: [
        for (int i = 0; i < educationList.length; i++)
          _buildTimelineItem(
            educationList[i],
            i,
            i == educationList.length - 1,
            isMobile,
          ),
      ],
    );
  }

  Widget _buildTimelineItem(
      Education education,
      int index,
      bool isLast,
      bool isMobile,
      ) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 40.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 20.0,
                height: 20.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue[600],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue[600]!.withOpacity(0.3),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Container(
                  width: 2.0,
                  height: 100.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.blue[300]!,
                        Colors.blue[100]!,
                      ],
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 24.0),

          // Education card
          Expanded(
            child: _buildEducationCard(education, index, isMobile),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationCard(Education education, int index, bool isMobile) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: Container(
        padding: EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!.withOpacity(0.5),
              blurRadius: 20.0,
              offset: Offset(0, 10),
              spreadRadius: 0,
            ),
          ],
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: _getColorForIndex(index).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                  color: _getColorForIndex(index).withOpacity(0.3),
                  width: 1.0,
                ),
              ),
              child: Text(
                education.period,
                style: GoogleFonts.inter(
                  color: _getColorForIndex(index),
                  fontWeight: FontWeight.w600,
                  fontSize: 12.0,
                ),
              ),
            ),
            SizedBox(height: 16.0),

            // Institution name
            Text(
              education.orgName,
              style: GoogleFonts.inter(
                color: Colors.grey[800],
                fontWeight: FontWeight.w700,
                fontSize: isMobile ? 18.0 : 20.0,
                height: 1.3,
              ),
            ),
            SizedBox(height: 8.0),

            // Course/Grade info
            Text(
              education.courseName,
              style: GoogleFonts.inter(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                height: 1.4,
              ),
            ),
            SizedBox(height: 16.0),

            // Visit link button
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  final url = education.link.startsWith('http')
                      ? education.link
                      : 'https://${education.link}';
                  html.window.open(url, '_blank');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: _getColorForIndex(index),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.open_in_new,
                        size: 16.0,
                        color: _getColorForIndex(index),
                      ),
                      SizedBox(width: 6.0),
                      Text(
                        "Visit Institution",
                        style: GoogleFonts.inter(
                          color: _getColorForIndex(index),
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForIndex(int index) {
    final colors = [
      Colors.blue[600]!,
      Colors.green[600]!,
      Colors.orange[600]!,
    ];
    return colors[index % colors.length];
  }
}