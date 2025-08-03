// FULLY RESPONSIVE IOSAddApp.dart - NO OVERLAPPING, PERFECT FOR ALL SCREEN SIZES - OVERFLOW FIXED
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/models/app_data.dart';
import '../../../../data/repositories/portfolio_repository_impl.dart';
import '../../../../presentation/widgets/ios_app_ad_widget.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/screen_helper.dart';

class IOSAddApp extends StatefulWidget {
  @override
  _IOSAddAppState createState() => _IOSAddAppState();
}

class _IOSAddAppState extends State<IOSAddApp> with TickerProviderStateMixin {
  int currentPage = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<AppData> appDataList = PortfolioRepository().getApps();

  // 📱 ENHANCED RESPONSIVE BREAKPOINTS
  static const double _mobileBreakpoint = 576.0;
  static const double _smallTabletBreakpoint = 768.0;
  static const double _tabletBreakpoint = 992.0;
  static const double _desktopBreakpoint = 1200.0;
  static const double _largeDesktopBreakpoint = 1400.0;

  // 📐 RESPONSIVE DEVICE DETECTION
  bool _isMobile(BuildContext context) => MediaQuery.of(context).size.width < _mobileBreakpoint;
  bool _isSmallTablet(BuildContext context) => MediaQuery.of(context).size.width >= _mobileBreakpoint && MediaQuery.of(context).size.width < _smallTabletBreakpoint;
  bool _isTablet(BuildContext context) => MediaQuery.of(context).size.width >= _smallTabletBreakpoint && MediaQuery.of(context).size.width < _tabletBreakpoint;
  bool _isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= _tabletBreakpoint && MediaQuery.of(context).size.width < _largeDesktopBreakpoint;
  bool _isLargeDesktop(BuildContext context) => MediaQuery.of(context).size.width >= _largeDesktopBreakpoint;

  // 📏 RESPONSIVE SIZING UTILITIES - REDUCED FOR OVERFLOW PREVENTION
  double _getResponsivePadding(BuildContext context) {
    if (_isLargeDesktop(context)) return 32.0; // Reduced from 40.0
    if (_isDesktop(context)) return 24.0; // Reduced from 32.0
    if (_isTablet(context)) return 20.0; // Reduced from 24.0
    if (_isSmallTablet(context)) return 16.0; // Reduced from 20.0
    return 12.0; // Reduced from 16.0
  }

  double _getNavButtonSpacing(BuildContext context) {
    if (_isLargeDesktop(context)) return 24.0; // Reduced from 32.0
    if (_isDesktop(context)) return 20.0; // Reduced from 24.0
    if (_isTablet(context)) return 16.0; // Reduced from 20.0
    return 12.0; // Reduced from 16.0
  }

  double _getNavButtonSize(BuildContext context) {
    if (_isLargeDesktop(context)) return 50.0; // Reduced from 56.0
    if (_isDesktop(context)) return 46.0; // Reduced from 52.0
    if (_isTablet(context)) return 42.0; // Reduced from 48.0
    return 38.0; // Reduced from 44.0
  }

  double _getBottomSectionHeight(BuildContext context) {
    if (_isMobile(context)) return 85.0; // Reduced from 100.0
    if (_isSmallTablet(context)) return 75.0; // Reduced from 90.0
    return 70.0; // Reduced from 80.0
  }

  EdgeInsets _getBottomPadding(BuildContext context) {
    if (_isMobile(context)) return EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0); // Reduced
    if (_isSmallTablet(context)) return EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0); // Reduced
    return EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0); // Reduced
  }

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOutCubic,
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
    _goToPage((currentPage + 1) % appDataList.length);
  }

  void _goToPage(int page) {
    if (page != currentPage && appDataList.isNotEmpty) {
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
    if (appDataList.isEmpty) {
      return Container(
        child: Center(
          child: Text(
            'No apps available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey[50]!, Colors.white, Colors.grey[100]!],
            ),
          ),
          child: Stack(
            children: [
              // Background pattern
              CustomPaint(
                painter: BackgroundPatternPainter(),
                size: Size(constraints.maxWidth, constraints.maxHeight),
              ),

              // Main responsive layout - FIXED OVERFLOW ISSUES
              Column(
                children: [
                  // Content area - Flexible to accommodate different screen sizes
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(_getResponsivePadding(context)),
                      child: _buildMainContent(context, constraints),
                    ),
                  ),

                  // Bottom section - Fixed height with responsive content
                  Container(
                    height: _getBottomSectionHeight(context),
                    padding: _getBottomPadding(context),
                    child: _buildBottomSection(context),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMainContent(BuildContext context, BoxConstraints constraints) {
    final showNavButtons = !_isMobile(context) && !_isSmallTablet(context);

    if (showNavButtons) {
      // Desktop/Tablet layout with navigation buttons
      return Row(
        children: [
          // Left nav button
          _buildNavButton(
            Icons.arrow_back_ios,
                () => _goToPage((currentPage - 1 + appDataList.length) % appDataList.length),
            context,
          ),
          SizedBox(width: _getNavButtonSpacing(context)),

          // Main content - FIXED: Added Flexible to prevent overflow
          Expanded(
            child: _buildMainAppContent(context),
          ),

          // Right nav button
          SizedBox(width: _getNavButtonSpacing(context)),
          _buildNavButton(Icons.arrow_forward_ios, _nextPage, context),
        ],
      );
    } else {
      // Mobile/Small tablet layout without nav buttons
      return _buildMainAppContent(context);
    }
  }

  Widget _buildMainAppContent(BuildContext context) {
    return GestureDetector(
      // Swipe gestures for mobile and small tablets
      onPanEnd: (_isMobile(context) || _isSmallTablet(context))
          ? (details) {
        final velocity = details.velocity.pixelsPerSecond.dx;
        if (velocity.abs() > 500) {
          if (velocity > 0) {
            // Swipe right - previous
            _goToPage((currentPage - 1 + appDataList.length) % appDataList.length);
          } else {
            // Swipe left - next
            _nextPage();
          }
        }
      }
          : null,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          // FIXED: Added ClipRect to prevent any child overflow
          child: ClipRect(
            child: IosAppAdWidget(
              appData: appDataList[currentPage],
              onNext: _nextPage,
              onRestart: () => _goToPage(0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min, // FIXED: Prevent column from taking more space
      children: [
        // Mobile swipe hint
        if (_isMobile(context) || _isSmallTablet(context))
          Container(
            margin: EdgeInsets.only(bottom: 12), // Reduced from 16
            padding: EdgeInsets.symmetric(
              horizontal: 12, // Reduced from 16
              vertical: _isMobile(context) ? 6 : 4, // Reduced
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12), // Reduced from 16
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.swipe_left,
                  size: _isMobile(context) ? 14 : 12, // Reduced sizes
                  color: Colors.grey[600],
                ),
                SizedBox(width: 4), // Reduced from 6
                Text(
                  "Swipe to explore",
                  style: GoogleFonts.inter(
                    color: Colors.grey[600],
                    fontSize: _isMobile(context) ? 10 : 9, // Reduced font sizes
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

        // Indicators section - FIXED: Made more compact
        Flexible( // FIXED: Changed to Flexible to prevent overflow
          child: _buildIndicatorsSection(context),
        ),
      ],
    );
  }

  Widget _buildIndicatorsSection(BuildContext context) {
    // Responsive layout for indicators
    if (_isMobile(context)) {
      // Stack layout for mobile to save space
      return Column(
        mainAxisSize: MainAxisSize.min, // FIXED: Prevent taking unnecessary space
        children: [
          // App name - FIXED: Made more compact
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4), // Reduced padding
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10), // Reduced radius
              border: Border.all(
                color: kPrimaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              appDataList[currentPage].subtitle,
              style: GoogleFonts.inter(
                color: kPrimaryColor,
                fontSize: 10, // Reduced from 11
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1, // FIXED: Prevent text overflow
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 6), // Reduced from 8
          // Dot indicators
          _buildDotIndicators(context),
        ],
      );
    } else {
      // Row layout for larger screens - FIXED: Made more compact
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // FIXED: Prevent taking unnecessary space
        children: [
          // App name - FIXED: Made flexible to prevent overflow
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: _isSmallTablet(context) ? 8 : 10, // Reduced
                vertical: _isSmallTablet(context) ? 3 : 4, // Reduced
              ),
              margin: EdgeInsets.only(right: 12), // Reduced from 16
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10), // Reduced from 12
                border: Border.all(
                  color: kPrimaryColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                appDataList[currentPage].subtitle,
                style: GoogleFonts.inter(
                  color: kPrimaryColor,
                  fontSize: _isSmallTablet(context) ? 9 : 10, // Reduced font sizes
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1, // FIXED: Prevent text overflow
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // Dot indicators
          _buildDotIndicators(context),
        ],
      );
    }
  }

  Widget _buildDotIndicators(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min, // FIXED: Prevent taking unnecessary space
      children: List.generate(
        appDataList.length,
            (index) => GestureDetector(
          onTap: () => _goToPage(index),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(horizontal: 2), // Reduced from 3
            width: currentPage == index
                ? (_isMobile(context) ? 20 : 24) // Reduced sizes
                : (_isMobile(context) ? 6 : 8),
            height: _isMobile(context) ? 6 : 8, // Reduced heights
            decoration: BoxDecoration(
              color: currentPage == index
                  ? kPrimaryColor
                  : kPrimaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4), // Reduced from 5
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onPressed, BuildContext context) {
    final buttonSize = _getNavButtonSize(context);

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(buttonSize / 2),
        border: Border.all(color: kPrimaryColor.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10, // Reduced from 12
            offset: Offset(0, 3), // Reduced from 4
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
              color: kPrimaryColor,
              size: _isLargeDesktop(context) ? 20 : _isDesktop(context) ? 18 : 16, // Reduced sizes
            ),
          ),
        ),
      ),
    );
  }
}

// Enhanced background painter with responsive patterns - OPTIMIZED
class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.02) // Reduced opacity
      ..strokeWidth = 0.3 // Reduced stroke width
      ..style = PaintingStyle.stroke;

    // Responsive grid spacing - OPTIMIZED for performance
    final spacing = size.width < 768 ? 35.0 : size.width < 1200 ? 45.0 : 55.0; // Increased spacing

    // Draw responsive grid - OPTIMIZED: Less lines for better performance
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Add subtle corner accents for larger screens - OPTIMIZED: Smaller accents
    if (size.width >= 768) {
      final accentPaint = Paint()
        ..color = Colors.blue.withOpacity(0.015) // Reduced opacity
        ..style = PaintingStyle.fill;

      final accentSize = size.width >= 1200 ? 25.0 : 20.0; // Reduced sizes
      final margin = size.width >= 1200 ? 40.0 : 30.0; // Reduced margins

      canvas.drawCircle(Offset(margin, margin), accentSize, accentPaint);
      canvas.drawCircle(Offset(size.width - margin, margin), accentSize, accentPaint);
      canvas.drawCircle(Offset(margin, size.height - margin), accentSize, accentPaint);
      canvas.drawCircle(Offset(size.width - margin, size.height - margin), accentSize, accentPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}