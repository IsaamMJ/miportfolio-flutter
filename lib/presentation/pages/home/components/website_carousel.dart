// Enhanced Website Carousel Component - iOS App Style
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

// Import your existing data classes
import '../../../../data/models/website_data.dart';
import '../../../../data/repositories/portfolio_repository_impl.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/screen_helper.dart';

class EnhancedWebsiteCarousel extends StatefulWidget {
  const EnhancedWebsiteCarousel({Key? key}) : super(key: key);

  @override
  State<EnhancedWebsiteCarousel> createState() => _EnhancedWebsiteCarouselState();
}

class _EnhancedWebsiteCarouselState extends State<EnhancedWebsiteCarousel> with TickerProviderStateMixin {
  int currentPage = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<WebsiteData> _websites = PortfolioRepository().getWebsites();

  // 📱 RESPONSIVE UTILITIES - Enhanced for all screen sizes
  bool _isMobile(BuildContext context) => MediaQuery.of(context).size.width < 768.0;
  bool _isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 768.0 && MediaQuery.of(context).size.width < 1024.0;
  bool _isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1024.0;
  bool _isLargeDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1440.0;
  bool _isUltraWide(BuildContext context) => MediaQuery.of(context).size.width >= 1920.0;

  // Enhanced responsive sizing
  double _getResponsiveValue(BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
    double? largeDesktop,
    double? ultraWide,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1920 && ultraWide != null) return ultraWide;
    if (width >= 1440 && largeDesktop != null) return largeDesktop;
    if (width >= 1024) return desktop;
    if (width >= 768) return tablet;
    return mobile;
  }

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    Future.delayed(Duration(seconds: 8), () {
      if (mounted) {
        _nextPage();
        _startAutoPlay();
      }
    });
  }

  void _nextPage() {
    _goToPage((currentPage + 1) % _websites.length);
  }

  void _goToPage(int page) {
    if (page != currentPage && _websites.isNotEmpty) {
      _fadeController.reverse().then((_) {
        if (mounted) {
          setState(() {
            currentPage = page;
          });
          _fadeController.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_websites.isEmpty) {
      return Container(
        child: Center(
          child: Text(
            'No websites available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: double.infinity, // Fill the container provided by parent
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[50]!, Colors.white, Colors.grey[100]!],
        ),
      ),
      child: Stack(
        fit: StackFit.expand, // Important: makes stack fill the container
        children: [
          // Background pattern
          CustomPaint(painter: BackgroundPatternPainter()),

          // Main layout - SIMPLE AND CLEAN
          Column(
            children: [
              // Main content area with responsive padding
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(_getResponsiveValue(
                    context,
                    mobile: 16.0,
                    tablet: 20.0,
                    desktop: 24.0,
                    largeDesktop: 32.0,
                  )),
                  child: Row(
                    children: [
                      // Left nav button (tablet+ only)
                      if (!_isMobile(context)) ...[
                        _buildNavButton(
                          Icons.arrow_back_ios,
                              () => _goToPage((currentPage - 1 + _websites.length) % _websites.length),
                        ),
                        SizedBox(width: _getResponsiveValue(
                          context,
                          mobile: 16.0,
                          tablet: 20.0,
                          desktop: 24.0,
                          largeDesktop: 32.0,
                        )),
                      ],

                      // Main content - NO SCROLLING WIDGETS
                      Expanded(
                        child: GestureDetector(
                          // Swipe gestures for mobile
                          onPanEnd: _isMobile(context) ? (details) {
                            final velocity = details.velocity.pixelsPerSecond.dx;
                            if (velocity.abs() > 500) {
                              if (velocity > 0) {
                                // Swipe right - previous
                                _goToPage((currentPage - 1 + _websites.length) % _websites.length);
                              } else {
                                // Swipe left - next
                                _nextPage();
                              }
                            }
                          } : null,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: EnhancedWebsiteAd(
                                websiteData: _websites[currentPage],
                                onNext: _nextPage,
                                onPrevious: () => _goToPage((currentPage - 1 + _websites.length) % _websites.length),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Right nav button (tablet+ only)
                      if (!_isMobile(context)) ...[
                        SizedBox(width: _getResponsiveValue(
                          context,
                          mobile: 16.0,
                          tablet: 20.0,
                          desktop: 24.0,
                          largeDesktop: 32.0,
                        )),
                        _buildNavButton(Icons.arrow_forward_ios, _nextPage),
                      ],
                    ],
                  ),
                ),
              ),

              // Bottom section - Responsive height for indicators
              Container(
                height: _getResponsiveValue(
                  context,
                  mobile: 70.0,
                  tablet: 80.0,
                  desktop: 85.0,
                  largeDesktop: 90.0,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: _getResponsiveValue(
                    context,
                    mobile: 16.0,
                    tablet: 20.0,
                    desktop: 24.0,
                    largeDesktop: 32.0,
                  ),
                  vertical: _getResponsiveValue(
                    context,
                    mobile: 12.0,
                    tablet: 16.0,
                    desktop: 18.0,
                    largeDesktop: 20.0,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Mobile swipe hint with responsive sizing
                    if (_isMobile(context))
                      Container(
                        margin: EdgeInsets.only(bottom: _getResponsiveValue(
                          context,
                          mobile: 8.0,
                          tablet: 12.0,
                          desktop: 12.0,
                        )),
                        padding: EdgeInsets.symmetric(
                          horizontal: _getResponsiveValue(
                            context,
                            mobile: 10.0,
                            tablet: 12.0,
                            desktop: 12.0,
                          ),
                          vertical: _getResponsiveValue(
                            context,
                            mobile: 3.0,
                            tablet: 4.0,
                            desktop: 4.0,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                                Icons.swipe_left,
                                size: _getResponsiveValue(
                                  context,
                                  mobile: 10.0,
                                  tablet: 12.0,
                                  desktop: 12.0,
                                ),
                                color: Colors.grey[600]
                            ),
                            SizedBox(width: 4),
                            Text(
                              "Swipe to explore",
                              style: GoogleFonts.inter(
                                color: Colors.grey[600],
                                fontSize: _getResponsiveValue(
                                  context,
                                  mobile: 9.0,
                                  tablet: 10.0,
                                  desktop: 10.0,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Indicators row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Website category with responsive sizing
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: _getResponsiveValue(
                              context,
                              mobile: 6.0,
                              tablet: 8.0,
                              desktop: 10.0,
                              largeDesktop: 12.0,
                            ),
                            vertical: _getResponsiveValue(
                              context,
                              mobile: 2.0,
                              tablet: 2.0,
                              desktop: 3.0,
                              largeDesktop: 4.0,
                            ),
                          ),
                          margin: EdgeInsets.only(right: _getResponsiveValue(
                            context,
                            mobile: 8.0,
                            tablet: 10.0,
                            desktop: 12.0,
                            largeDesktop: 16.0,
                          )),
                          decoration: BoxDecoration(
                            color: _websites[currentPage].themeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _websites[currentPage].themeColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _websites[currentPage].category.toUpperCase(),
                            style: GoogleFonts.inter(
                              color: _websites[currentPage].themeColor,
                              fontSize: _getResponsiveValue(
                                context,
                                mobile: 9.0,
                                tablet: 10.0,
                                desktop: 11.0,
                                largeDesktop: 12.0,
                              ),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        // Dot indicators with responsive sizing
                        ...List.generate(
                          _websites.length,
                              (index) => GestureDetector(
                            onTap: () => _goToPage(index),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(horizontal: _getResponsiveValue(
                                context,
                                mobile: 1.5,
                                tablet: 2.0,
                                desktop: 2.5,
                                largeDesktop: 3.0,
                              )),
                              width: currentPage == index ? _getResponsiveValue(
                                context,
                                mobile: 16.0,
                                tablet: 20.0,
                                desktop: 24.0,
                                largeDesktop: 28.0,
                              ) : _getResponsiveValue(
                                context,
                                mobile: 5.0,
                                tablet: 6.0,
                                desktop: 7.0,
                                largeDesktop: 8.0,
                              ),
                              height: _getResponsiveValue(
                                context,
                                mobile: 5.0,
                                tablet: 6.0,
                                desktop: 7.0,
                                largeDesktop: 8.0,
                              ),
                              decoration: BoxDecoration(
                                color: currentPage == index
                                    ? _websites[currentPage].themeColor
                                    : _websites[currentPage].themeColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onPressed) {
    final buttonSize = _getResponsiveValue(
      context,
      mobile: 40.0,
      tablet: 48.0,
      desktop: 52.0,
      largeDesktop: 56.0,
    );

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(buttonSize / 2),
        border: Border.all(color: _websites[currentPage].themeColor.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: _getResponsiveValue(
              context,
              mobile: 8.0,
              tablet: 10.0,
              desktop: 12.0,
              largeDesktop: 15.0,
            ),
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(buttonSize / 2),
          onTap: onPressed,
          child: Center(
            child: Icon(
              icon,
              color: _websites[currentPage].themeColor,
              size: _getResponsiveValue(
                context,
                mobile: 16.0,
                tablet: 18.0,
                desktop: 20.0,
                largeDesktop: 22.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Enhanced Website Ad Widget - FIXED OVERFLOW ISSUES
class EnhancedWebsiteAd extends StatelessWidget {
  final WebsiteData websiteData;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const EnhancedWebsiteAd({
    required this.websiteData,
    required this.onNext,
    required this.onPrevious,
  });

  Future<void> _launchUrl() async {
    try {
      final Uri url = Uri.parse(websiteData.websiteUrl);
      if (await canLaunchUrl(url)) {
        HapticFeedback.lightImpact();
        await launchUrl(url, webOnlyWindowName: '_blank');
      }
    } catch (e) {
      print('Could not launch ${websiteData.websiteUrl}');
    }
  }

  // 📱 RESPONSIVE UTILITIES for EnhancedWebsiteAd
  bool _isMobile(BuildContext context) => MediaQuery.of(context).size.width < 768.0;
  bool _isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 768.0 && MediaQuery.of(context).size.width < 1024.0;
  bool _isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1024.0;
  bool _isLargeDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1440.0;
  bool _isUltraWide(BuildContext context) => MediaQuery.of(context).size.width >= 1920.0;

  // Enhanced responsive sizing for EnhancedWebsiteAd
  double _getResponsiveValue(BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
    double? largeDesktop,
    double? ultraWide,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1920 && ultraWide != null) return ultraWide;
    if (width >= 1440 && largeDesktop != null) return largeDesktop;
    if (width >= 1024) return desktop;
    if (width >= 768) return tablet;
    return mobile;
  }

  double _getResponsiveSize(BuildContext context, double mobile, double tablet, double desktop) {
    return _getResponsiveValue(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: desktop * 1.1,
      ultraWide: desktop * 1.2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: _isMobile(context)
          ? _buildMobileLayout(context)
          : _buildDesktopLayout(context),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // CONTENT SECTION - LEFT (opposite of iOS app)
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.only(right: 30),
            child: _buildContentSection(context),
          ),
        ),

        // IMAGE SECTION - RIGHT (opposite of iOS app)
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.only(left: 30),
            child: _buildImageSection(context),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Image Section - Top on mobile (takes up less space)
        Flexible(
          flex: 2,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 320,
              maxHeight: 180, // Reduced height for mobile
            ),
            child: _buildImageSection(context),
          ),
        ),

        SizedBox(height: 16), // Reduced spacing

        // Content Section - Bottom on mobile (takes up more space)
        Flexible(
          flex: 3,
          child: Container(
            constraints: BoxConstraints(maxWidth: 500),
            child: _buildContentSection(context),
          ),
        ),
      ],
    );
  }

  // Replace the _buildImageSection method in your EnhancedWebsiteAd class

  Widget _buildImageSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: websiteData.themeColor.withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 3,
            offset: Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.grey[50]!,
              ],
            ),
            border: Border.all(color: Colors.white, width: 4),
            borderRadius: BorderRadius.circular(28),
          ),
          child: AspectRatio(
            aspectRatio: 4/3,
            child: Stack(
              children: [
                // Main image content - FIXED to actually show images
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        websiteData.themeColor.withOpacity(0.1),
                        websiteData.themeColor.withOpacity(0.05),
                      ],
                    ),
                  ),
                  child: _buildActualImage(context),
                ),

                // Live indicator
                Positioned(
                  top: _getResponsiveSize(context, 10, 12, 14),
                  right: _getResponsiveSize(context, 10, 12, 14),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: _getResponsiveSize(context, 8, 10, 11),
                      vertical: _getResponsiveSize(context, 3, 4, 4),
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.green, Colors.green.shade600]),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: _getResponsiveSize(context, 5, 6, 6),
                          height: _getResponsiveSize(context, 5, 6, 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          "LIVE",
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: _getResponsiveSize(context, 8, 9, 10),
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// NEW: Method to handle actual images with fallbacks
  Widget _buildActualImage(BuildContext context) {
    // For web deployment, you might want to use network images
    // or embed images as base64, or use a different approach

    // Option 1: Try to load asset image with fallback
    if (websiteData.imageAsset != null && websiteData.imageAsset!.isNotEmpty) {
      return Image.asset(
        websiteData.imageAsset!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to custom illustration
          return _buildCustomIllustration(context);
        },
      );
    }

    // Option 2: If no asset, show custom illustration
    return _buildCustomIllustration(context);
  }

// NEW: Custom illustration for each website
  Widget _buildCustomIllustration(BuildContext context) {
    switch (websiteData.title.toLowerCase()) {
      case 'pearl school':
        return _buildSchoolIllustration(context);
      case 'maintenance portal':
        return _buildMaintenanceIllustration(context);
      default:
        return _buildGenericWebIllustration(context);
    }
  }

  Widget _buildSchoolIllustration(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_rounded,
            size: _getResponsiveSize(context, 40, 50, 60),
            color: websiteData.themeColor,
          ),
          SizedBox(height: 8),
          Icon(
            Icons.menu_book,
            size: _getResponsiveSize(context, 25, 30, 35),
            color: websiteData.themeColor.withOpacity(0.7),
          ),
          SizedBox(height: 4),
          Text(
            'EDUCATION',
            style: GoogleFonts.inter(
              fontSize: _getResponsiveSize(context, 10, 11, 12),
              fontWeight: FontWeight.bold,
              color: websiteData.themeColor.withOpacity(0.8),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceIllustration(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.build_rounded,
            size: _getResponsiveSize(context, 40, 50, 60),
            color: websiteData.themeColor,
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.smartphone,
                size: _getResponsiveSize(context, 20, 25, 30),
                color: websiteData.themeColor.withOpacity(0.7),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.web,
                size: _getResponsiveSize(context, 20, 25, 30),
                color: websiteData.themeColor.withOpacity(0.7),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            'FLUTTER WEB',
            style: GoogleFonts.inter(
              fontSize: _getResponsiveSize(context, 10, 11, 12),
              fontWeight: FontWeight.bold,
              color: websiteData.themeColor.withOpacity(0.8),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenericWebIllustration(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.web_rounded,
            size: _getResponsiveSize(context, 50, 60, 70),
            color: websiteData.themeColor,
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: websiteData.themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'WEBSITE',
              style: GoogleFonts.inter(
                fontSize: _getResponsiveSize(context, 10, 11, 12),
                fontWeight: FontWeight.bold,
                color: websiteData.themeColor,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // FIXED: Content section with proper overflow handling
  Widget _buildContentSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView( // Added scrolling to prevent overflow
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight( // Ensures proper height distribution
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: _getResponsiveSize(context, 10, 12, 14), // Reduced padding
                      vertical: _getResponsiveSize(context, 4, 5, 6),
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          websiteData.themeColor.withOpacity(0.15),
                          websiteData.themeColor.withOpacity(0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20), // Reduced radius
                      border: Border.all(
                        color: websiteData.themeColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.web_rounded,
                          size: _getResponsiveSize(context, 12, 13, 14), // Reduced icon size
                          color: websiteData.themeColor,
                        ),
                        SizedBox(width: 6), // Reduced spacing
                        Text(
                          "${websiteData.category.toUpperCase()} • ${websiteData.completionYear}",
                          style: GoogleFonts.inter(
                            color: websiteData.themeColor,
                            fontWeight: FontWeight.w700,
                            fontSize: _getResponsiveSize(context, 9, 10, 11), // Reduced font size
                            letterSpacing: 1.2, // Reduced letter spacing
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: _getResponsiveSize(context, 16, 18, 20)), // Reduced spacing

                  // Title - Made more compact
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        websiteData.themeColor,
                        websiteData.themeColor.withOpacity(0.8),
                        websiteData.themeColor.withOpacity(0.6),
                      ],
                      stops: [0.0, 0.7, 1.0],
                    ).createShader(bounds),
                    child: Text(
                      websiteData.title,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: _getResponsiveSize(context, 24, 28, 32), // Reduced font size
                        height: 1.1,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 2, // Limit lines to prevent overflow
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  SizedBox(height: _getResponsiveSize(context, 6, 7, 8)), // Reduced spacing

                  // Subtitle
                  Text(
                    websiteData.subtitle.toUpperCase(),
                    style: GoogleFonts.inter(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w700,
                      fontSize: _getResponsiveSize(context, 9, 10, 11), // Reduced font size
                      letterSpacing: 2, // Reduced letter spacing
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: _getResponsiveSize(context, 12, 14, 16)), // Reduced spacing

                  // Description - Made more compact
                  Flexible( // Changed from Container to Flexible
                    child: Container(
                      padding: EdgeInsets.all(_getResponsiveSize(context, 12, 14, 16)), // Reduced padding
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.95),
                            Colors.white.withOpacity(0.85),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20), // Reduced radius
                        border: Border.all(
                          color: websiteData.themeColor.withOpacity(0.1),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: websiteData.themeColor.withOpacity(0.1),
                            blurRadius: 20, // Reduced blur
                            offset: Offset(0, 6), // Reduced offset
                          ),
                        ],
                      ),
                      child: Text(
                        websiteData.description,
                        style: GoogleFonts.inter(
                          color: Colors.grey[700],
                          height: 1.5,
                          fontSize: _getResponsiveSize(context, 11, 12, 13), // Reduced font size
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: _isMobile(context) ? 3 : 4, // Limit lines
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  SizedBox(height: _getResponsiveSize(context, 12, 14, 16)), // Reduced spacing

                  // Tech stack - Made more compact
                  Wrap(
                    spacing: _getResponsiveSize(context, 4, 5, 6), // Reduced spacing
                    runSpacing: _getResponsiveSize(context, 4, 5, 6),
                    children: websiteData.technologies
                        .take(_isMobile(context) ? 3 : _isDesktop(context) ? 5 : 4) // Reduced number of chips
                        .map((tech) => _buildTechChip(tech, context))
                        .toList(),
                  ),

                  SizedBox(height: _getResponsiveSize(context, 16, 18, 20)), // Reduced spacing

                  // Action button
                  _buildVisitWebsiteButton(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTechChip(String tech, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _getResponsiveSize(context, 8, 9, 10), // Reduced padding
        vertical: _getResponsiveSize(context, 3, 4, 5),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            websiteData.themeColor.withOpacity(0.12),
            websiteData.themeColor.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(14), // Reduced radius
        border: Border.all(
          color: websiteData.themeColor.withOpacity(0.25),
          width: 1.2,
        ),
      ),
      child: Text(
        tech,
        style: GoogleFonts.inter(
          color: websiteData.themeColor,
          fontSize: _getResponsiveSize(context, 9, 10, 10), // Reduced font size
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2, // Reduced letter spacing
        ),
      ),
    );
  }

  // Fixed helper method name
  double _getResponseSize(BuildContext context, double mobile, double tablet, double desktop) {
    return _getResponsiveSize(context, mobile, tablet, desktop);
  }

  Widget _buildVisitWebsiteButton(BuildContext context) {
    return Container(
      height: _getResponsiveSize(context, 40, 44, 48), // Reduced height
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            websiteData.themeColor,
            websiteData.themeColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(_getResponsiveSize(context, 20, 22, 24)), // Reduced radius
        boxShadow: [
          BoxShadow(
            color: websiteData.themeColor.withOpacity(0.5),
            blurRadius: 12, // Reduced blur
            offset: Offset(0, 4), // Reduced offset
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(_getResponsiveSize(context, 20, 22, 24)),
          onTap: _launchUrl,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: _getResponsiveSize(context, 18, 20, 22)), // Reduced padding
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.launch_rounded,
                  color: Colors.white,
                  size: _getResponsiveSize(context, 14, 15, 16), // Reduced icon size
                ),
                SizedBox(width: 6), // Reduced spacing
                Text(
                  "VISIT WEBSITE",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: _getResponsiveSize(context, 10, 11, 12), // Reduced font size
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6, // Reduced letter spacing
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Simple background painter (same as iOS app)
class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.03)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final spacing = 40.0;

    // Simple grid
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}