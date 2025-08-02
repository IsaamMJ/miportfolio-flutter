import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/website_data.dart';
import '../../../data/repositories/portfolio_repository.dart';
import '../../../utils/constants.dart';
import '../../../utils/screen_helper.dart';

class WebsiteCarousel extends StatefulWidget {
  @override
  _WebsiteCarouselState createState() => _WebsiteCarouselState();
}

class _WebsiteCarouselState extends State<WebsiteCarousel>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int currentPage = 0;
  late AnimationController _indicatorController;
  late AnimationController _fadeController;
  late AnimationController _floatingController;

  // Use repository to get website data
  final PortfolioRepository _repository = PortfolioRepository();
  late List<WebsiteData> websites;

  @override
  void initState() {
    super.initState();

    // Initialize websites from repository
    websites = _repository.getWebsites();

    _indicatorController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _fadeController.forward();
    _floatingController.repeat(reverse: true);

    // Auto-advance carousel every 10 seconds
    _startAutoPlay();
  }

  void _startAutoPlay() {
    Future.delayed(Duration(seconds: 10), () {
      if (mounted) {
        _nextPage();
        _startAutoPlay();
      }
    });
  }

  void _nextPage() {
    setState(() {
      currentPage = (currentPage + 1) % websites.length;
      _pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 900),
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
        duration: Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _indicatorController.dispose();
    _fadeController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

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
            websites[currentPage].themeColor.withOpacity(0.05),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Animated background elements
          Positioned.fill(
            child: CustomPaint(
              painter: WebBackgroundPainter(
                animation: _floatingController,
                color: websites[currentPage].themeColor,
              ),
            ),
          ),

          // Main carousel
          FadeTransition(
            opacity: _fadeController,
            child: PageView.builder(
              controller: _pageController,
              itemCount: websites.length,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return WebsiteAd(websiteData: websites[index]);
              },
            ),
          ),

          // Enhanced page indicators with labels
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Website titles as indicators

                SizedBox(height: 15),
                // Traditional dot indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    websites.length,
                        (index) => AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 3),
                      width: currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: currentPage == index
                            ? websites[currentPage].themeColor
                            : websites[currentPage].themeColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Navigation arrows for desktop
          if (MediaQuery.of(context).size.width > 720) ...[
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: _buildNavButton(
                  Icons.arrow_back_ios,
                      () => _goToPage((currentPage - 1 + websites.length) % websites.length),
                ),
              ),
            ),
            Positioned(
              right: 20,
              top: 0,
              bottom: 0,
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
    );
  }

  Widget _buildNavButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: websites[currentPage].themeColor.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: websites[currentPage].themeColor, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}

class WebsiteAd extends StatelessWidget {
  final WebsiteData websiteData;

  const WebsiteAd({required this.websiteData});

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(websiteData.websiteUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, webOnlyWindowName: '_blank');
    } else {
      throw 'Could not launch ${websiteData.websiteUrl}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScreenHelper(
        desktop: _buildUi(kDesktopMaxWidth, context),
        tablet: _buildUi(kTabletMaxWidth, context),
        mobile: _buildUi(getMobileMaxWidth(context), context),
      ),
    );
  }

  Widget _buildUi(double width, BuildContext context) {
    return Center(
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isDesktop = constraints.maxWidth > 720;
            return Flex(
              direction: isDesktop ? Axis.horizontal : Axis.vertical,
              children: [
                // Content Section
                Expanded(
                  flex: isDesktop ? 1 : 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              websiteData.themeColor.withOpacity(0.1),
                              websiteData.themeColor.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: websiteData.themeColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.web,
                              size: 14,
                              color: websiteData.themeColor,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "${websiteData.category.toUpperCase()} • ${websiteData.completionYear}",
                              style: GoogleFonts.inter(
                                color: websiteData.themeColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 25),

                      // Title with gradient
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            websiteData.themeColor,
                            websiteData.themeColor.withOpacity(0.7),
                          ],
                        ).createShader(bounds),
                        child: Text(
                          websiteData.title,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 48,
                            height: 1.1,
                          ),
                        ),
                      ),

                      SizedBox(height: 8),
                      Text(
                        websiteData.subtitle.toUpperCase(),
                        style: GoogleFonts.inter(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          letterSpacing: 2,
                        ),
                      ),

                      SizedBox(height: 25),

                      // Description in card
                      Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: websiteData.themeColor.withOpacity(0.1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: websiteData.themeColor.withOpacity(0.1),
                              blurRadius: 20,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Text(
                          websiteData.description,
                          style: GoogleFonts.inter(
                            color: Colors.grey[700],
                            height: 1.7,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      SizedBox(height: 30),

                      // Tech stack
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: websiteData.technologies
                            .map((tech) => _buildTechChip(tech))
                            .toList(),
                      ),

                      SizedBox(height: 35),

                      // Action buttons
                      Row(
                        children: [
                          _buildVisitWebsiteButton(_launchUrl),
                          SizedBox(width: 15),
                          _buildButton(
                            "NEXT PROJECT",
                                () {
                              final state = context.findAncestorStateOfType<_WebsiteCarouselState>();
                              state?._nextPage();
                            },
                            outlined: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  width: isDesktop ? 40 : 0,
                  height: isDesktop ? 0 : 30,
                ),

                // Image Section
                Expanded(
                  flex: isDesktop ? 1 : 0,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: isDesktop ? double.infinity : 400),
                    child: Stack(
                      children: [
                        // Main image with enhanced styling
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: websiteData.themeColor.withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 5,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Image.asset(
                                websiteData.imageAsset,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        // Floating live indicator
                        Positioned(
                          top: 15,
                          right: 15,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.3),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "LIVE",
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
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
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTechChip(String tech) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: websiteData.themeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: websiteData.themeColor.withOpacity(0.3),
        ),
      ),
      child: Text(
        tech,
        style: GoogleFonts.inter(
          color: websiteData.themeColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildVisitWebsiteButton(VoidCallback onPressed) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            websiteData.themeColor,
            websiteData.themeColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: websiteData.themeColor.withOpacity(0.4),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.launch,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  "VISIT WEBSITE",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed,
      {bool outlined = false}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : websiteData.themeColor,
        borderRadius: BorderRadius.circular(25),
        border: outlined
            ? Border.all(color: websiteData.themeColor, width: 2)
            : null,
        boxShadow: outlined
            ? null
            : [
          BoxShadow(
            color: websiteData.themeColor.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_forward,
                  color: outlined ? websiteData.themeColor : Colors.white,
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: outlined ? websiteData.themeColor : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
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

// Custom painter for web-themed background
class WebBackgroundPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  WebBackgroundPainter({required this.animation, required this.color})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.02)
      ..style = PaintingStyle.fill;

    // Animated grid pattern
    double offset = animation.value * 50;
    const spacing = 60.0;

    for (double x = -spacing + offset; x < size.width + spacing; x += spacing) {
      for (double y = -spacing + offset; y < size.height + spacing; y += spacing) {
        // Draw subtle dots at intersections
        canvas.drawCircle(Offset(x, y), 2, fillPaint);

        // Draw connecting lines
        if (x + spacing < size.width + spacing) {
          canvas.drawLine(Offset(x, y), Offset(x + spacing, y), paint);
        }
        if (y + spacing < size.height + spacing) {
          canvas.drawLine(Offset(x, y), Offset(x, y + spacing), paint);
        }
      }
    }

    // Add some floating geometric shapes
    final shapePaint = Paint()
      ..color = color.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    double floatOffset = animation.value * 20;

    // Floating rectangles
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.8, 100 + floatOffset, 60, 40),
        Radius.circular(8),
      ),
      shapePaint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.1, size.height * 0.7 - floatOffset, 80, 50),
        Radius.circular(12),
      ),
      shapePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}