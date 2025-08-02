import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/models/stat.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/screen_helper.dart';

final List<Stat> stats = [
  Stat(count: "1", text: "Apps\nDeployed", icon: Icons.mobile_friendly),
  Stat(count: "2", text: "Happy\nClients", icon: Icons.sentiment_very_satisfied),
  Stat(count: "235", text: "Github \nCommits", icon: Icons.commit),
  Stat(count: "1+", text: "Years\nExperience", icon: Icons.timeline),
];

class PortfolioStats extends StatefulWidget {
  @override
  _PortfolioStatsState createState() => _PortfolioStatsState();
}

class _PortfolioStatsState extends State<PortfolioStats>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _bounceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  List<int> _animatedCounts = [0, 0, 0, 0];
  final List<int> _targetCounts = [1, 3, 235, 1];

  bool _hasAnimated = false;

  // Enhanced responsive breakpoints
  static const double mobileSmall = 320.0;
  static const double mobileLarge = 480.0;
  static const double tabletSmall = 600.0;
  static const double tabletLarge = 768.0;
  static const double desktopSmall = 1024.0;
  static const double desktopMedium = 1200.0;
  static const double desktopLarge = 1440.0;

  // Responsive utility methods
  bool _isMobileSmall(BuildContext context) => MediaQuery.of(context).size.width < mobileLarge;
  bool _isMobileLarge(BuildContext context) => MediaQuery.of(context).size.width >= mobileLarge && MediaQuery.of(context).size.width < tabletSmall;
  bool _isMobile(BuildContext context) => MediaQuery.of(context).size.width < tabletSmall;
  bool _isTabletSmall(BuildContext context) => MediaQuery.of(context).size.width >= tabletSmall && MediaQuery.of(context).size.width < tabletLarge;
  bool _isTabletLarge(BuildContext context) => MediaQuery.of(context).size.width >= tabletLarge && MediaQuery.of(context).size.width < desktopSmall;
  bool _isTablet(BuildContext context) => MediaQuery.of(context).size.width >= tabletSmall && MediaQuery.of(context).size.width < desktopSmall;
  bool _isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= desktopSmall;

  double _getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= desktopLarge) return 60.0;
    if (screenWidth >= desktopMedium) return 50.0;
    if (screenWidth >= desktopSmall) return 40.0;
    if (screenWidth >= tabletLarge) return 30.0;
    if (screenWidth >= tabletSmall) return 25.0;
    if (screenWidth >= mobileLarge) return 20.0;
    return 16.0;
  }

  double _getResponsiveFontSize(BuildContext context, {
    double mobileSmall = 12.0,
    double mobileLarge = 14.0,
    double tabletSmall = 16.0,
    double tabletLarge = 18.0,
    double desktop = 20.0,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= desktopSmall) return desktop;
    if (screenWidth >= tabletLarge) return tabletLarge;
    if (screenWidth >= tabletSmall) return tabletSmall;
    if (screenWidth >= mobileLarge) return mobileLarge;
    return mobileSmall;
  }

  double _getMaxWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= desktopLarge) return 1400.0;
    if (screenWidth >= desktopMedium) return 1200.0;
    if (screenWidth >= desktopSmall) return 1000.0;
    return screenWidth * 0.95;
  }

  int _getCrossAxisCount(BuildContext context) {
    if (_isMobileSmall(context)) return 2;
    if (_isMobile(context)) return 2;
    if (_isTabletSmall(context)) return 2;
    if (_isTabletLarge(context)) return 4;
    return 4;
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    _animationController.addListener(() {
      setState(() {
        for (int i = 0; i < _targetCounts.length; i++) {
          _animatedCounts[i] = (_targetCounts[i] * _animationController.value).round();
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    if (!_hasAnimated) {
      _hasAnimated = true;
      _animationController.forward();
      _bounceController.repeat(reverse: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // Reduced margin for better spacing
      margin: EdgeInsets.symmetric(
        vertical: _isMobile(context) ? 20.0 : 30.0, // Reduced from 40/60
        horizontal: _getResponsivePadding(context),
      ),
      decoration: BoxDecoration(
        // Match the dark theme of SkillSection
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1a1a2e),
            Color(0xFF16213e),
            Color(0xFF0f3460),
          ],
        ),
        borderRadius: BorderRadius.circular(_isMobile(context) ? 16.0 : 20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[400]!.withOpacity(0.2),
            blurRadius: _isMobile(context) ? 15.0 : 20.0,
            offset: Offset(0, _isMobile(context) ? 8 : 10),
            spreadRadius: _isMobile(context) ? 2 : 3,
          ),
        ],
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: _getMaxWidth(context),
        ),
        padding: EdgeInsets.symmetric(
          vertical: _isMobile(context) ? 30.0 : 40.0, // Reduced from 40/50
          horizontal: _getResponsivePadding(context),
        ),
        child: Column(
          children: [
            _buildSectionHeader(context),
            SizedBox(height: _isMobile(context) ? 25.0 : 30.0), // Reduced from 30/40
            _buildStatsGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: _isMobileSmall(context) ? 12.0 : 16.0,
              vertical: _isMobileSmall(context) ? 6.0 : 8.0,
            ),
            decoration: BoxDecoration(
              color: Colors.blue[400]!.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(
                color: Colors.blue[300]!.withOpacity(0.3),
                width: 1.0,
              ),
            ),
            child: Text(
              "PORTFOLIO STATS",
              style: GoogleFonts.inter(
                color: Colors.blue[300], // Match SkillSection style
                fontWeight: FontWeight.w600,
                fontSize: _getResponsiveFontSize(context,
                  mobileSmall: 10.0,
                  mobileLarge: 11.0,
                  tabletSmall: 12.0,
                  tabletLarge: 13.0,
                  desktop: 14.0,
                ),
                letterSpacing: 1.2,
              ),
            ),
          ),
          SizedBox(height: _isMobileSmall(context) ? 12.0 : 16.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _isMobileSmall(context) ? 8.0 : 0.0),
            child: Text(
              "Proven Track Record",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white, // White text to match dark theme
                fontSize: _getResponsiveFontSize(context,
                  mobileSmall: 20.0,
                  mobileLarge: 22.0,
                  tabletSmall: 26.0,
                  tabletLarge: 30.0,
                  desktop: 36.0,
                ),
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            "Numbers that showcase my dedication and growth",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: Colors.grey[300], // Light grey for subtitle
              fontSize: _getResponsiveFontSize(context,
                mobileSmall: 12.0,
                mobileLarge: 13.0,
                tabletSmall: 14.0,
                tabletLarge: 15.0,
                desktop: 16.0,
              ),
              fontWeight: FontWeight.w400,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimation();
    });

    final crossAxisCount = _getCrossAxisCount(context);
    final isGridLayout = crossAxisCount == 2;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: isGridLayout
            ? _buildGridLayout(context, crossAxisCount)
            : _buildRowLayout(context),
      ),
    );
  }

  Widget _buildGridLayout(BuildContext context, int crossAxisCount) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: _getChildAspectRatio(context),
        crossAxisSpacing: _isMobileSmall(context) ? 10.0 : 12.0, // Reduced spacing
        mainAxisSpacing: _isMobileSmall(context) ? 10.0 : 12.0,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        return _buildStatCard(stats[index], index, context);
      },
    );
  }

  Widget _buildRowLayout(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(stats.length, (index) {
          return Container(
            margin: EdgeInsets.only(
              right: index < stats.length - 1 ? 12.0 : 0.0, // Reduced spacing
            ),
            child: _buildStatCard(stats[index], index, context),
          );
        }),
      ),
    );
  }

  double _getChildAspectRatio(BuildContext context) {
    if (_isMobileSmall(context)) return 1.1;
    if (_isMobile(context)) return 1.2;
    if (_isTabletSmall(context)) return 1.3;
    return 1.4;
  }

  Widget _buildStatCard(Stat stat, int index, BuildContext context) {
    String displayCount = _getDisplayCount(index);

    double cardWidth;
    if (_getCrossAxisCount(context) == 4) {
      cardWidth = _isMobile(context) ? 130.0 : 160.0; // Slightly smaller
    } else {
      cardWidth = double.infinity;
    }

    return AnimatedBuilder(
      animation: _bounceController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceController.value * 2),
          child: Container(
            width: _getCrossAxisCount(context) == 4 ? cardWidth : null,
            padding: EdgeInsets.all(_isMobileSmall(context) ? 14.0 : _isMobile(context) ? 16.0 : 20.0), // Reduced padding
            decoration: BoxDecoration(
              // Glass morphism effect to match dark theme
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(_isMobile(context) ? 12.0 : 16.0),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: _isMobile(context) ? 8.0 : 12.0,
                  offset: Offset(0, _isMobile(context) ? 3 : 4),
                  spreadRadius: _isMobile(context) ? 1 : 2,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIcon(stat.icon, context),
                SizedBox(height: _isMobileSmall(context) ? 8.0 : 12.0), // Reduced spacing
                _buildCount(displayCount, context),
                SizedBox(height: _isMobileSmall(context) ? 4.0 : 6.0),
                _buildDescription(stat.text, context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIcon(IconData icon, BuildContext context) {
    double iconSize = _isMobileSmall(context) ? 40.0 : _isMobile(context) ? 45.0 : 50.0; // Smaller icons
    double iconInnerSize = _isMobileSmall(context) ? 18.0 : _isMobile(context) ? 20.0 : 22.0;

    return Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue[400]!.withOpacity(0.8),
            Colors.blue[400]!,
          ],
        ),
        borderRadius: BorderRadius.circular(_isMobile(context) ? 10.0 : 12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[400]!.withOpacity(0.4),
            blurRadius: _isMobile(context) ? 6.0 : 8.0,
            offset: Offset(0, _isMobile(context) ? 2 : 3),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: iconInnerSize,
      ),
    );
  }

  Widget _buildCount(String displayCount, BuildContext context) {
    return Text(
      displayCount,
      style: GoogleFonts.inter(
        fontWeight: FontWeight.w700,
        fontSize: _getResponsiveFontSize(context,
          mobileSmall: 18.0,
          mobileLarge: 20.0,
          tabletSmall: 22.0,
          tabletLarge: 24.0,
          desktop: 26.0,
        ),
        color: Colors.white, // White text for dark theme
        height: 1.0,
      ),
    );
  }

  Widget _buildDescription(String text, BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.inter(
        fontSize: _getResponsiveFontSize(context,
          mobileSmall: 10.0,
          mobileLarge: 11.0,
          tabletSmall: 12.0,
          tabletLarge: 13.0,
          desktop: 13.0,
        ),
        color: Colors.grey[400], // Light grey for descriptions
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
    );
  }

  String _getDisplayCount(int index) {
    switch (index) {
      case 0:
        return "${_animatedCounts[index]}";
      case 1:
        return "${_animatedCounts[index]}";
      case 2:
        return "${_animatedCounts[index]}+";
      case 3:
        return "${_animatedCounts[index]}+";
      default:
        return "${_animatedCounts[index]}";
    }
  }
}

class Stat {
  final String count;
  final String text;
  final IconData icon;

  Stat({
    required this.count,
    required this.text,
    required this.icon,
  });
}