import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

// Import for math functions
import 'dart:math' as math;
import '../../../models/design_process.dart';
import '../../../utils/constants.dart';
import '../../../utils/screen_helper.dart';

final List<DesignProcess> designProcesses = [
  DesignProcess(
    title: "DESIGN",
    imagePath: "assets/design.png",
    subtitle:
    "Crafting sleek, intuitive UI/UX for cross-platform apps that users love to use.",
  ),
  DesignProcess(
    title: "DEVELOP",
    imagePath: "assets/develop.png",
    subtitle:
    "Building high-performance Flutter apps with clean architecture and scalable code.",
  ),
  DesignProcess(
    title: "WRITE",
    imagePath: "assets/write.png",
    subtitle:
    "Writing maintainable, efficient Dart code that powers seamless mobile experiences.",
  ),
  DesignProcess(
    title: "PROMOTE",
    imagePath: "assets/promote.png",
    subtitle:
    "Optimizing apps for visibility, performance, and user growth on the Play Store.",
  ),
];

class CvSection extends StatefulWidget {
  @override
  _CvSectionState createState() => _CvSectionState();
}

class _CvSectionState extends State<CvSection>
    with TickerProviderStateMixin {
  late AnimationController _staggerController;
  late AnimationController _floatingController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;
  late Animation<double> _titleAnimation;

  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    _staggerController = AnimationController(
      duration: Duration(milliseconds: 1800),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    // Title animation
    _titleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _staggerController,
      curve: Interval(0.0, 0.3, curve: Curves.easeOutCubic),
    ));

    // Fixed staggered animations with proper intervals
    _fadeAnimations = List.generate(
      designProcesses.length,
          (index) => Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _staggerController,
        curve: Interval(
          // Fixed intervals to ensure end <= 1.0
          (0.2 + (index * 0.1)).clamp(0.0, 0.8),
          (0.5 + (index * 0.1)).clamp(0.3, 1.0),
          curve: Curves.easeOutCubic,
        ),
      )),
    );

    _slideAnimations = List.generate(
      designProcesses.length,
          (index) => Tween<Offset>(
        begin: Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _staggerController,
        curve: Interval(
          // Fixed intervals to ensure end <= 1.0
          (0.2 + (index * 0.1)).clamp(0.0, 0.8),
          (0.5 + (index * 0.1)).clamp(0.3, 1.0),
          curve: Curves.easeOutCubic,
        ),
      )),
    );

    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    if (!_isVisible && mounted) {
      _isVisible = true;
      _staggerController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 20.0),
      child: ScreenHelper(
        desktop: _buildUi(context, kDesktopMaxWidth),
        tablet: _buildUi(context, kTabletMaxWidth),
        mobile: _buildUi(context, getMobileMaxWidth(context)),
      ),
    );
  }

  Widget _buildUi(BuildContext context, double width) {
    // Trigger animation when widget becomes visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimation();
    });

    return Container(
      alignment: Alignment.center,
      child: MaxWidthBox(
        maxWidth: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Enhanced Header Section
            FadeTransition(
              opacity: _titleAnimation,
              child: Column(
                children: [
                  // Process Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          kPrimaryColor.withOpacity(0.1),
                          kPrimaryColor.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                      border: Border.all(
                        color: kPrimaryColor.withOpacity(0.3),
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      "MY PROCESS",
                      style: GoogleFonts.inter(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.0,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),

                  SizedBox(height: 24.0),

                  // Main Title with Gradient
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        kPrimaryColor,
                        kPrimaryColor.withOpacity(0.8),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      "BETTER DESIGN,\nBETTER EXPERIENCES",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                        fontSize: ScreenHelper.isMobile(context) ? 24.0 : 32.0,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),

                  SizedBox(height: 16.0),

                  // Subtitle
                  Text(
                    "From concept to launch, here's how I bring your vision to life",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: kCaptionColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),

                  // Decorative Line
                  SizedBox(height: 24.0),
                  Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [kPrimaryColor.withOpacity(0.3), kPrimaryColor],
                      ),
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 60.0),

            // Enhanced Process Grid with Fixed Layout
            LayoutBuilder(
              builder: (_context, constraints) {
                return _buildResponsiveGrid(constraints);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveGrid(BoxConstraints constraints) {
    final isDesktop = ScreenHelper.isDesktop(context);
    final isTablet = ScreenHelper.isTablet(context);
    final isMobile = ScreenHelper.isMobile(context);

    // Calculate responsive parameters
    int crossAxisCount;
    double childAspectRatio;
    double mainAxisSpacing;
    double crossAxisSpacing;

    if (isDesktop) {
      crossAxisCount = 4;
      childAspectRatio = 0.8;
      mainAxisSpacing = 30.0;
      crossAxisSpacing = 30.0;
    } else if (isTablet) {
      crossAxisCount = 2;
      childAspectRatio = 1.0;
      mainAxisSpacing = 25.0;
      crossAxisSpacing = 25.0;
    } else {
      crossAxisCount = 1;
      childAspectRatio = 1.2;
      mainAxisSpacing = 20.0;
      crossAxisSpacing = 20.0;
    }

    return GridView.builder(
      padding: EdgeInsets.all(0.0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
      ),
      itemBuilder: (BuildContext context, int index) {
        return _buildProcessCard(context, index);
      },
      itemCount: designProcesses.length,
    );
  }

  Widget _buildProcessCard(BuildContext context, int index) {
    final process = designProcesses[index];

    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimations[index],
          child: FadeTransition(
            opacity: _fadeAnimations[index],
            child: Transform.translate(
              offset: Offset(
                0,
                math.sin(_floatingController.value * 2 * math.pi + index) * 3,
              ),
              child: Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20.0,
                      offset: Offset(0, 8),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: kPrimaryColor.withOpacity(0.05),
                      blurRadius: 30.0,
                      offset: Offset(0, 15),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Enhanced Header with Number Badge
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Step Number Badge
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                kPrimaryColor.withOpacity(0.8),
                                kPrimaryColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Center(
                            child: Text(
                              "${index + 1}",
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 12.0),

                        // Icon with Background
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.asset(
                              process.imagePath,
                              width: 24.0,
                              height: 24.0,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.image_not_supported,
                                  color: kPrimaryColor,
                                  size: 24.0,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(width: 12.0),

                    // Title
                    Text(
                      process.title,
                      style: GoogleFonts.inter(
                        fontSize: ScreenHelper.isMobile(context) ? 16.0 : 18.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 16.0),

                    // Enhanced Description
                    Expanded(
                      child: Text(
                        process.subtitle,
                        style: GoogleFonts.inter(
                          color: kCaptionColor,
                          height: 1.4,
                          fontSize: ScreenHelper.isMobile(context) ? 13.0 : 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(height: 16.0),

                    // Progress Indicator
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  kPrimaryColor.withOpacity(0.3),
                                  kPrimaryColor,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(1.0),
                            ),
                          ),
                        ),

                        if (index < designProcesses.length - 1) ...[
                          SizedBox(width: 6.0),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: kPrimaryColor.withOpacity(0.6),
                            size: 14.0,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}