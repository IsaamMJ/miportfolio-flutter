import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/constants.dart';
import '../../../utils/screen_helper.dart';

class IOSAddApp extends StatefulWidget {
  @override
  _IOSAddAppState createState() => _IOSAddAppState();
}

class _IOSAddAppState extends State<IOSAddApp>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int currentPage = 0;
  late AnimationController _indicatorController;
  late AnimationController _fadeController;

  // 📱 CONSISTENT RESPONSIVE BREAKPOINTS (matching Home widget)
  static const double mobileBreakpoint = 768.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1200.0;

  final List<Widget> apps = [
    SkyFeedAppAd(),
    WeatherProAppAd(),
    NewsHubAppAd(),
  ];

  // 📏 RESPONSIVE UTILITIES
  bool _isMobile(BuildContext context) => MediaQuery.of(context).size.width < mobileBreakpoint;
  bool _isTablet(BuildContext context) => MediaQuery.of(context).size.width >= mobileBreakpoint && MediaQuery.of(context).size.width < tabletBreakpoint;
  bool _isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= tabletBreakpoint;

  double _getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= desktopBreakpoint) return 80.0;
    if (screenWidth >= tabletBreakpoint) return 60.0;
    if (screenWidth >= mobileBreakpoint) return 40.0;
    return 24.0;
  }

  // Calculate safe navigation button positioning
  double _getNavButtonOffset(BuildContext context) {
    if (_isMobile(context)) return 0; // No nav buttons on mobile
    return _getResponsivePadding(context) + (_isDesktop(context) ? 80 : 60);
  }

  @override
  void initState() {
    super.initState();
    _indicatorController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeController.forward();

    // Auto-advance carousel every 8 seconds
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
    setState(() {
      currentPage = (currentPage + 1) % apps.length;
      _pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    });
    _indicatorController.forward().then((_) {
      _indicatorController.reset();
    });
  }

  void _goToPage(int page) {
    setState(() {
      currentPage = page;
      _pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _indicatorController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    // Calculate available height for content
    final availableHeight = screenHeight - safeAreaTop - safeAreaBottom;
    final indicatorHeight = _isMobile(context) ? 40.0 : 60.0;
    final contentHeight = availableHeight - indicatorHeight;

    return Container(
      height: screenHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[50]!,
            Colors.white,
            Colors.grey[100]!,
          ],
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: CustomPaint(
                painter: BackgroundPatternPainter(),
              ),
            ),

            // Main carousel with proper height constraints
            Positioned(
              top: 0,
              left: _getNavButtonOffset(context),
              right: _getNavButtonOffset(context),
              height: contentHeight,
              child: FadeTransition(
                opacity: _fadeController,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: apps.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Container(
                      height: contentHeight,
                      child: apps[index],
                    );
                  },
                ),
              ),
            ),

            // Page indicators - fixed positioning at bottom
            Positioned(
              bottom: safeAreaBottom + (_isMobile(context) ? 16 : 24),
              left: 0,
              right: 0,
              height: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  apps.length,
                      (index) => AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    width: currentPage == index ? (_isMobile(context) ? 24 : 32) : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: currentPage == index
                          ? kPrimaryColor
                          : kPrimaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // Navigation arrows for desktop and tablet only - properly positioned
            if (!_isMobile(context)) ...[
              Positioned(
                left: _getResponsivePadding(context),
                top: safeAreaTop + 20,
                bottom: safeAreaBottom + indicatorHeight + 20,
                width: _isDesktop(context) ? 60 : 50,
                child: Center(
                  child: _buildNavButton(
                    Icons.arrow_back_ios,
                        () => _goToPage((currentPage - 1 + apps.length) % apps.length),
                  ),
                ),
              ),
              Positioned(
                right: _getResponsivePadding(context),
                top: safeAreaTop + 20,
                bottom: safeAreaBottom + indicatorHeight + 20,
                width: _isDesktop(context) ? 60 : 50,
                child: Center(
                  child: _buildNavButton(
                    Icons.arrow_forward_ios,
                        () => _nextPage(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onPressed) {
    final buttonSize = _isDesktop(context) ? 50.0 : 40.0;
    final iconSize = _isDesktop(context) ? 20.0 : 16.0;

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(buttonSize / 2),
        border: Border.all(
          color: kPrimaryColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(buttonSize / 2),
          onTap: onPressed,
          child: Icon(
            icon,
            color: kPrimaryColor,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}

class SkyFeedAppAd extends StatelessWidget {
  // 📱 CONSISTENT RESPONSIVE BREAKPOINTS
  static const double mobileBreakpoint = 768.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1200.0;

  // 📏 RESPONSIVE UTILITIES
  bool _isMobile(BuildContext context) => MediaQuery.of(context).size.width < mobileBreakpoint;
  bool _isTablet(BuildContext context) => MediaQuery.of(context).size.width >= mobileBreakpoint && MediaQuery.of(context).size.width < tabletBreakpoint;
  bool _isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= tabletBreakpoint;

  double _getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= desktopBreakpoint) return 60.0;
    if (screenWidth >= tabletBreakpoint) return 40.0;
    if (screenWidth >= mobileBreakpoint) return 30.0;
    return 20.0;
  }

  double _getResponsiveFontSize(BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (_isDesktop(context)) return desktop;
    if (_isTablet(context)) return tablet;
    return mobile;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: _getResponsivePadding(context),
                vertical: _isMobile(context) ? 20 : 40,
              ),
              child: _buildUi(context, constraints),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUi(BuildContext context, BoxConstraints constraints) {
    bool isWideLayout = constraints.maxWidth > 800 && !_isMobile(context);

    return IntrinsicHeight(
      child: Flex(
        direction: isWideLayout ? Axis.horizontal : Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image section
          Flexible(
            flex: isWideLayout ? 1 : 0,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isWideLayout ? double.infinity :
                _isMobile(context) ? 280 : 400,
                maxHeight: _isMobile(context) ? 300 : 400,
              ),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  children: [
                    // Glow effect
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(_isMobile(context) ? 15 : 20),
                        boxShadow: [
                          BoxShadow(
                            color: kPrimaryColor.withOpacity(0.3),
                            blurRadius: _isMobile(context) ? 20 : 30,
                            spreadRadius: _isMobile(context) ? 3 : 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(_isMobile(context) ? 15 : 20),
                        child: Image.asset(
                          "assets/skyfeed.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Floating elements - responsive visibility
                    if (constraints.maxWidth > 350)
                      Positioned(
                        top: -5,
                        right: -5,
                        child: Container(
                          width: _isMobile(context) ? 40 : 60,
                          height: _isMobile(context) ? 40 : 60,
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(_isMobile(context) ? 20 : 30),
                          ),
                          child: Icon(
                            Icons.wb_sunny,
                            color: Colors.white,
                            size: _isMobile(context) ? 16 : 24,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(
            width: isWideLayout ? (_isMobile(context) ? 30 : 50) : 0,
            height: isWideLayout ? 0 : (_isMobile(context) ? 20 : 30),
          ),

          // Content section
          Flexible(
            flex: isWideLayout ? 1 : 0,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isWideLayout ? double.infinity : 600,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: isWideLayout ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: _isMobile(context) ? 8 : 12,
                      vertical: _isMobile(context) ? 4 : 6,
                    ),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(_isMobile(context) ? 15 : 20),
                      border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      "FEATURED APP",
                      style: GoogleFonts.poppins(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: _getResponsiveFontSize(context,
                            mobile: 10, tablet: 11, desktop: 12),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(height: _isMobile(context) ? 15 : 20),

                  // App name with animation
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [kPrimaryColor, Colors.blue[400]!],
                    ).createShader(bounds),
                    child: Text(
                      "SkyFeed",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: _getResponsiveFontSize(context,
                            mobile: 28, tablet: 36, desktop: 48),
                        height: 1.1,
                      ),
                      textAlign: isWideLayout ? TextAlign.left : TextAlign.center,
                    ),
                  ),

                  SizedBox(height: _isMobile(context) ? 10 : 15),
                  Text(
                    "PERSONALIZED NEWS &\nWEATHER FORECASTS",
                    style: GoogleFonts.poppins(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      fontSize: _getResponsiveFontSize(context,
                          mobile: 16, tablet: 20, desktop: 24),
                      letterSpacing: 0.5,
                    ),
                    textAlign: isWideLayout ? TextAlign.left : TextAlign.center,
                  ),

                  SizedBox(height: _isMobile(context) ? 15 : 20),
                  Container(
                    padding: EdgeInsets.all(_isMobile(context) ? 15 : 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(_isMobile(context) ? 12 : 15),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Text(
                      "Experience the perfect blend of real-time weather data and curated news content. Our AI-powered platform delivers personalized insights that matter to you, when you need them most.",
                      style: GoogleFonts.inter(
                        color: Colors.grey[700],
                        height: 1.6,
                        fontSize: _getResponsiveFontSize(context,
                            mobile: 13, tablet: 15, desktop: 16),
                      ),
                      textAlign: isWideLayout ? TextAlign.left : TextAlign.center,
                    ),
                  ),

                  SizedBox(height: _isMobile(context) ? 20 : 30),

                  // Rating and stats
                  Wrap(
                    spacing: _isMobile(context) ? 8 : 15,
                    runSpacing: _isMobile(context) ? 8 : 10,
                    alignment: isWideLayout ? WrapAlignment.start : WrapAlignment.center,
                    children: [
                      _buildStatCard("4.8★", "Rating", context),
                      _buildStatCard("50K+", "Downloads", context),
                      _buildStatCard("Free", "Price", context),
                    ],
                  ),

                  SizedBox(height: _isMobile(context) ? 20 : 30),

                  // Action buttons
                  Wrap(
                    spacing: _isMobile(context) ? 10 : 15,
                    runSpacing: 10,
                    alignment: isWideLayout ? WrapAlignment.start : WrapAlignment.center,
                    children: [
                      _buildButton(
                        context,
                        "EXPLORE APP",
                            () {},
                        primary: true,
                        icon: Icons.launch,
                      ),
                      _buildButton(
                        context,
                        "NEXT",
                            () {
                          final state = context.findAncestorStateOfType<_IOSAddAppState>();
                          state?._nextPage();
                        },
                        primary: false,
                        icon: Icons.arrow_forward,
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _isMobile(context) ? 8 : 12,
        vertical: _isMobile(context) ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_isMobile(context) ? 8 : 10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: _getResponsiveFontSize(context,
                  mobile: 12, tablet: 13, desktop: 14),
              color: kPrimaryColor,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: _getResponsiveFontSize(context,
                  mobile: 9, tablet: 10, desktop: 11),
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, VoidCallback onPressed,
      {required bool primary, IconData? icon}) {
    return Container(
      height: _isMobile(context) ? 40 : 50,
      constraints: BoxConstraints(
        minWidth: _isMobile(context) ? 100 : 120,
      ),
      decoration: BoxDecoration(
        gradient: primary
            ? LinearGradient(
          colors: [kPrimaryColor, Colors.blue[400]!],
        )
            : null,
        color: primary ? null : Colors.white,
        borderRadius: BorderRadius.circular(_isMobile(context) ? 20 : 25),
        border: primary ? null : Border.all(color: kPrimaryColor),
        boxShadow: [
          BoxShadow(
            color: primary
                ? kPrimaryColor.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: primary ? 15 : 5,
            offset: Offset(0, primary ? 5 : 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(_isMobile(context) ? 20 : 25),
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _isMobile(context) ? 16 : 24,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: primary ? Colors.white : kPrimaryColor,
                    size: _isMobile(context) ? 14 : 18,
                  ),
                  SizedBox(width: _isMobile(context) ? 4 : 8),
                ],
                Flexible(
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: primary ? Colors.white : kPrimaryColor,
                      fontSize: _getResponsiveFontSize(context,
                          mobile: 12, tablet: 13, desktop: 14),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
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

class WeatherProAppAd extends StatelessWidget {
  // 📱 CONSISTENT RESPONSIVE BREAKPOINTS
  static const double mobileBreakpoint = 768.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1200.0;

  // 📏 RESPONSIVE UTILITIES
  bool _isMobile(BuildContext context) => MediaQuery.of(context).size.width < mobileBreakpoint;
  bool _isTablet(BuildContext context) => MediaQuery.of(context).size.width >= mobileBreakpoint && MediaQuery.of(context).size.width < tabletBreakpoint;
  bool _isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= tabletBreakpoint;

  double _getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= desktopBreakpoint) return 60.0;
    if (screenWidth >= tabletBreakpoint) return 40.0;
    if (screenWidth >= mobileBreakpoint) return 30.0;
    return 20.0;
  }

  double _getResponsiveFontSize(BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (_isDesktop(context)) return desktop;
    if (_isTablet(context)) return tablet;
    return mobile;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: _getResponsivePadding(context),
                vertical: _isMobile(context) ? 20 : 40,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App icon with glow
                  Container(
                    width: _isMobile(context) ? 80 : _isTablet(context) ? 100 : 120,
                    height: _isMobile(context) ? 80 : _isTablet(context) ? 100 : 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[400]!, Colors.purple[400]!],
                      ),
                      borderRadius: BorderRadius.circular(_isMobile(context) ? 20 : 30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.4),
                          blurRadius: _isMobile(context) ? 15 : 20,
                          spreadRadius: _isMobile(context) ? 3 : 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.cloud,
                      color: Colors.white,
                      size: _isMobile(context) ? 40 : _isTablet(context) ? 50 : 60,
                    ),
                  ),

                  SizedBox(height: _isMobile(context) ? 20 : 30),

                  Text(
                    "WeatherPro",
                    style: GoogleFonts.poppins(
                      fontSize: _getResponsiveFontSize(context,
                          mobile: 28, tablet: 35, desktop: 42),
                      fontWeight: FontWeight.w800,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: _isMobile(context) ? 8 : 10),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: _isMobile(context) ? double.infinity : 400,
                    ),
                    child: Text(
                      "Advanced weather tracking with AI predictions",
                      style: GoogleFonts.inter(
                        fontSize: _getResponsiveFontSize(context,
                            mobile: 14, tablet: 16, desktop: 18),
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: _isMobile(context) ? 30 : 40),

                  // Features grid
                  Container(
                    constraints: BoxConstraints(maxWidth: 600),
                    child: Wrap(
                      spacing: _isMobile(context) ? 10 : 20,
                      runSpacing: _isMobile(context) ? 10 : 15,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildFeatureChip("Real-time Updates", Icons.update, context),
                        _buildFeatureChip("AI Predictions", Icons.psychology, context),
                        _buildFeatureChip("Multi-location", Icons.location_on, context),
                        _buildFeatureChip("Weather Alerts", Icons.notifications, context),
                      ],
                    ),
                  ),

                  SizedBox(height: _isMobile(context) ? 30 : 40),

                  ElevatedButton.icon(
                    onPressed: () {
                      final state = context.findAncestorStateOfType<_IOSAddAppState>();
                      state?._nextPage();
                    },
                    icon: Icon(Icons.arrow_forward,
                        size: _isMobile(context) ? 16 : 18),
                    label: Text(
                      "DISCOVER MORE",
                      style: TextStyle(
                        fontSize: _getResponsiveFontSize(context,
                            mobile: 12, tablet: 14, desktop: 16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[400],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: _isMobile(context) ? 20 : 30,
                        vertical: _isMobile(context) ? 12 : 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_isMobile(context) ? 20 : 25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureChip(String label, IconData icon, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _isMobile(context) ? 12 : 16,
        vertical: _isMobile(context) ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_isMobile(context) ? 15 : 20),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: _isMobile(context) ? 14 : 16,
            color: Colors.blue[400],
          ),
          SizedBox(width: _isMobile(context) ? 4 : 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: _getResponsiveFontSize(context,
                  mobile: 11, tablet: 12, desktop: 12),
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

class NewsHubAppAd extends StatelessWidget {
  // 📱 CONSISTENT RESPONSIVE BREAKPOINTS
  static const double mobileBreakpoint = 768.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1200.0;

  // 📏 RESPONSIVE UTILITIES
  bool _isMobile(BuildContext context) => MediaQuery.of(context).size.width < mobileBreakpoint;
  bool _isTablet(BuildContext context) => MediaQuery.of(context).size.width >= mobileBreakpoint && MediaQuery.of(context).size.width < tabletBreakpoint;
  bool _isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= tabletBreakpoint;

  double _getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= desktopBreakpoint) return 60.0;
    if (screenWidth >= tabletBreakpoint) return 40.0;
    if (screenWidth >= mobileBreakpoint) return 30.0;
    return 20.0;
  }

  double _getResponsiveFontSize(BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (_isDesktop(context)) return desktop;
    if (_isTablet(context)) return tablet;
    return mobile;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: _getResponsivePadding(context),
                vertical: _isMobile(context) ? 20 : 40,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated news icon
                  Container(
                    width: _isMobile(context) ? 80 : _isTablet(context) ? 100 : 120,
                    height: _isMobile(context) ? 80 : _isTablet(context) ? 100 : 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red[400]!, Colors.orange[400]!],
                      ),
                      borderRadius: BorderRadius.circular(_isMobile(context) ? 20 : 30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.4),
                          blurRadius: _isMobile(context) ? 15 : 20,
                          spreadRadius: _isMobile(context) ? 3 : 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.newspaper,
                      color: Colors.white,
                      size: _isMobile(context) ? 40 : _isTablet(context) ? 50 : 60,
                    ),
                  ),

                  SizedBox(height: _isMobile(context) ? 20 : 30),

                  Text(
                    "NewsHub",
                    style: GoogleFonts.poppins(
                      fontSize: _getResponsiveFontSize(context,
                          mobile: 28, tablet: 35, desktop: 42),
                      fontWeight: FontWeight.w800,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: _isMobile(context) ? 8 : 10),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: _isMobile(context) ? double.infinity : 400,
                    ),
                    child: Text(
                      "Stay informed with personalized news curation",
                      style: GoogleFonts.inter(
                        fontSize: _getResponsiveFontSize(context,
                            mobile: 14, tablet: 16, desktop: 18),
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: _isMobile(context) ? 30 : 40),

                  // News categories
                  Container(
                    constraints: BoxConstraints(maxWidth: 600),
                    child: Wrap(
                      spacing: _isMobile(context) ? 8 : 15,
                      runSpacing: _isMobile(context) ? 8 : 10,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildCategoryTag("Technology", context),
                        _buildCategoryTag("Business", context),
                        _buildCategoryTag("Sports", context),
                        _buildCategoryTag("Health", context),
                        _buildCategoryTag("Science", context),
                      ],
                    ),
                  ),

                  SizedBox(height: _isMobile(context) ? 30 : 40),

                  Wrap(
                    spacing: _isMobile(context) ? 10 : 15,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.launch,
                            size: _isMobile(context) ? 16 : 18),
                        label: Text(
                          "EXPLORE",
                          style: TextStyle(
                            fontSize: _getResponsiveFontSize(context,
                                mobile: 12, tablet: 14, desktop: 16),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: _isMobile(context) ? 20 : 25,
                            vertical: _isMobile(context) ? 10 : 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(_isMobile(context) ? 20 : 25),
                          ),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          final state = context.findAncestorStateOfType<_IOSAddAppState>();
                          state?._goToPage(0); // Go back to first app
                        },
                        icon: Icon(Icons.refresh,
                            size: _isMobile(context) ? 16 : 18),
                        label: Text(
                          "RESTART",
                          style: TextStyle(
                            fontSize: _getResponsiveFontSize(context,
                                mobile: 12, tablet: 14, desktop: 16),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red[400],
                          padding: EdgeInsets.symmetric(
                            horizontal: _isMobile(context) ? 20 : 25,
                            vertical: _isMobile(context) ? 10 : 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(_isMobile(context) ? 20 : 25),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryTag(String category, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _isMobile(context) ? 10 : 12,
        vertical: _isMobile(context) ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(_isMobile(context) ? 12 : 15),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Text(
        category,
        style: GoogleFonts.inter(
          fontSize: _getResponsiveFontSize(context,
              mobile: 10, tablet: 11, desktop: 12),
          color: Colors.red[600],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// Custom painter for background pattern
class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Responsive spacing based on screen size
    final spacing = size.width < 768 ? 30.0 : size.width < 1024 ? 40.0 : 50.0;

    // Draw grid pattern
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}