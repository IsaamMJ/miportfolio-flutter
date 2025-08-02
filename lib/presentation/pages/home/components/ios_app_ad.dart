// SUPER SIMPLE IOSAddApp.dart - NO SCROLLING, NO OVERLAPPING
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/models/app_data.dart';
import '../../../../data/repositories/portfolio_repository.dart';
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

  // 📱 RESPONSIVE UTILITIES
  bool _isMobile(BuildContext context) => MediaQuery.of(context).size.width < 768.0;
  bool _isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 768.0 && MediaQuery.of(context).size.width < 1024.0;
  bool _isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1024.0;

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
              // Content area - Takes most of the space
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(_isMobile(context) ? 16.0 : 24.0),
                  child: Row(
                    children: [
                      // Left nav button (desktop/tablet only)
                      if (!_isMobile(context)) ...[
                        _buildNavButton(
                          Icons.arrow_back_ios,
                              () => _goToPage((currentPage - 1 + appDataList.length) % appDataList.length),
                        ),
                        SizedBox(width: 20),
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
                                _goToPage((currentPage - 1 + appDataList.length) % appDataList.length);
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
                              child: IosAppAdWidget(
                                appData: appDataList[currentPage],
                                onNext: _nextPage,
                                onRestart: () => _goToPage(0),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Right nav button (desktop/tablet only)
                      if (!_isMobile(context)) ...[
                        SizedBox(width: 20),
                        _buildNavButton(Icons.arrow_forward_ios, _nextPage),
                      ],
                    ],
                  ),
                ),
              ),

              // Bottom section - Fixed height for indicators
              Container(
                height: 80, // Fixed height to prevent layout shifts
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Mobile swipe hint
                    if (_isMobile(context))
                      Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.swipe_left, size: 12, color: Colors.grey[600]),
                            SizedBox(width: 4),
                            Text(
                              "Swipe to explore",
                              style: GoogleFonts.inter(
                                color: Colors.grey[600],
                                fontSize: 10,
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
                        // App name
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          margin: EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: kPrimaryColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            appDataList[currentPage].subtitle,
                            style: GoogleFonts.inter(
                              color: kPrimaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        // Dot indicators
                        ...List.generate(
                          appDataList.length,
                              (index) => GestureDetector(
                            onTap: () => _goToPage(index),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(horizontal: 2),
                              width: currentPage == index ? 20 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: currentPage == index
                                    ? kPrimaryColor
                                    : kPrimaryColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(3),
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
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kPrimaryColor.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onPressed,
          child: Center(
            child: Icon(
              icon,
              color: kPrimaryColor,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}

// Simple background painter
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