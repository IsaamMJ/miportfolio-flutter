import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../utils/globals.dart';
import '../../../utils/section_keys.dart';
import '../../../utils/responsive_helper.dart';
import '../hero_section/hero_section.dart';
import 'components/cv_section.dart';
import 'components/internship_section.dart';
import 'components/footer.dart';
import '../header/header.dart' hide homeKey;
import 'components/ios_app_ad.dart';
import 'components/website_carousel.dart';
import 'components/portfolio_stats.dart';
import 'components/skill_section.dart';
import 'components/education_widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // ScrollController for the sticky header
  final ScrollController _scrollController = ScrollController();

  // 📱 OPTIMIZED: More concise carousel height calculation
  double _getCarouselHeight(BuildContext context) {
    final heightPercentage = ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: 70.0,
      tablet: 75.0,
      desktop: 80.0,
    );

    final baseHeight = ResponsiveHelper.getHeightPercentage(context, heightPercentage);
    final minHeight = ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: 400.0,
      tablet: 450.0,
      desktop: 500.0,
    );
    final maxHeight = ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: 700.0,
      tablet: 800.0,
      desktop: 900.0,
    );

    return baseHeight.clamp(minHeight, maxHeight);
  }

  // 📱 OPTIMIZED: Simplified margin calculation
  EdgeInsets _getCarouselMargin(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: ResponsiveHelper.getResponsiveValue<double>(
        context,
        mobile: 8.0,
        tablet: 16.0,
        desktop: 24.0,
      ),
    );
  }

  // 📱 OPTIMIZED: Simplified border radius calculation
  double _getCarouselBorderRadius(BuildContext context) {
    return ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: 8.0,
      tablet: 12.0,
      desktop: 16.0,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Globals.scaffoldKey,
      endDrawer: _buildDrawer(context),
      body: Column(
        children: [
          // 📌 STICKY HEADER
          EnhancedHeader(scrollController: _scrollController),

          // 📜 SCROLLABLE CONTENT
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. HERO SECTION
                  _buildSection(
                    key: homeKey,
                    context: context,
                    child: VisibilityDetector(
                      key: const Key('home-section'),
                      onVisibilityChanged: (info) {
                        if (info.visibleFraction > 0.45) {
                          Globals.activeSectionIndex.value = 0;
                        }
                      },
                      child: HeroSection(),
                    ),
                    maxWidth: 1200.0,
                  ),

                  // 2. SKILLS SECTION
                  _buildSection(
                    key: servicesKey,
                    context: context,
                    child: VisibilityDetector(
                      key: const Key('skills-section'),
                      onVisibilityChanged: (info) {
                        if (info.visibleFraction > 0.45) {
                          Globals.activeSectionIndex.value = 1;
                        }
                      },
                      child: SkillSection(),
                    ),
                    maxWidth: 1200.0,
                    topSpacing: ResponsiveHelper.getResponsiveValue<double>(
                      context,
                      mobile: 30.0,
                      tablet: 50.0,
                      desktop: 70.0,
                    ),
                  ),

                  // 3. PORTFOLIO STATS
                  _buildSection(
                    context: context,
                    child: PortfolioStats(),
                    maxWidth: 1000.0,
                    topSpacing: ResponsiveHelper.getResponsiveValue<double>(
                      context,
                      mobile: 24.0,
                      tablet: 40.0,
                      desktop: 50.0,
                    ),
                  ),

                  // 4. PROJECTS SECTION
                  SizedBox(
                    height: ResponsiveHelper.getResponsiveValue<double>(
                      context,
                      mobile: 40.0,
                      tablet: 60.0,
                      desktop: 80.0,
                    ),
                  ),
                  Container(
                    key: portfolioKey,
                    width: double.infinity,
                    child: VisibilityDetector(
                      key: const Key('portfolio-section'),
                      onVisibilityChanged: (info) {
                        if (info.visibleFraction > 0.45) {
                          Globals.activeSectionIndex.value = 2;
                        }
                      },
                      child: _buildProjectsSection(context),
                    ),
                  ),

                  // 5. INTERNSHIP SECTION
                  _buildSection(
                    key: testimonialsKey,
                    context: context,
                    child: VisibilityDetector(
                      key: const Key('testimonials-section'),
                      onVisibilityChanged: (info) {
                        if (info.visibleFraction > 0.45) {
                          Globals.activeSectionIndex.value = 3;
                        }
                      },
                      child: InternshipSection(),
                    ),
                    maxWidth: 1200.0,
                    topSpacing: ResponsiveHelper.getResponsiveValue<double>(
                      context,
                      mobile: 40.0,
                      tablet: 60.0,
                      desktop: 80.0,
                    ),
                  ),

// 6. EDUCATION SECTION (NEW - Add this section)
                  _buildSection(
                    context: context,
                    child: VisibilityDetector(
                      key: const Key('education-section'),
                      onVisibilityChanged: (info) {
                        if (info.visibleFraction > 0.45) {
                          Globals.activeSectionIndex.value = 4; // Update this index
                        }
                      },
                      child: EduSection(),
                    ),
                    maxWidth: 1200.0,
                    topSpacing: ResponsiveHelper.getResponsiveValue<double>(
                      context,
                      mobile: 40.0,
                      tablet: 60.0,
                      desktop: 80.0,
                    ),
                  ),

// 7. CV SECTION (existing - update the index)
                  _buildSection(
                    key: blogsKey,
                    context: context,
                    child: VisibilityDetector(
                      key: const Key('process-section'),
                      onVisibilityChanged: (info) {
                        if (info.visibleFraction > 0.45) {
                          Globals.activeSectionIndex.value = 5; // Updated from 4 to 5
                        }
                      },
                      child: CvSection(),
                    ),
                    maxWidth: 800.0,
                    topSpacing: ResponsiveHelper.getResponsiveValue<double>(
                      context,
                      mobile: 35.0,
                      tablet: 55.0,
                      desktop: 75.0,
                    ),
                  ),

// 8. FOOTER (existing - update the index)
                  Container(
                    key: contactKey,
                    width: double.infinity,
                    child: VisibilityDetector(
                      key: const Key('contact-section'),
                      onVisibilityChanged: (info) {
                        if (info.visibleFraction > 0.45) {
                          Globals.activeSectionIndex.value = 6; // Updated from 5 to 6
                        }
                      },
                      child: Footer(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 📱 ENHANCED: Centralized section builder with better organization
  Widget _buildSection({
    Key? key,
    required BuildContext context,
    required Widget child,
    required double maxWidth,
    double? topSpacing,
  }) {
    return Column(
      children: [
        if (topSpacing != null) SizedBox(height: topSpacing),
        Container(
          key: key,
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getResponsivePadding(context),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.isMobile(context) ? double.infinity : maxWidth,
            ),
            child: child,
          ),
        ),
      ],
    );
  }

  // 📱 ENHANCED: More organized drawer with consistent ResponsiveHelper usage
  Widget _buildDrawer(BuildContext context) {
    final padding = ResponsiveHelper.getResponsivePadding(context).clamp(16.0, 28.0);
    final fontSize = ResponsiveHelper.getResponsiveFontSize(
      context,
      mobile: 14.0,
      tablet: 15.0,
      desktop: 16.0,
    );
    final isMobile = ResponsiveHelper.isMobile(context);

    return Drawer(
      backgroundColor: Colors.white,
      elevation: 10.0,
      width: isMobile
          ? ResponsiveHelper.getWidthPercentage(context, 85)
          : 320.0,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: padding,
            vertical: isMobile ? 16.0 : 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drawer Header
              _buildDrawerHeader(context, fontSize, isMobile),

              // Navigation Items
              Expanded(
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return headerItems[index].isButton
                        ? _buildDrawerButton(context, index, fontSize, isMobile)
                        : _buildDrawerListItem(context, index, fontSize, isMobile);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: isMobile ? 10.0 : 12.0);
                  },
                  itemCount: headerItems.length,
                ),
              ),

              // Drawer Footer
              _buildDrawerFooter(context, fontSize, isMobile),
            ],
          ),
        ),
      ),
    );
  }

  // 📱 NEW: Separate drawer header widget for better organization
  Widget _buildDrawerHeader(BuildContext context, double fontSize, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 16.0 : 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 10.0 : 12.0,
              vertical: isMobile ? 6.0 : 8.0,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[600]!, Colors.purple[600]!],
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              "M.",
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize + (isMobile ? 6 : 8),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(height: isMobile ? 10.0 : 12.0),
          Text(
            "Navigation",
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          Container(
            width: isMobile ? 35.0 : 40.0,
            height: 3.0,
            margin: EdgeInsets.only(top: 8.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[600]!, Colors.purple[600]!],
              ),
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
        ],
      ),
    );
  }

  // 📱 NEW: Separate drawer footer widget
  Widget _buildDrawerFooter(BuildContext context, double fontSize, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 12.0 : 16.0),
      child: Row(
        children: [
          Icon(
            Icons.touch_app,
            color: Colors.grey[400],
            size: isMobile ? 14.0 : 16.0,
          ),
          SizedBox(width: 8.0),
          Flexible(
            child: Text(
              "Tap any item to navigate",
              style: TextStyle(
                fontSize: fontSize - 2,
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 📱 OPTIMIZED: More concise drawer button
  Widget _buildDrawerButton(BuildContext context, int index, double fontSize, bool isMobile) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange[500]!, Colors.red[500]!],
          ),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.orange[300]!.withOpacity(0.4),
              blurRadius: 15.0,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12.0),
            onTap: () {
              Navigator.pop(context);
              headerItems[index].onTap?.call();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16.0 : 20.0,
                vertical: isMobile ? 14.0 : 16.0,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.work_outline,
                    color: Colors.white,
                    size: fontSize + (isMobile ? 2 : 4),
                  ),
                  SizedBox(width: isMobile ? 10.0 : 12.0),
                  Expanded(
                    child: Text(
                      headerItems[index].title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: fontSize + 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 📱 OPTIMIZED: More concise drawer list item
  Widget _buildDrawerListItem(BuildContext context, int index, double fontSize, bool isMobile) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey[200]!, width: 1.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () {
            Navigator.pop(context);
            headerItems[index].onTap?.call();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16.0 : 20.0,
              vertical: isMobile ? 14.0 : 16.0,
            ),
            child: Row(
              children: [
                Container(
                  width: isMobile ? 5.0 : 6.0,
                  height: isMobile ? 5.0 : 6.0,
                  decoration: BoxDecoration(
                    color: Colors.blue[400],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: isMobile ? 14.0 : 16.0),
                Expanded(
                  child: Text(
                    headerItems[index].title,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                      fontSize: fontSize,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: fontSize - 2,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 📱 ENHANCED: Projects section with consistent styling
  Widget _buildProjectsSection(BuildContext context) {
    return Column(
      children: [
        // Section header
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getResponsivePadding(context),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.isMobile(context) ? double.infinity : 1200.0,
            ),
            child: _buildSectionHeader(
              context: context,
              title: "Featured Projects",
              subtitle: "Showcasing my latest work and technical capabilities",
            ),
          ),
        ),

        // Spacing
        SizedBox(
          height: ResponsiveHelper.getResponsiveValue<double>(
            context,
            mobile: 32.0,
            tablet: 50.0,
            desktop: 70.0,
          ),
        ),

        // App projects
        _buildResponsiveCarouselContainer(
          context: context,
          child: IOSAddApp(),
          semanticLabel: 'Mobile App Projects',
        ),

        // Spacing between carousels
        SizedBox(
          height: ResponsiveHelper.getResponsiveValue<double>(
            context,
            mobile: 40.0,
            tablet: 60.0,
            desktop: 80.0,
          ),
        ),

        // Website projects
        _buildResponsiveCarouselContainer(
          context: context,
          child: EnhancedWebsiteCarousel(),
          semanticLabel: 'Website Projects',
        ),
      ],
    );
  }

  // 📱 OPTIMIZED: Cleaner responsive carousel container
  Widget _buildResponsiveCarouselContainer({
    required BuildContext context,
    required Widget child,
    required String semanticLabel,
  }) {
    return Semantics(
      label: semanticLabel,
      child: Container(
        width: double.infinity,
        height: _getCarouselHeight(context),
        margin: _getCarouselMargin(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_getCarouselBorderRadius(context)),
          color: Colors.white,
          boxShadow: ResponsiveHelper.isMobile(context)
              ? null
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 25,
              offset: Offset(0, 6),
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_getCarouselBorderRadius(context)),
          child: child,
        ),
      ),
    );
  }

  // 📱 CONSISTENT: Section header with ResponsiveHelper
  Widget _buildSectionHeader({
    required BuildContext context,
    required String title,
    required String subtitle,
  }) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              mobile: 24.0,
              tablet: 28.0,
              desktop: 36.0,
            ),
            fontWeight: FontWeight.w800,
            color: Colors.grey[800],
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
        SizedBox(height: ResponsiveHelper.isMobile(context) ? 8.0 : 12.0),
        Container(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.isMobile(context) ? double.infinity : 600.0,
          ),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 14.0,
                tablet: 15.0,
                desktop: 17.0,
              ),
              color: Colors.grey[600],
              height: 1.5,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }
}