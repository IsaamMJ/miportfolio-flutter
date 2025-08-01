import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/constants.dart';
import '../../../utils/screen_helper.dart';

class AppCarousel extends StatefulWidget {
  @override
  _AppCarouselState createState() => _AppCarouselState();
}

class _AppCarouselState extends State<AppCarousel>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int currentPage = 0;
  late AnimationController _indicatorController;
  late AnimationController _fadeController;

  final List<Widget> apps = [
    SkyFeedAppAd(),
    WeatherProAppAd(),
    NewsHubAppAd(),
  ];

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
    return Container(
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
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: BackgroundPatternPainter(),
            ),
          ),

          // Main carousel
          FadeTransition(
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
                return apps[index];
              },
            ),
          ),

          // Page indicators
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                apps.length,
                    (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: currentPage == index ? 32 : 8,
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

          // Navigation arrows for desktop
          if (MediaQuery.of(context).size.width > 720) ...[
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              child: Center(
                child: _buildNavButton(
                  Icons.arrow_back_ios,
                      () => _goToPage((currentPage - 1 + apps.length) % apps.length),
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
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: kPrimaryColor, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}

class SkyFeedAppAd extends StatelessWidget {
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
                Expanded(
                  flex: isDesktop ? 1 : 0,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: isDesktop ? double.infinity : 400),
                    child: Stack(
                      children: [
                        // Glow effect
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: kPrimaryColor.withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              "assets/skyfeed.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Floating elements
                        Positioned(
                          top: -10,
                          right: -10,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(Icons.wb_sunny, color: Colors.white, size: 24),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: isDesktop ? 50 : 0,
                  height: isDesktop ? 0 : 30,
                ),
                Expanded(
                  flex: isDesktop ? 1 : 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // App badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
                        ),
                        child: Text(
                          "FEATURED APP",
                          style: GoogleFonts.poppins(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

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
                            fontSize: 48,
                            height: 1.1,
                          ),
                        ),
                      ),

                      SizedBox(height: 15),
                      Text(
                        "PERSONALIZED NEWS &\nWEATHER FORECASTS",
                        style: GoogleFonts.poppins(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          fontSize: 24,
                          letterSpacing: 0.5,
                        ),
                      ),

                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Text(
                          "Experience the perfect blend of real-time weather data and curated news content. Our AI-powered platform delivers personalized insights that matter to you, when you need them most.",
                          style: GoogleFonts.inter(
                            color: Colors.grey[700],
                            height: 1.6,
                            fontSize: 16,
                          ),
                        ),
                      ),

                      SizedBox(height: 30),

                      // Rating and stats
                      Row(
                        children: [
                          _buildStatCard("4.8★", "Rating"),
                          SizedBox(width: 15),
                          _buildStatCard("50K+", "Downloads"),
                          SizedBox(width: 15),
                          _buildStatCard("Free", "Price"),
                        ],
                      ),

                      SizedBox(height: 30),

                      // Action buttons
                      Row(
                        children: [
                          _buildButton(
                            "EXPLORE APP",
                                () {},
                            primary: true,
                            icon: Icons.launch,
                          ),
                          SizedBox(width: 15),
                          _buildButton(
                            "NEXT",
                                () {
                              final state = context.findAncestorStateOfType<_AppCarouselState>();
                              state?._nextPage();
                            },
                            primary: false,
                            icon: Icons.arrow_forward,
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
              fontSize: 14,
              color: kPrimaryColor,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed,
      {required bool primary, IconData? icon}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: primary
            ? LinearGradient(
          colors: [kPrimaryColor, Colors.blue[400]!],
        )
            : null,
        color: primary ? null : Colors.white,
        borderRadius: BorderRadius.circular(25),
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
          borderRadius: BorderRadius.circular(25),
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: primary ? Colors.white : kPrimaryColor,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: primary ? Colors.white : kPrimaryColor,
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

class WeatherProAppAd extends StatelessWidget {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App icon with glow
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[400]!, Colors.purple[400]!],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.cloud,
                color: Colors.white,
                size: 60,
              ),
            ),

            SizedBox(height: 30),

            Text(
              "WeatherPro",
              style: GoogleFonts.poppins(
                fontSize: 42,
                fontWeight: FontWeight.w800,
                color: Colors.grey[800],
              ),
            ),

            SizedBox(height: 10),
            Text(
              "Advanced weather tracking with AI predictions",
              style: GoogleFonts.inter(
                fontSize: 18,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 40),

            // Features grid
            Wrap(
              spacing: 20,
              runSpacing: 15,
              children: [
                _buildFeatureChip("Real-time Updates", Icons.update),
                _buildFeatureChip("AI Predictions", Icons.psychology),
                _buildFeatureChip("Multi-location", Icons.location_on),
                _buildFeatureChip("Weather Alerts", Icons.notifications),
              ],
            ),

            SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: () {
                final state = context.findAncestorStateOfType<_AppCarouselState>();
                state?._nextPage();
              },
              icon: Icon(Icons.arrow_forward),
              label: Text("DISCOVER MORE"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[400],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.blue[400]),
          SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

class NewsHubAppAd extends StatelessWidget {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated news icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red[400]!, Colors.orange[400]!],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.newspaper,
                color: Colors.white,
                size: 60,
              ),
            ),

            SizedBox(height: 30),

            Text(
              "NewsHub",
              style: GoogleFonts.poppins(
                fontSize: 42,
                fontWeight: FontWeight.w800,
                color: Colors.grey[800],
              ),
            ),

            SizedBox(height: 10),
            Text(
              "Stay informed with personalized news curation",
              style: GoogleFonts.inter(
                fontSize: 18,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 40),

            // News categories
            Wrap(
              spacing: 15,
              runSpacing: 10,
              children: [
                _buildCategoryTag("Technology"),
                _buildCategoryTag("Business"),
                _buildCategoryTag("Sports"),
                _buildCategoryTag("Health"),
                _buildCategoryTag("Science"),
              ],
            ),

            SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.launch),
                  label: Text("EXPLORE"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                OutlinedButton.icon(
                  onPressed: () {
                    final state = context.findAncestorStateOfType<_AppCarouselState>();
                    state?._goToPage(0); // Go back to first app
                  },
                  icon: Icon(Icons.refresh),
                  label: Text("RESTART"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red[400],
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTag(String category) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Text(
        category,
        style: GoogleFonts.inter(
          fontSize: 12,
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

    const spacing = 50.0;

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