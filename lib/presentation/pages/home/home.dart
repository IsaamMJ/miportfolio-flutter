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

  // 📱 ENHANCED RESPONSIVE BREAKPOINTS
  static const double _extraSmallBreakpoint = 320.0;  // Very small phones
  static const double _smallBreakpoint = 576.0;       // Small phones
  static const double _mediumBreakpoint = 768.0;      // Tablets
  static const double _largeBreakpoint = 992.0;       // Small desktops
  static const double _extraLargeBreakpoint = 1200.0; // Large desktops
  static const double _xxlBreakpoint = 1400.0;        // Extra large screens

  // 📱 DEVICE TYPE DETECTION
  bool _isExtraSmall(BuildContext context) => MediaQuery.of(context).size.width < _extraSmallBreakpoint;
  bool _isSmall(BuildContext context) => MediaQuery.of(context).size.width >= _extraSmallBreakpoint && MediaQuery.of(context).size.width < _smallBreakpoint;
  bool _isMobile(BuildContext context) => MediaQuery.of(context).size.width < _mediumBreakpoint;
  bool _isTablet(BuildContext context) => MediaQuery.of(context).size.width >= _mediumBreakpoint && MediaQuery.of(context).size.width < _largeBreakpoint;
  bool _isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= _largeBreakpoint && MediaQuery.of(context).size.width < _extraLargeBreakpoint;
  bool _isLargeDesktop(BuildContext context) => MediaQuery.of(context).size.width >= _extraLargeBreakpoint && MediaQuery.of(context).size.width < _xxlBreakpoint;
  bool _isExtraLargeDesktop(BuildContext context) => MediaQuery.of(context).size.width >= _xxlBreakpoint;

  // 📏 ENHANCED RESPONSIVE SPACING UTILITIES
  double _getResponsiveSpacing(BuildContext context, {
    double extraSmall = 12.0,
    double small = 16.0,
    double mobile = 20.0,
    double tablet = 32.0,
    double desktop = 48.0,
    double large = 60.0,
    double extraLarge = 80.0,
  }) {
    if (_isExtraLargeDesktop(context)) return extraLarge;
    if (_isLargeDesktop(context)) return large;
    if (_isDesktop(context)) return desktop;
    if (_isTablet(context)) return tablet;
    if (_isSmall(context)) return small;
    if (_isExtraSmall(context)) return extraSmall;
    return mobile;
  }

  double _getResponsivePadding(BuildContext context) {
    if (_isExtraLargeDesktop(context)) return 140.0;
    if (_isLargeDesktop(context)) return 120.0;
    if (_isDesktop(context)) return 100.0;
    if (_isTablet(context)) return 80.0;
    if (_isSmall(context)) return 20.0;
    if (_isExtraSmall(context)) return 16.0;
    return 24.0;
  }

  double _getResponsiveFontSize(BuildContext context, {
    double extraSmall = 12.0,
    double small = 13.0,
    double mobile = 14.0,
    double tablet = 16.0,
    double desktop = 18.0,
    double large = 20.0,
    double extraLarge = 22.0,
  }) {
    if (_isExtraLargeDesktop(context)) return extraLarge;
    if (_isLargeDesktop(context)) return large;
    if (_isDesktop(context)) return desktop;
    if (_isTablet(context)) return tablet;
    if (_isSmall(context)) return small;
    if (_isExtraSmall(context)) return extraSmall;
    return mobile;
  }

  // 📱 RESPONSIVE CAROUSEL HEIGHT CALCULATION
  double _getCarouselHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Ensure minimum height while being responsive
    double baseHeight;

    if (_isExtraSmall(context)) {
      baseHeight = screenHeight * 0.65; // 65% for very small screens
    } else if (_isMobile(context)) {
      baseHeight = screenHeight * 0.7;  // 70% for mobile
    } else if (_isTablet(context)) {
      baseHeight = screenHeight * 0.75; // 75% for tablets
    } else {
      baseHeight = screenHeight * 0.8;  // 80% for desktop
    }

    // Ensure reasonable minimum and maximum heights
    final minHeight = _isExtraSmall(context) ? 400.0 : _isMobile(context) ? 450.0 : 500.0;
    final maxHeight = _isExtraLargeDesktop(context) ? 900.0 : 800.0;

    return baseHeight.clamp(minHeight, maxHeight);
  }

  EdgeInsets _getCarouselMargin(BuildContext context) {
    if (_isExtraSmall(context)) return EdgeInsets.zero;
    if (_isMobile(context)) return EdgeInsets.symmetric(horizontal: 8);
    if (_isTablet(context)) return EdgeInsets.symmetric(horizontal: 16);
    return EdgeInsets.symmetric(horizontal: 24);
  }

  double _getCarouselBorderRadius(BuildContext context) {
    if (_isExtraSmall(context)) return 0;
    if (_isMobile(context)) return 8;
    if (_isTablet(context)) return 12;
    return 16;
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

          // 📜 SCROLLABLE CONTENT - Enhanced overflow handling
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. HERO/INTRO - First Impression
                  _buildSection(
                    key: homeKey,
                    context: context,
                    child: HeroSection(),
                    maxWidth: 1200.0,
                  ),

                  // 2. SKILLS - What You Can Do
                  _buildSection(
                    key: servicesKey,
                    context: context,
                    child: SkillSection(),
                    maxWidth: 1200.0,
                    topSpacing: _getResponsiveSpacing(
                      context,
                      extraSmall: 20.0,
                      small: 24.0,
                      mobile: 30.0,
                      tablet: 40.0,
                      desktop: 50.0,
                      large: 60.0,
                      extraLarge: 70.0,
                    ),
                  ),

                  // 3. PORTFOLIO STATS - Quick Credibility
                  _buildSection(
                    context: context,
                    child: PortfolioStats(),
                    maxWidth: 1000.0,
                    topSpacing: _getResponsiveSpacing(
                      context,
                      extraSmall: 16.0,
                      small: 20.0,
                      mobile: 24.0,
                      tablet: 32.0,
                      desktop: 40.0,
                      large: 45.0,
                      extraLarge: 50.0,
                    ),
                  ),

                  // 4. PROJECTS - Your Work in Action
                  SizedBox(
                    height: _getResponsiveSpacing(
                      context,
                      extraSmall: 30.0,
                      small: 35.0,
                      mobile: 40.0,
                      tablet: 50.0,
                      desktop: 60.0,
                      large: 70.0,
                      extraLarge: 80.0,
                    ),
                  ),
                  Container(
                    key: portfolioKey,
                    width: double.infinity,
                    child: _buildProjectsSection(context),
                  ),

                  // 5. EXPERIENCE - Professional Background
                  _buildSection(
                    key: testimonialsKey,
                    context: context,
                    child: InternshipSection(),
                    maxWidth: 1200.0,
                    topSpacing: _getResponsiveSpacing(
                      context,
                      extraSmall: 30.0,
                      small: 35.0,
                      mobile: 40.0,
                      tablet: 50.0,
                      desktop: 60.0,
                      large: 70.0,
                      extraLarge: 80.0,
                    ),
                  ),

                  // 6. EDUCATION - Academic Foundation
                  _buildSection(
                    context: context,
                    child: EduSection(),
                    maxWidth: 1200.0,
                    topSpacing: _getResponsiveSpacing(
                      context,
                      extraSmall: 30.0,
                      small: 35.0,
                      mobile: 40.0,
                      tablet: 50.0,
                      desktop: 60.0,
                      large: 70.0,
                      extraLarge: 80.0,
                    ),
                  ),

                  // 7. CV DOWNLOAD - After Showcasing Value
                  _buildSection(
                    key: blogsKey,
                    context: context,
                    child: CvSection(),
                    maxWidth: 800.0,
                    topSpacing: _getResponsiveSpacing(
                      context,
                      extraSmall: 25.0,
                      small: 30.0,
                      mobile: 35.0,
                      tablet: 45.0,
                      desktop: 55.0,
                      large: 65.0,
                      extraLarge: 75.0,
                    ),
                  ),

                  // 8. FOOTER - Contact & Social Links
                  SizedBox(
                    height: _getResponsiveSpacing(
                      context,
                      extraSmall: 30.0,
                      small: 35.0,
                      mobile: 40.0,
                      tablet: 50.0,
                      desktop: 60.0,
                      large: 70.0,
                      extraLarge: 80.0,
                    ),
                  ),
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

  // ENHANCED: Centralized section builder with better responsive handling
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
              maxWidth: _isMobile(context) ? double.infinity : maxWidth,
            ),
            child: child,
          ),
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final responsivePadding = _getResponsivePadding(context).clamp(16.0, 28.0);
    final responsiveFontSize = _getResponsiveFontSize(
      context,
      extraSmall: 12.0,
      small: 13.0,
      mobile: 14.0,
      tablet: 15.0,
      desktop: 16.0,
    );

    return Drawer(
      backgroundColor: Colors.white,
      elevation: 10.0,
      width: _isExtraSmall(context)
          ? MediaQuery.of(context).size.width * 0.9
          : _isMobile(context)
          ? MediaQuery.of(context).size.width * 0.85
          : 320.0,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsivePadding,
            vertical: _isExtraSmall(context) ? 16.0 : 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drawer Header
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: _isExtraSmall(context) ? 16.0 : 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: _isExtraSmall(context) ? 10.0 : 12.0,
                        vertical: _isExtraSmall(context) ? 6.0 : 8.0,
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
                          fontSize: responsiveFontSize + (_isExtraSmall(context) ? 6 : 8),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SizedBox(height: _isExtraSmall(context) ? 10.0 : 12.0),
                    Text(
                      "Navigation",
                      style: TextStyle(
                        fontSize: responsiveFontSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    Container(
                      width: _isExtraSmall(context) ? 35.0 : 40.0,
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
                    return SizedBox(height: _isExtraSmall(context) ? 10.0 : 12.0);
                  },
                  itemCount: headerItems.length,
                ),
              ),

              // Drawer Footer
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: _isExtraSmall(context) ? 12.0 : 16.0,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.touch_app,
                      color: Colors.grey[400],
                      size: _isExtraSmall(context) ? 14.0 : 16.0,
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
    final responsiveFontSize = _getResponsiveFontSize(
      context,
      extraSmall: 12.0,
      small: 13.0,
      mobile: 14.0,
      tablet: 15.0,
      desktop: 16.0,
    );

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
                horizontal: _isExtraSmall(context) ? 16.0 : 20.0,
                vertical: _isExtraSmall(context) ? 14.0 : 16.0,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.work_outline,
                    color: Colors.white,
                    size: responsiveFontSize + (_isExtraSmall(context) ? 2 : 4),
                  ),
                  SizedBox(width: _isExtraSmall(context) ? 10.0 : 12.0),
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
    final responsiveFontSize = _getResponsiveFontSize(
      context,
      extraSmall: 12.0,
      small: 13.0,
      mobile: 14.0,
      tablet: 15.0,
      desktop: 16.0,
    );

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
              horizontal: _isExtraSmall(context) ? 16.0 : 20.0,
              vertical: _isExtraSmall(context) ? 14.0 : 16.0,
            ),
            child: Row(
              children: [
                Container(
                  width: _isExtraSmall(context) ? 5.0 : 6.0,
                  height: _isExtraSmall(context) ? 5.0 : 6.0,
                  decoration: BoxDecoration(
                    color: Colors.blue[400],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: _isExtraSmall(context) ? 14.0 : 16.0),
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

  // ENHANCED: Projects section with perfect responsive carousel management
  Widget _buildProjectsSection(BuildContext context) {
    return Column(
      children: [
        // Section header with proper constraints
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: _getResponsivePadding(context)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: _isMobile(context) ? double.infinity : 1200.0,
            ),
            child: _buildSectionHeader(
              context: context,
              title: "Featured Projects",
              subtitle: "Showcasing my latest work and technical capabilities",
            ),
          ),
        ),

        // Responsive spacing between header and carousels
        SizedBox(
          height: _getResponsiveSpacing(
            context,
            extraSmall: 24.0,
            small: 28.0,
            mobile: 32.0,
            tablet: 40.0,
            desktop: 50.0,
            large: 60.0,
            extraLarge: 70.0,
          ),
        ),

        // App project section with enhanced responsive container
        _buildResponsiveCarouselContainer(
          context: context,
          child: IOSAddApp(),
          semanticLabel: 'Mobile App Projects',
        ),

        // Responsive spacing between carousels
        SizedBox(
          height: _getResponsiveSpacing(
            context,
            extraSmall: 32.0,
            small: 36.0,
            mobile: 40.0,
            tablet: 50.0,
            desktop: 60.0,
            large: 70.0,
            extraLarge: 80.0,
          ),
        ),

        // Website project section with enhanced responsive container
        _buildResponsiveCarouselContainer(
          context: context,
          child: EnhancedWebsiteCarousel(),
          semanticLabel: 'Website Projects',
        ),
      ],
    );
  }

  // ENHANCED: Responsive carousel container with perfect height and margin management
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
          boxShadow: _isMobile(context)
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
            fontSize: _isExtraSmall(context)
                ? 20.0
                : _isSmall(context)
                ? 22.0
                : _isMobile(context)
                ? 24.0
                : _isTablet(context)
                ? 28.0
                : _isDesktop(context)
                ? 32.0
                : _isLargeDesktop(context)
                ? 36.0
                : 40.0,
            fontWeight: FontWeight.w800,
            color: Colors.grey[800],
            letterSpacing: -0.5,
            height: 1.2,
          ),
        ),
        SizedBox(height: _isExtraSmall(context) ? 8.0 : 12.0),
        Container(
          constraints: BoxConstraints(
            maxWidth: _isExtraSmall(context)
                ? double.infinity
                : _isMobile(context)
                ? 400.0
                : 600.0,
          ),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: _getResponsiveFontSize(
                context,
                extraSmall: 12.0,
                small: 13.0,
                mobile: 14.0,
                tablet: 15.0,
                desktop: 16.0,
                large: 17.0,
                extraLarge: 18.0,
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