// FIXED WebsiteCarousel.dart - NO SEPARATE SCROLLING (Removed PageView)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../data/models/website_data.dart';
import '../../../../data/repositories/portfolio_repository.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/screen_helper.dart';

class WebsiteCarousel extends StatefulWidget {
  @override
  _WebsiteCarouselState createState() => _WebsiteCarouselState();
}

class _WebsiteCarouselState extends State<WebsiteCarousel>
    with TickerProviderStateMixin {
  int currentPage = 0;
  late AnimationController _fadeController;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;

  // Use repository to get website data
  final PortfolioRepository _repository = PortfolioRepository();
  late List<WebsiteData> websites;

  // 📱 RESPONSIVE UTILITIES
  bool _isMobile(BuildContext context) => MediaQuery.of(context).size.width < 768.0;
  bool _isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 768.0 && MediaQuery.of(context).size.width < 1024.0;
  bool _isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1024.0;

  @override
  void initState() {
    super.initState();

    // Initialize websites from repository
    websites = _repository.getWebsites();

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: Duration(seconds: 3),
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
    _goToPage((currentPage + 1) % websites.length);
  }

  void _goToPage(int page) {
    if (page != currentPage && websites.isNotEmpty) {
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
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (websites.isEmpty) {
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
          colors: [
            Colors.grey[50]!,
            Colors.white,
            websites[currentPage].themeColor.withOpacity(0.05),
          ],
        ),
      ),
      child: Stack(
        fit: StackFit.expand, // Important: makes stack fill the container
        children: [
          // Animated background elements
          CustomPaint(
            painter: WebBackgroundPainter(
              animation: _floatingController,
              color: websites[currentPage].themeColor,
            ),
          ),

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
                              () => _goToPage((currentPage - 1 + websites.length) % websites.length),
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
                                _goToPage((currentPage - 1 + websites.length) % websites.length);
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
                              child: WebsiteAd(
                                websiteData: websites[currentPage],
                                onNext: _nextPage,
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
                              "Swipe to explore websites",
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
                        // Website title
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          margin: EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: websites[currentPage].themeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: websites[currentPage].themeColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            websites[currentPage].title,
                            style: GoogleFonts.inter(
                              color: websites[currentPage].themeColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        // Dot indicators
                        ...List.generate(
                          websites.length,
                              (index) => GestureDetector(
                            onTap: () => _goToPage(index),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              margin: EdgeInsets.symmetric(horizontal: 2),
                              width: currentPage == index ? 20 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: currentPage == index
                                    ? websites[currentPage].themeColor
                                    : websites[currentPage].themeColor.withOpacity(0.3),
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
        border: Border.all(color: websites[currentPage].themeColor.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: websites[currentPage].themeColor.withOpacity(0.2),
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
              color: websites[currentPage].themeColor,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}

// FIXED WebsiteAd widget - Simplified and no scrolling
class WebsiteAd extends StatelessWidget {
  final WebsiteData websiteData;
  final VoidCallback onNext;

  const WebsiteAd({
    required this.websiteData,
    required this.onNext,
  });

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
        height: double.infinity, // Fill available height
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isDesktop = constraints.maxWidth > 720;

            // REMOVED SingleChildScrollView - this was causing scrolling issues
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Flex(
                    direction: isDesktop ? Axis.horizontal : Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Content Section - FIXED: Better constraints
                      Flexible(
                        flex: isDesktop ? 1 : 0,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: isDesktop ? double.infinity : 500,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min, // Important: don't expand unnecessarily
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

                              SizedBox(height: 20),

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
                                    fontSize: isDesktop ? 36 : 28, // Reduced font size
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
                                  fontSize: isDesktop ? 12 : 10,
                                  letterSpacing: 2,
                                ),
                              ),

                              SizedBox(height: 16),

                              // Description in card - FIXED: Constraint height to prevent overflow
                              Container(
                                constraints: BoxConstraints(
                                  maxHeight: isDesktop ? 120 : 100, // Limit height
                                ),
                                padding: EdgeInsets.all(isDesktop ? 20 : 16),
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
                                    height: 1.5,
                                    fontSize: isDesktop ? 14 : 12,
                                  ),
                                  maxLines: isDesktop ? 4 : 3, // Limit lines
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                              SizedBox(height: 16),

                              // Tech stack - FIXED: Better wrapping and constraints
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: isDesktop ? double.infinity : 400,
                                ),
                                child: Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: websiteData.technologies
                                      .take(4) // Limit number of tech chips
                                      .map((tech) => _buildTechChip(tech))
                                      .toList(),
                                ),
                              ),

                              SizedBox(height: 20),

                              // Action buttons
                              Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                children: [
                                  _buildVisitWebsiteButton(_launchUrl),
                                  _buildButton("NEXT PROJECT", onNext, outlined: true),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        width: isDesktop ? 40 : 0,
                        height: isDesktop ? 0 : 20,
                      ),

                      // Image Section - FIXED: Better constraints
                      Flexible(
                        flex: isDesktop ? 1 : 0,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: isDesktop ? double.infinity : 350,
                            maxHeight: isDesktop ? 400 : 250, // Limit height
                          ),
                          child: Stack(
                            children: [
                              // Main image
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: websiteData.themeColor.withOpacity(0.3),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: AspectRatio(
                                      aspectRatio: 4/3,
                                      child: Image.asset(
                                        websiteData.imageAsset,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Live indicator
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.withOpacity(0.3),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "LIVE",
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 9,
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
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: websiteData.themeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: websiteData.themeColor.withOpacity(0.3),
        ),
      ),
      child: Text(
        tech,
        style: GoogleFonts.inter(
          color: websiteData.themeColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildVisitWebsiteButton(VoidCallback onPressed) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            websiteData.themeColor,
            websiteData.themeColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: websiteData.themeColor.withOpacity(0.4),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.launch,
                  color: Colors.white,
                  size: 16,
                ),
                SizedBox(width: 6),
                Text(
                  "VISIT WEBSITE",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
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

  Widget _buildButton(String label, VoidCallback onPressed, {bool outlined = false}) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : websiteData.themeColor,
        borderRadius: BorderRadius.circular(22),
        border: outlined ? Border.all(color: websiteData.themeColor, width: 2) : null,
        boxShadow: outlined ? null : [
          BoxShadow(
            color: websiteData.themeColor.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_forward,
                  color: outlined ? websiteData.themeColor : Colors.white,
                  size: 16,
                ),
                SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: outlined ? websiteData.themeColor : Colors.white,
                    fontSize: 12,
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

// Simplified background painter
class WebBackgroundPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  WebBackgroundPainter({required this.animation, required this.color})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.04)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final spacing = 50.0;
    double offset = animation.value * 25;

    // Simple animated grid
    for (double x = -spacing + offset; x < size.width + spacing; x += spacing) {
      for (double y = -spacing + offset; y < size.height + spacing; y += spacing) {
        if (x >= -spacing && x <= size.width + spacing &&
            y >= -spacing && y <= size.height + spacing) {
          // Draw subtle dots
          canvas.drawCircle(Offset(x, y), 1.5, paint);

          // Draw lines
          if (x + spacing < size.width + spacing) {
            canvas.drawLine(Offset(x, y), Offset(x + spacing, y), paint);
          }
          if (y + spacing < size.height + spacing) {
            canvas.drawLine(Offset(x, y), Offset(x, y + spacing), paint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}