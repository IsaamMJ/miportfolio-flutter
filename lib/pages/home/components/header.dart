import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../models/header_item.dart';
import '../../../utils/constants.dart';
import '../../../utils/globals.dart';
import '../../../utils/screen_helper.dart';

// Add GlobalKeys for each section you want to navigate to
final GlobalKey homeKey = GlobalKey();
final GlobalKey aboutKey = GlobalKey();
final GlobalKey servicesKey = GlobalKey();
final GlobalKey portfolioKey = GlobalKey();
final GlobalKey testimonialsKey = GlobalKey();
final GlobalKey blogsKey = GlobalKey();
final GlobalKey contactKey = GlobalKey();

// Enhanced navigation function
void scrollToSection(GlobalKey key) {
  final context = key.currentContext;
  if (context != null) {
    Scrollable.ensureVisible(
      context,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }
}

List<HeaderItem> headerItems = [
  HeaderItem(
    title: "HOME",
    onTap: () => scrollToSection(homeKey),
  ),
  HeaderItem(
    title: "TECHNICAL SKILLS",
    onTap: () => scrollToSection(servicesKey),
  ),
  HeaderItem(
    title: "PORTFOLIO",
    onTap: () => scrollToSection(portfolioKey),
  ),
  HeaderItem(
    title: "PROFESSIONAL EXPERIENCE",
    onTap: () => scrollToSection(testimonialsKey),
  ),
  HeaderItem(
    title: "MY PROCESS",
    onTap: () => scrollToSection(blogsKey),
  ),
  HeaderItem(
    title: "HIRE ME",
    onTap: () => scrollToSection(contactKey),
    isButton: true,
  ),
];

class EnhancedHeader extends StatefulWidget {
  final ScrollController? scrollController;

  const EnhancedHeader({Key? key, this.scrollController}) : super(key: key);

  @override
  _EnhancedHeaderState createState() => _EnhancedHeaderState();
}

class _EnhancedHeaderState extends State<EnhancedHeader>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  bool _isScrolled = false;
  int _hoveredIndex = -1;
  int _activeIndex = 0;
  ScrollController? _scrollController;

  // 📱 RESPONSIVE BREAKPOINTS
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1440.0;

  // 📱 DEVICE TYPE DETECTION
  bool _isMobile(BuildContext context) => MediaQuery.of(context).size.width < mobileBreakpoint;
  bool _isTablet(BuildContext context) => MediaQuery.of(context).size.width >= mobileBreakpoint && MediaQuery.of(context).size.width < tabletBreakpoint;
  bool _isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= tabletBreakpoint;

  // 📏 RESPONSIVE UTILITIES
  double _getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= desktopBreakpoint) return 60.0; // Large desktop
    if (screenWidth >= tabletBreakpoint) return 40.0;  // Desktop/tablet
    if (screenWidth >= mobileBreakpoint) return 24.0;  // Large mobile
    return 16.0; // Mobile
  }

  double _getResponsiveFontSize(BuildContext context, {
    double mobile = 14.0,
    double tablet = 15.0,
    double desktop = 16.0,
  }) {
    if (_isDesktop(context)) return desktop;
    if (_isTablet(context)) return tablet;
    return mobile;
  }

  double _getLogoSize(BuildContext context) {
    if (_isDesktop(context)) return 26.0;
    if (_isTablet(context)) return 24.0;
    return 22.0;
  }

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    // Set up scroll controller
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController!.addListener(_onScroll);

    // Start animations
    _slideController.forward();
    _fadeController.forward();
  }

  void _onScroll() {
    final isScrolled = _scrollController!.offset > 50;
    if (isScrolled != _isScrolled) {
      setState(() {
        _isScrolled = isScrolled;
      });
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    if (widget.scrollController == null) {
      _scrollController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: _isScrolled ? 8 : 0,
      shadowColor: Colors.black.withOpacity(0.1),
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: _isMobile(context)
                ? _buildMobileHeader()
                : _isTablet(context)
                ? _buildTabletHeader()
                : _buildDesktopHeader(),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopHeader() {
    final horizontalPadding = _getResponsivePadding(context);

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: _isScrolled
          ? ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[200]!.withOpacity(0.5),
                  width: 1.0,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 25.0,
                  offset: Offset(0, 8),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1400.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildEnhancedLogo(),
                  _buildDesktopNavigation(),
                ],
              ),
            ),
          ),
        ),
      )
          : Container(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1400.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildEnhancedLogo(),
              _buildDesktopNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabletHeader() {
    final horizontalPadding = _getResponsivePadding(context);

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.90),
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[200]!.withOpacity(0.5),
                width: 1.0,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20.0,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildEnhancedLogo(),
              _buildMobileMenuButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileHeader() {
    final horizontalPadding = _getResponsivePadding(context);

    return SafeArea(
      bottom: false,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.90),
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[200]!.withOpacity(0.5),
                  width: 1.0,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20.0,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildEnhancedLogo(),
                _buildMobileMenuButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedLogo() {
    final logoSize = _getLogoSize(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => scrollToSection(homeKey),
        child: TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300),
          tween: Tween(begin: 0.0, end: _isScrolled ? 1.0 : 0.0),
          builder: (context, value, child) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(
                  horizontal: 10.0 + (value * 2),
                  vertical: 6.0 + (value * 2)
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue[600]!,
                    Colors.purple[600]!,
                  ],
                ),
                borderRadius: BorderRadius.circular(10.0 + (value * 3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue[300]!.withOpacity(0.3 + (value * 0.2)),
                    blurRadius: 12.0 + (value * 8),
                    offset: Offset(0, 4 + (value * 2)),
                  ),
                ],
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "M",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: logoSize + (value * 2),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: ".",
                      style: GoogleFonts.inter(
                        color: Colors.yellow[300],
                        fontSize: logoSize + 4 + (value * 2),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDesktopNavigation() {
    return Flexible(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: headerItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return _buildNavItem(item, index);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNavItem(HeaderItem item, int index) {
    final isHovered = _hoveredIndex == index;
    final isActive = _activeIndex == index;
    final isButton = item.isButton;
    final fontSize = _getResponsiveFontSize(context, mobile: 13.0, tablet: 14.0, desktop: 14.0);

    if (isButton) {
      return _buildHireMeButton(item, index);
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = -1),
      child: GestureDetector(
        onTap: () {
          setState(() => _activeIndex = index);
          item.onTap();
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.only(right: _isDesktop(context) ? 28.0 : 20.0),
          padding: EdgeInsets.symmetric(
              horizontal: _isDesktop(context) ? 16.0 : 12.0,
              vertical: 10.0
          ),
          decoration: BoxDecoration(
            color: isHovered || isActive
                ? Colors.blue[50]?.withOpacity(_isScrolled ? 0.8 : 0.6)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10.0),
            border: isActive
                ? Border(
              bottom: BorderSide(
                color: Colors.blue[600]!,
                width: 2.5,
              ),
            )
                : null,
          ),
          child: Text(
            item.title,
            style: GoogleFonts.inter(
              color: isHovered || isActive
                  ? Colors.blue[700]
                  : _isScrolled
                  ? Colors.grey[700]
                  : Colors.grey[600],
              fontSize: fontSize,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHireMeButton(HeaderItem item, int index) {
    final isHovered = _hoveredIndex == index;
    final fontSize = _getResponsiveFontSize(context, mobile: 13.0, tablet: 14.0, desktop: 14.0);
    final horizontalPadding = _isDesktop(context) ? 28.0 : 20.0;
    final verticalPadding = _isDesktop(context) ? 14.0 : 12.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = -1),
      child: GestureDetector(
        onTap: item.onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isHovered
                  ? [Colors.orange[400]!, Colors.red[400]!]
                  : [Colors.orange[500]!, Colors.red[500]!],
            ),
            borderRadius: BorderRadius.circular(30.0),
            boxShadow: [
              BoxShadow(
                color: Colors.orange[300]!.withOpacity(isHovered ? 0.5 : 0.4),
                blurRadius: isHovered ? 20.0 : 15.0,
                offset: Offset(0, isHovered ? 8 : 5),
                spreadRadius: isHovered ? 1 : 0,
              ),
            ],
          ),
          transform: isHovered
              ? Matrix4.translationValues(0, -2, 0)
              : Matrix4.identity(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.work_outline,
                color: Colors.white,
                size: fontSize + 4,
              ),
              SizedBox(width: 8.0),
              Text(
                item.title,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileMenuButton() {
    final iconSize = _isMobile(context) ? 22.0 : 24.0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Use the drawer from Globals instead of bottom sheet
          Globals.scaffoldKey.currentState?.openEndDrawer();
        },
        child: Container(
          padding: EdgeInsets.all(_isMobile(context) ? 8.0 : 10.0),
          decoration: BoxDecoration(
            color: Colors.grey[100]?.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.grey[300]!.withOpacity(0.5),
              width: 1.0,
            ),
          ),
          child: Icon(
            FeatherIcons.menu,
            color: Colors.grey[700],
            size: iconSize,
          ),
        ),
      ),
    );
  }

// Remove the old mobile menu methods since we're using the drawer from home page
}