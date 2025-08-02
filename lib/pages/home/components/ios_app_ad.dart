// REFACTORED IOSAddApp.dart
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/app_data.dart';
import '../../../data/repositories/portfolio_repository.dart';
import '../../../presentation/widgets/ios_app_ad_widget.dart';
import '../../../utils/constants.dart';
import '../../../utils/screen_helper.dart';

class IOSAddApp extends StatefulWidget {
  @override
  _IOSAddAppState createState() => _IOSAddAppState();
}

class _IOSAddAppState extends State<IOSAddApp> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int currentPage = 0;
  late AnimationController _indicatorController;
  late AnimationController _fadeController;

  final List<AppData> appDataList = PortfolioRepository().getApps();

  // 📏 RESPONSIVE UTILITIES
  bool _isMobile(BuildContext context) => MediaQuery.of(context).size.width < 768;
  bool _isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 768 && MediaQuery.of(context).size.width < 1024;
  bool _isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1024;

  double _getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 1200) return 80.0;
    if (screenWidth >= 1024) return 60.0;
    if (screenWidth >= 768) return 40.0;
    return 24.0;
  }

  double _getNavButtonOffset(BuildContext context) {
    if (_isMobile(context)) return 0;
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
      currentPage = (currentPage + 1) % appDataList.length;
      _pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    });
    _indicatorController.forward().then((_) => _indicatorController.reset());
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
    final indicatorHeight = _isMobile(context) ? 40.0 : 60.0;
    final contentHeight = screenHeight - safeAreaTop - safeAreaBottom - indicatorHeight;

    return Container(
      height: screenHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[50]!, Colors.white, Colors.grey[100]!],
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: BackgroundPatternPainter()),
            ),
            Positioned(
              top: 0,
              left: _getNavButtonOffset(context),
              right: _getNavButtonOffset(context),
              height: contentHeight,
              child: FadeTransition(
                opacity: _fadeController,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: appDataList.length,
                  onPageChanged: (index) => setState(() => currentPage = index),
                  itemBuilder: (context, index) => IosAppAdWidget(
                    appData: appDataList[index],
                    onNext: _nextPage,
                    onRestart: () => _goToPage(0),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: safeAreaBottom + (_isMobile(context) ? 16 : 24),
              left: 0,
              right: 0,
              height: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  appDataList.length,
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
            if (!_isMobile(context)) ...[
              Positioned(
                left: _getResponsivePadding(context),
                top: safeAreaTop + 20,
                bottom: safeAreaBottom + indicatorHeight + 20,
                width: _isDesktop(context) ? 60 : 50,
                child: Center(
                  child: _buildNavButton(Icons.arrow_back_ios, () => _goToPage((currentPage - 1 + appDataList.length) % appDataList.length)),
                ),
              ),
              Positioned(
                right: _getResponsivePadding(context),
                top: safeAreaTop + 20,
                bottom: safeAreaBottom + indicatorHeight + 20,
                width: _isDesktop(context) ? 60 : 50,
                child: Center(
                  child: _buildNavButton(Icons.arrow_forward_ios, _nextPage),
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
        border: Border.all(color: kPrimaryColor.withOpacity(0.2), width: 1),
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
          child: Icon(icon, color: kPrimaryColor, size: iconSize),
        ),
      ),
    );
  }
}

class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final spacing = size.width < 768 ? 30.0 : size.width < 1024 ? 40.0 : 50.0;

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
