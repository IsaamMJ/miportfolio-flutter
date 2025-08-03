import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

import '../../../utils/constants.dart';
import '../../../utils/responsive_helper.dart'; // Import your ResponsiveHelper

class HeroSection extends StatefulWidget {
  @override
  _HeroSectionState createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _floatController;
  late AnimationController _counterController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatAnimation;

  bool _isGitHubHovered = false;
  bool _isResumeHovered = false;
  bool _isProjectLinkHovered = false;

  // Animated counters
  int _projectsCount = 0;
  int _yearsCount = 0;

  // 🔧 IMPROVED HEIGHT CALCULATION using ResponsiveHelper
  double _getMinHeroHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    if (ResponsiveHelper.isMobile(context)) {
      return screenHeight * 0.75; // Reduced for mobile to prevent overflow
    } else if (ResponsiveHelper.isTablet(context)) {
      return screenHeight * 0.80;
    }
    return screenHeight * 0.85; // More conservative on desktop too
  }

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _floatController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    _counterController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(-0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _floatAnimation = Tween<double>(
      begin: -8.0,
      end: 8.0,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(Duration(milliseconds: 300));
    _fadeController.forward();

    await Future.delayed(Duration(milliseconds: 200));
    _slideController.forward();

    await Future.delayed(Duration(milliseconds: 300));
    _scaleController.forward();

    // Start floating animation and repeat
    _floatController.repeat(reverse: true);

    // Start counter animations
    await Future.delayed(Duration(milliseconds: 800));
    _startCounterAnimations();
  }

  void _startCounterAnimations() {
    _counterController.addListener(() {
      setState(() {
        _projectsCount = (20 * _counterController.value).round();
        _yearsCount = (1 * _counterController.value).round();
      });
    });
    _counterController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _floatController.dispose();
    _counterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // 🔧 FLEXIBLE HEIGHT - Use constraints instead of fixed height
      constraints: BoxConstraints(
        minHeight: _getMinHeroHeight(context),
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFF8FAFF),
            Colors.white,
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: _buildResponsiveLayout(context),
    );
  }

  Widget _buildResponsiveLayout(BuildContext context) {
    if (ResponsiveHelper.isMobile(context)) {
      return _buildMobileLayout(context);
    } else if (ResponsiveHelper.isTablet(context)) {
      return _buildTabletLayout(context);
    } else {
      return _buildDesktopLayout(context);
    }
  }

  // Desktop Layout - Centered content with better balance
  Widget _buildDesktopLayout(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 1200.0),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getResponsivePadding(context),
          vertical: ResponsiveHelper.getResponsiveValue(
            context,
            mobile: 40.0,
            tablet: 50.0,
            desktop: 60.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.only(right: 30.0),
                child: _buildTextContent(),
              ),
            ),
            Expanded(
              flex: 4,
              child: _buildImage(),
            ),
          ],
        ),
      ),
    );
  }

  // Tablet Layout - Centered content with adjusted proportions
  Widget _buildTabletLayout(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 1000.0),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getResponsivePadding(context),
          vertical: ResponsiveHelper.getResponsiveValue(
            context,
            mobile: 30.0,
            tablet: 40.0,
            desktop: 50.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.only(right: 24.0),
                child: _buildTextContent(),
              ),
            ),
            Expanded(
              flex: 4,
              child: _buildImage(),
            ),
          ],
        ),
      ),
    );
  }

  // 🔧 IMPROVED MOBILE LAYOUT - Centered content
  Widget _buildMobileLayout(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 600.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getResponsivePadding(context),
            vertical: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 20.0,
              tablet: 30.0,
              desktop: 40.0,
            ),
          ),
          child: Column(
            children: [
              // Text content with flexible height - only content on mobile
              Container(
                width: double.infinity,
                child: _buildTextContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Enhanced Text Content Widget with responsive design
  Widget _buildTextContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          mainAxisAlignment: ResponsiveHelper.isMobile(context)
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Professional badges with responsive sizing
            ScaleTransition(
              scale: _scaleAnimation,
              child: _buildProfessionalBadges(),
            ),

            SizedBox(height: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 16.0,
              tablet: 20.0,
              desktop: 24.0,
            )),

            // Enhanced name with responsive typography
            _buildHeroTitle(),

            SizedBox(height: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 8.0,
              tablet: 10.0,
              desktop: 12.0,
            )),

            // Enhanced professional title
            _buildSubtitle(),

            SizedBox(height: 6.0),

            // Location and specialization
            _buildLocationInfo(),

            SizedBox(height: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 16.0,
              tablet: 20.0,
              desktop: 24.0,
            )),

            // Achievement metrics
            _buildAchievementMetrics(),

            SizedBox(height: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 16.0,
              tablet: 20.0,
              desktop: 24.0,
            )),

            // Enhanced call-to-action text
            _buildCallToActionText(),

            SizedBox(height: ResponsiveHelper.getResponsiveValue(
              context,
              mobile: 20.0,
              tablet: 24.0,
              desktop: 32.0,
            )),

            // Enhanced buttons with responsive layout
            _buildActionButtons(),

            // 🔧 ADDED BOTTOM PADDING for mobile to prevent button cutoff
            if (ResponsiveHelper.isMobile(context))
              SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalBadges() {
    return Wrap(
      spacing: 12.0,
      runSpacing: 8.0,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.isMobile(context) ? 12.0 : 16.0,
            vertical: ResponsiveHelper.isMobile(context) ? 6.0 : 8.0,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF02569B).withOpacity(0.1), Color(0xFF0175C2).withOpacity(0.2)],
            ),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Color(0xFF0175C2).withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.flutter_dash,
                color: Color(0xFF02569B),
                size: ResponsiveHelper.isMobile(context) ? 14 : 16,
              ),
              SizedBox(width: 6),
              Text(
                "FLUTTER EXPERT",
                style: GoogleFonts.inter(
                  color: Color(0xFF02569B),
                  fontWeight: FontWeight.w700,
                  fontSize: ResponsiveHelper.isMobile(context) ? 11.0 : 13.0,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.isMobile(context) ? 10.0 : 12.0,
            vertical: ResponsiveHelper.isMobile(context) ? 5.0 : 6.0,
          ),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: ResponsiveHelper.isMobile(context) ? 6 : 8,
                height: ResponsiveHelper.isMobile(context) ? 6 : 8,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6),
              Text(
                "Available",
                style: GoogleFonts.inter(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: ResponsiveHelper.isMobile(context) ? 10.0 : 12.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeroTitle() {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [Colors.black, Colors.grey.shade800, Colors.black],
        stops: [0.0, 0.5, 1.0],
      ).createShader(bounds),
      child: Text(
        "MOHAMED\nISAAM M J",
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: _getHeroTitleSize(),
          fontWeight: FontWeight.w900,
          height: 1.1,
          letterSpacing: -1.0,
        ),
      ),
    );
  }

  double _getHeroTitleSize() {
    if (ResponsiveHelper.isMobile(context)) {
      final screenWidth = MediaQuery.of(context).size.width;
      if (screenWidth < 360) return 26.0; // Very small screens - reduced
      if (screenWidth < 400) return 30.0; // Small screens - reduced
      return 34.0; // Regular mobile - reduced
    } else if (ResponsiveHelper.isTablet(context)) {
      return 40.0; // Reduced
    }
    return 46.0; // Desktop - reduced
  }

  Widget _buildSubtitle() {
    return Text(
      "Cross-Platform Mobile & Web Developer",
      style: GoogleFonts.inter(
        color: Colors.grey.shade600,
        fontSize: ResponsiveHelper.getResponsiveFontSize(
          context,
          mobile: 15.0,
          tablet: 17.0,
          desktop: 19.0,
        ),
        height: 1.3,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: ResponsiveHelper.isMobile(context) ? 14 : 16,
          color: kPrimaryColor,
        ),
        SizedBox(width: 4),
        Flexible(
          child: Text(
            "India • Flutter • iOS • Android • Web",
            style: GoogleFonts.inter(
              color: ResponsiveHelper.isMobile(context) ? kCaptionColor : kPrimaryColor,
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 12.0,
                tablet: 13.0,
                desktop: 14.0,
              ),
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Achievement metrics widget with responsive design
  Widget _buildAchievementMetrics() {
    return Wrap(
      spacing: ResponsiveHelper.isMobile(context) ? 20.0 : 32.0,
      runSpacing: 10.0,
      children: [
        _buildMetric("$_projectsCount+", "Projects", Icons.apps),
        _buildMetric("${_yearsCount}+", "Years", Icons.timeline),
        _buildMetric("99.9%", "Client Satisfaction", Icons.star),
      ],
    );
  }

  Widget _buildMetric(String value, String label, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: ResponsiveHelper.isMobile(context) ? 14 : 16,
              color: kPrimaryColor,
            ),
            SizedBox(width: 4),
            Text(
              value,
              style: GoogleFonts.inter(
                color: Colors.black87,
                fontSize: ResponsiveHelper.getResponsiveFontSize(
                  context,
                  mobile: 15.0,
                  tablet: 16.0,
                  desktop: 17.0,
                ),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.inter(
            color: kCaptionColor,
            fontSize: ResponsiveHelper.getResponsiveFontSize(
              context,
              mobile: 10.0,
              tablet: 11.0,
              desktop: 12.0,
            ),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCallToActionText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: GoogleFonts.inter(
              color: kCaptionColor,
              fontSize: ResponsiveHelper.getResponsiveFontSize(
                context,
                mobile: 13.0,
                tablet: 14.0,
                desktop: 15.0,
              ),
              height: 1.5,
            ),
            children: [
              TextSpan(text: "Need a "),
              TextSpan(
                text: "production-ready app",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(text: "? "),
            ],
          ),
        ),
        SizedBox(height: 6.0),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isProjectLinkHovered = true),
          onExit: (_) => setState(() => _isProjectLinkHovered = false),
          child: GestureDetector(
            onTap: () {
              // Add scroll to contact or open contact modal
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                gradient: _isProjectLinkHovered
                    ? LinearGradient(colors: [kPrimaryColor.withOpacity(0.1), kPrimaryColor.withOpacity(0.2)])
                    : null,
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      "Let's build something amazing together",
                      style: GoogleFonts.inter(
                        height: 1.5,
                        color: _isProjectLinkHovered ? kPrimaryColor : Colors.black87,
                        fontSize: ResponsiveHelper.getResponsiveFontSize(
                          context,
                          mobile: 13.0,
                          tablet: 14.0,
                          desktop: 15.0,
                        ),
                        fontWeight: FontWeight.w600,
                        decoration: _isProjectLinkHovered ? TextDecoration.underline : null,
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: ResponsiveHelper.isMobile(context) ? 14 : 16,
                    color: _isProjectLinkHovered ? kPrimaryColor : Colors.black87,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 🔧 IMPROVED ACTION BUTTONS with better spacing using ResponsiveHelper
  Widget _buildActionButtons() {
    final buttons = [
      _buildAnimatedButton(
        text: "VIEW PROJECTS",
        isHovered: _isGitHubHovered,
        onHover: (hovered) => setState(() => _isGitHubHovered = hovered),
        onPressed: () async {
          final Uri url = Uri.parse('https://github.com/IsaamMJ');
          if (await canLaunchUrl(url)) {
            await launchUrl(
              url,
              mode: LaunchMode.externalApplication,
            );
          } else {
            print('Could not launch $url');
          }
        },
        icon: Icons.work,
      ),
      _buildAnimatedButton(
        text: "DOWNLOAD RESUME",
        isHovered: _isResumeHovered,
        onHover: (hovered) => setState(() => _isResumeHovered = hovered),
        onPressed: () async {
          final Uri url = Uri.parse('https://drive.google.com/drive/folders/1645fWZIewZvWyOpMQlTPBr6yPx0XQ8YI?usp=drive_link');
          if (await canLaunchUrl(url)) {
            await launchUrl(
              url,
              mode: LaunchMode.externalApplication,
            );
          } else {
            print('Could not launch $url');
          }
        },
        icon: Icons.download,
        isSecondary: true,
      ),
    ];

    if (ResponsiveHelper.isMobile(context)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buttons[0],
          SizedBox(height: 10.0),
          buttons[1],
        ],
      );
    } else {
      return Wrap(
        spacing: 16.0,
        runSpacing: 12.0,
        children: buttons,
      );
    }
  }

  // 🔧 IMPROVED BUTTON with ResponsiveHelper
  Widget _buildAnimatedButton({
    required String text,
    required bool isHovered,
    required Function(bool) onHover,
    required VoidCallback onPressed,
    required IconData icon,
    bool isSecondary = false,
  }) {
    final buttonHeight = ResponsiveHelper.isMobile(context) ? 48.0 : 52.0;
    final horizontalPadding = ResponsiveHelper.isMobile(context) ? 18.0 : 22.0;
    final fontSize = ResponsiveHelper.getResponsiveFontSize(
      context,
      mobile: 11.0,
      tablet: 12.0,
      desktop: 13.0,
    );
    final iconSize = ResponsiveHelper.isMobile(context) ? 15.0 : 17.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: isSecondary
              ? (isHovered
              ? LinearGradient(colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.8)])
              : LinearGradient(colors: [Colors.transparent, Colors.transparent]))
              : LinearGradient(
            colors: isHovered
                ? [kPrimaryColor.withOpacity(0.9), kPrimaryColor]
                : [kPrimaryColor, kPrimaryColor.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(12.0),
          border: isSecondary ? Border.all(color: kPrimaryColor, width: 2.0) : null,
          boxShadow: isHovered
              ? [
            BoxShadow(
              color: kPrimaryColor.withOpacity(0.4),
              blurRadius: 20.0,
              offset: Offset(0, 8),
              spreadRadius: 2,
            ),
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        height: buttonHeight,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12.0),
            onTap: onPressed,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                mainAxisSize: ResponsiveHelper.isMobile(context)
                    ? MainAxisSize.max
                    : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: isSecondary
                        ? (isHovered ? Colors.white : kPrimaryColor)
                        : Colors.white,
                    size: iconSize,
                  ),
                  SizedBox(width: 8),
                  Text(
                    text,
                    style: GoogleFonts.inter(
                      color: isSecondary
                          ? (isHovered ? Colors.white : kPrimaryColor)
                          : Colors.white,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔧 IMPROVED IMAGE with ResponsiveHelper
  Widget _buildImage() {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value * (ResponsiveHelper.isMobile(context) ? 0.4 : 0.8)),
          child: Container(
            padding: EdgeInsets.all(ResponsiveHelper.isMobile(context) ? 12.0 : 16.0),
            child: Stack(
              children: [
                // Background glow effect
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          kPrimaryColor.withOpacity(0.05),
                          Colors.transparent,
                        ],
                        radius: 0.8,
                      ),
                    ),
                  ),
                ),
                // Main image with aspect ratio
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.isMobile(context) ? 18.0 : 22.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: ResponsiveHelper.isMobile(context) ? 12.0 : 16.0,
                              offset: Offset(0, ResponsiveHelper.isMobile(context) ? 4 : 6),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.isMobile(context) ? 18.0 : 22.0,
                          ),
                          child: Image.asset(
                            "assets/person.png",
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}