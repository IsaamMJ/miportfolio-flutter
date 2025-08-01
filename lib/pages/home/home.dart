import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../utils/constants.dart';
import '../../utils/globals.dart';
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

  // 📱 RESPONSIVE BREAKPOINTS
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1440.0;

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
    if (screenWidth >= desktopBreakpoint) return 120.0; // Large desktop
    if (screenWidth >= tabletBreakpoint) return 80.0;   // Desktop/tablet
    if (screenWidth >= mobileBreakpoint) return 40.0;   // Large mobile/small tablet
    return 20.0; // Mobile
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
  // Update the spacing in your Home widget's build method

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. HERO/INTRO - First Impression
                  Container(
                    key: homeKey,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: _getResponsivePadding(context),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: _isDesktop(context) ? 1200.0 : double.infinity,
                      ),
                      child: HeroSection(),
                    ),
                  ),

                  // 4. SKILLS - What You Can Do
                  SizedBox(height: _getResponsiveSpacing(context, mobile: 30.0, tablet: 40.0, desktop: 50.0)), // Reduced
                  Container(
                    key: servicesKey,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: _getResponsivePadding(context),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: _isDesktop(context) ? 1200.0 : double.infinity,
                      ),
                      child: SkillSection(),
                    ),
                  ),

                  // 5. PORTFOLIO STATS - Quick Credibility
                  SizedBox(height: _getResponsiveSpacing(context, mobile: 20.0, tablet: 30.0, desktop: 35.0)), // Reduced significantly
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: _getResponsivePadding(context),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: _isDesktop(context) ? 1000.0 : double.infinity,
                      ),
                      child: PortfolioStats(),
                    ),
                  ),

                  // 6. PROJECTS - Your Work in Action
                  SizedBox(height: _getResponsiveSpacing(context, mobile: 35.0, tablet: 45.0, desktop: 60.0)), // Reduced
                  Container(
                    key: portfolioKey,
                    child: _buildProjectsSection(context),
                  ),

                  // 7. EXPERIENCE - Professional Background
                  SizedBox(height: _getResponsiveSpacing(context, mobile: 35.0, tablet: 45.0, desktop: 60.0)), // Reduced
                  Container(
                    key: testimonialsKey,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: _getResponsivePadding(context),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: _isDesktop(context) ? 1200.0 : double.infinity,
                      ),
                      child: InternshipSection(),
                    ),
                  ),

                  // 8. EDUCATION - Academic Foundation
                  SizedBox(height: _getResponsiveSpacing(context, mobile: 35.0, tablet: 45.0, desktop: 60.0)), // Reduced
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: _getResponsivePadding(context),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: _isDesktop(context) ? 1200.0 : double.infinity,
                      ),
                      child: EduSection(),
                    ),
                  ),

                  // 9. CV DOWNLOAD - After Showcasing Value
                  SizedBox(height: _getResponsiveSpacing(context, mobile: 30.0, tablet: 40.0, desktop: 50.0)), // Reduced
                  Container(
                    key: blogsKey,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: _getResponsivePadding(context),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: _isDesktop(context) ? 800.0 : double.infinity,
                      ),
                      child: CvSection(),
                    ),
                  ),

                  // 10. FOOTER - Contact & Social Links
                  SizedBox(height: _getResponsiveSpacing(context, mobile: 35.0, tablet: 45.0, desktop: 60.0)), // Reduced
                  Container(
                    key: contactKey,
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
        // Section header with responsive padding
        Container(
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

        SizedBox(height: _getResponsiveSpacing(context, mobile: 30.0, tablet: 40.0, desktop: 50.0)),

        // App project section with responsive height
        _buildResponsiveCarouselContainer(
          context: context,
          child: AppCarousel(),
          semanticLabel: 'Mobile App Projects',
        ),

        SizedBox(height: _getResponsiveSpacing(context, mobile: 20.0, tablet: 25.0, desktop: 30.0)),

        // Website project section with responsive height
        _buildResponsiveCarouselContainer(
          context: context,
          child: WebsiteCarousel(),
          semanticLabel: 'Website Projects',
        ),
      ],
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
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Enhanced responsive height calculation
    double carouselHeight;
    if (_isDesktop(context)) {
      carouselHeight = screenHeight * 0.65; // Desktop - show more content
    } else if (_isTablet(context)) {
      carouselHeight = screenHeight * 0.55; // Tablet - balanced view
    } else {
      carouselHeight = screenHeight * 0.45; // Mobile - compact view
    }

    // Improved height constraints based on device
    if (_isMobile(context)) {
      carouselHeight = carouselHeight.clamp(350.0, 500.0);
    } else if (_isTablet(context)) {
      carouselHeight = carouselHeight.clamp(400.0, 650.0);
    } else {
      carouselHeight = carouselHeight.clamp(450.0, 800.0);
    }

    return Semantics(
      label: semanticLabel,
      child: Container(
        height: carouselHeight,
        width: double.infinity,
        child: child,
      ),
    );
  }
}