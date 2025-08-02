import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../utils/globals.dart';
import 'components/hero_section.dart';
import 'components/cv_section.dart';
import 'components/internship_section.dart';
import 'components/footer.dart';
import 'components/header.dart';
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

  // 📱 CONSISTENT RESPONSIVE BREAKPOINTS
  static const double mobileBreakpoint = 768.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1200.0;

  // 📏 RESPONSIVE SPACING UTILITIES
  double _getResponsiveSpacing(BuildContext context, {
    double mobile = 20.0,
    double tablet = 40.0,
    double desktop = 60.0,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= tabletBreakpoint) return desktop;
    if (screenWidth >= mobileBreakpoint) return tablet;
    return mobile;
  }

  double _getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= desktopBreakpoint) return 120.0;
    if (screenWidth >= tabletBreakpoint) return 80.0;
    if (screenWidth >= mobileBreakpoint) return 40.0;
    return 24.0;
  }

  double _getResponsiveFontSize(BuildContext context, {
    double mobile = 14.0,
    double tablet = 16.0,
    double desktop = 18.0,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= tabletBreakpoint) return desktop;
    if (screenWidth >= mobileBreakpoint) return tablet;
    return mobile;
  }

  // Fixed: Better carousel spacing calculation
  double _getCarouselSpacing(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= desktopBreakpoint) return 60.0;
    if (screenWidth >= tabletBreakpoint) return 40.0;
    if (screenWidth >= mobileBreakpoint) return 30.0;
    return 20.0;
  }

  // 📱 DEVICE TYPE DETECTION
  bool _isMobile(BuildContext context) => MediaQuery.of(context).size.width < mobileBreakpoint;
  bool _isTablet(BuildContext context) => MediaQuery.of(context).size.width >= mobileBreakpoint && MediaQuery.of(context).size.width < tabletBreakpoint;
  bool _isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= tabletBreakpoint;

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

          // 📜 SCROLLABLE CONTENT - Fixed: Better overflow handling
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: ClampingScrollPhysics(), // Fixed: Better scroll physics
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. HERO/INTRO - First Impression
                  _buildSection(
                    key: homeKey,
                    context: context,
                    child: HeroSection(),
                    maxWidth: 1200.0,
                  ),

                  // 4. SKILLS - What You Can Do
                  _buildSection(
                    key: servicesKey,
                    context: context,
                    child: SkillSection(),
                    maxWidth: 1200.0,
                    topSpacing: _getResponsiveSpacing(context, mobile: 30.0, tablet: 40.0, desktop: 50.0),
                  ),

                  // 5. PORTFOLIO STATS - Quick Credibility
                  _buildSection(
                    context: context,
                    child: PortfolioStats(),
                    maxWidth: 1000.0,
                    topSpacing: _getResponsiveSpacing(context, mobile: 20.0, tablet: 30.0, desktop: 35.0),
                  ),

                  // 6. PROJECTS - Your Work in Action - Fixed: Better container management
                  SizedBox(height: _getResponsiveSpacing(context, mobile: 40.0, tablet: 50.0, desktop: 70.0)),
                  Container(
                    key: portfolioKey,
                    width: double.infinity,
                    child: _buildProjectsSection(context),
                  ),

                  // 7. EXPERIENCE - Professional Background
                  _buildSection(
                    key: testimonialsKey,
                    context: context,
                    child: InternshipSection(),
                    maxWidth: 1200.0,
                    topSpacing: _getResponsiveSpacing(context, mobile: 35.0, tablet: 45.0, desktop: 60.0),
                  ),

                  // 8. EDUCATION - Academic Foundation
                  _buildSection(
                    context: context,
                    child: EduSection(),
                    maxWidth: 1200.0,
                    topSpacing: _getResponsiveSpacing(context, mobile: 35.0, tablet: 45.0, desktop: 60.0),
                  ),

                  // 9. CV DOWNLOAD - After Showcasing Value
                  _buildSection(
                    key: blogsKey,
                    context: context,
                    child: CvSection(),
                    maxWidth: 800.0,
                    topSpacing: _getResponsiveSpacing(context, mobile: 30.0, tablet: 40.0, desktop: 50.0),
                  ),

                  // 10. FOOTER - Contact & Social Links - Fixed: No padding needed
                  SizedBox(height: _getResponsiveSpacing(context, mobile: 35.0, tablet: 45.0, desktop: 60.0)),
                  Container(
                    key: contactKey,
                    width: double.infinity,
                    child: Footer(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fixed: Centralized section builder to ensure consistent spacing and layout
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
            horizontal: _getResponsivePadding(context),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: _isDesktop(context) ? maxWidth : double.infinity,
            ),
            child: child,
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final responsivePadding = _getResponsivePadding(context).clamp(16.0, 24.0);
    final responsiveFontSize = _getResponsiveFontSize(context, mobile: 14.0, tablet: 15.0, desktop: 16.0);

    return Drawer(
      backgroundColor: Colors.white,
      elevation: 10.0,
      width: _isMobile(context) ? MediaQuery.of(context).size.width * 0.85 : 300.0,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsivePadding, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drawer Header
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
                          fontSize: responsiveFontSize + 8,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      "Navigation",
                      style: TextStyle(
                        fontSize: responsiveFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    Container(
                      width: 40.0,
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
              ),

              // Navigation Items
              Expanded(
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return headerItems[index].isButton
                        ? _buildDrawerButton(context, index)
                        : _buildDrawerListItem(context, index);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 12.0);
                  },
                  itemCount: headerItems.length,
                ),
              ),

              // Drawer Footer
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.touch_app,
                      color: Colors.grey[400],
                      size: 16.0,
                    ),
                    SizedBox(width: 8.0),
                    Flexible(
                      child: Text(
                        "Tap any item to navigate",
                        style: TextStyle(
                          fontSize: responsiveFontSize - 2,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerButton(BuildContext context, int index) {
    final responsiveFontSize = _getResponsiveFontSize(context, mobile: 14.0, tablet: 15.0, desktop: 16.0);

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
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.work_outline,
                    color: Colors.white,
                    size: responsiveFontSize + 4,
                  ),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      headerItems[index].title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsiveFontSize,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: responsiveFontSize + 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerListItem(BuildContext context, int index) {
    final responsiveFontSize = _getResponsiveFontSize(context, mobile: 14.0, tablet: 15.0, desktop: 16.0);

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
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Row(
              children: [
                Container(
                  width: 6.0,
                  height: 6.0,
                  decoration: BoxDecoration(
                    color: Colors.blue[400],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    headerItems[index].title,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                      fontSize: responsiveFontSize,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: responsiveFontSize - 2,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectsSection(BuildContext context) {
    return Column(
      children: [
        // Section header with proper constraints
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: _getResponsivePadding(context)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: _isDesktop(context) ? 1200.0 : double.infinity,
            ),
            child: _buildSectionHeader(
              context: context,
              title: "Featured Projects",
              subtitle: "Showcasing my latest work and technical capabilities",
            ),
          ),
        ),

        // Better spacing between header and carousels
        SizedBox(height: _getResponsiveSpacing(context, mobile: 30.0, tablet: 40.0, desktop: 50.0)),

        // App project section - FIXED: Simple container without complex height calculations
        _buildSimpleCarouselContainer(
          context: context,
          child: IOSAddApp(),
          semanticLabel: 'Mobile App Projects',
        ),

        // Better spacing between carousels
        SizedBox(height: _getResponsiveSpacing(context, mobile: 40.0, tablet: 50.0, desktop: 60.0)),

        // Website project section - FIXED: Simple container without complex height calculations
        _buildSimpleCarouselContainer(
          context: context,
          child: WebsiteCarousel(),
          semanticLabel: 'Website Projects',
        ),
      ],
    );
  }
  Widget _buildSimpleCarouselContainer({
    required BuildContext context,
    required Widget child,
    required String semanticLabel,
  }) {
    return Semantics(
      label: semanticLabel,
      child: Container(
        width: double.infinity,
        // FIXED: Use a simple, reasonable height instead of complex calculations
        height: _isMobile(context) ? 500.0 : _isTablet(context) ? 600.0 : 700.0,
        margin: EdgeInsets.symmetric(
          horizontal: _isMobile(context) ? 0 : 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_isMobile(context) ? 0 : 16),
          color: Colors.white,
          boxShadow: _isMobile(context) ? null : [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_isMobile(context) ? 0 : 16),
          child: child, // The carousel content will fit within this container
        ),
      ),
    );
  }

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
            fontSize: _isMobile(context) ? 24.0 : _isTablet(context) ? 28.0 : 32.0,
            fontWeight: FontWeight.w800,
            color: Colors.grey[800],
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 12.0),
        Container(
          constraints: BoxConstraints(
            maxWidth: _isMobile(context) ? double.infinity : 600.0,
          ),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: _getResponsiveFontSize(context, mobile: 14.0, tablet: 15.0, desktop: 16.0),
              color: Colors.grey[600],
              height: 1.5,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResponsiveCarouselContainer({
    required BuildContext context,
    required Widget child,
    required String semanticLabel,
    required bool isIOSApp,
  }) {
    // Fixed: Better height calculation strategy
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate optimal carousel height based on content type and screen size
    double carouselHeight;

    if (isIOSApp) {
      // iOS App carousel - more compact
      if (_isDesktop(context)) {
        carouselHeight = screenHeight * 0.7;
      } else if (_isTablet(context)) {
        carouselHeight = screenHeight * 0.6;
      } else {
        carouselHeight = screenHeight * 0.5;
      }
      // Clamp iOS app heights
      carouselHeight = carouselHeight.clamp(400.0, 700.0);
    } else {
      // Website carousel - can be larger
      if (_isDesktop(context)) {
        carouselHeight = screenHeight * 0.8;
      } else if (_isTablet(context)) {
        carouselHeight = screenHeight * 0.7;
      } else {
        carouselHeight = screenHeight * 0.6;
      }
      // Clamp website carousel heights
      carouselHeight = carouselHeight.clamp(450.0, 800.0);
    }

    // Fixed: Better decoration and spacing
    return Semantics(
      label: semanticLabel,
      child: Container(
        height: carouselHeight,
        width: double.infinity,
        margin: EdgeInsets.symmetric(
          horizontal: _isMobile(context) ? 0 : 20, // Add margin only on larger screens
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_isMobile(context) ? 0 : 16),
          boxShadow: _isMobile(context) ? null : [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_isMobile(context) ? 0 : 16),
          child: Container(
            // Fixed: Add subtle background for better separation
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_isMobile(context) ? 0 : 16),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}