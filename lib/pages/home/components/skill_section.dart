import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/skill.dart';
import '../../../utils/constants.dart';

List<Skill> skills = [
  Skill(skill: "Flutter", percentage: 90),
  Skill(skill: "Dart", percentage: 70),
  Skill(skill: "GetX", percentage: 80),
  Skill(skill: "Bloc", percentage: 50),
  Skill(skill: "MySQL", percentage: 60),
  Skill(skill: "Swagger/Postman", percentage: 90),
  Skill(skill: "Firebase/Supabase", percentage: 80),
  Skill(skill: "Clean Arch/MVVM/MVC", percentage: 100),
  Skill(skill: "Git/Github", percentage: 85),
];

// Skill categories for better organization
final Map<String, List<Skill>> skillCategories = {
  'Frontend Development': [
    Skill(skill: "Flutter", percentage: 90),
    Skill(skill: "Dart", percentage: 70),
  ],
  'State Management': [
    Skill(skill: "GetX", percentage: 80),
    Skill(skill: "Bloc", percentage: 50),
  ],
  'Backend & Database': [
    Skill(skill: "MySQL", percentage: 60),
    Skill(skill: "Firebase/Supabase", percentage: 80),
  ],
  'Tools & Architecture': [
    Skill(skill: "Swagger/Postman", percentage: 90),
    Skill(skill: "Clean Arch/MVVM/MVC", percentage: 100),
    Skill(skill: "Git/Github", percentage: 85),
  ],
};

class SkillSection extends StatefulWidget {
  @override
  _SkillSectionState createState() => _SkillSectionState();
}

class _SkillSectionState extends State<SkillSection>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _progressAnimations;
  bool _isVisible = false;

  // 📱 ENHANCED RESPONSIVE BREAKPOINTS
  static const double mobileSmall = 320.0;
  static const double mobileLarge = 480.0;
  static const double tabletSmall = 600.0;
  static const double tabletLarge = 768.0;
  static const double desktopSmall = 1024.0;
  static const double desktopMedium = 1200.0;
  static const double desktopLarge = 1440.0;
  static const double desktopXL = 1920.0;

  // 📏 ENHANCED RESPONSIVE UTILITIES
  double _getResponsiveSpacing(BuildContext context, {
    double mobileSmall = 16.0,
    double mobileLarge = 20.0,
    double tabletSmall = 32.0,
    double tabletLarge = 40.0,
    double desktop = 60.0,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= desktopSmall) return desktop;
    if (screenWidth >= tabletLarge) return tabletLarge;
    if (screenWidth >= tabletSmall) return tabletSmall;
    if (screenWidth >= mobileLarge) return mobileLarge;
    return mobileSmall;
  }

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

  // 📱 ENHANCED DEVICE TYPE DETECTION
  bool _isMobileSmall(BuildContext context) => MediaQuery.of(context).size.width < mobileLarge;
  bool _isMobileLarge(BuildContext context) => MediaQuery.of(context).size.width >= mobileLarge && MediaQuery.of(context).size.width < tabletSmall;
  bool _isMobile(BuildContext context) => MediaQuery.of(context).size.width < tabletSmall;
  bool _isTabletSmall(BuildContext context) => MediaQuery.of(context).size.width >= tabletSmall && MediaQuery.of(context).size.width < tabletLarge;
  bool _isTabletLarge(BuildContext context) => MediaQuery.of(context).size.width >= tabletLarge && MediaQuery.of(context).size.width < desktopSmall;
  bool _isTablet(BuildContext context) => MediaQuery.of(context).size.width >= tabletSmall && MediaQuery.of(context).size.width < desktopSmall;
  bool _isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= desktopSmall;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _progressAnimations = skills.map((skill) {
      return Tween<double>(
        begin: 0.0,
        end: skill.percentage / 100.0,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ));
    }).toList();

    // Start animation after a short delay
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isVisible = true);
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // Add margin to create the rounded container effect
      margin: EdgeInsets.symmetric(
        vertical: _isMobile(context) ? 20.0 : 30.0,
        horizontal: _getResponsivePadding(context),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1a1a2e),
            Color(0xFF16213e),
            Color(0xFF0f3460),
          ],
        ),
        // Add rounded corners
        borderRadius: BorderRadius.circular(_isMobile(context) ? 16.0 : 20.0),
        // Add shadow to match PortfolioStats
        boxShadow: [
          BoxShadow(
            color: Colors.blue[400]!.withOpacity(0.2),
            blurRadius: _isMobile(context) ? 15.0 : 20.0,
            offset: Offset(0, _isMobile(context) ? 8 : 10),
            spreadRadius: _isMobile(context) ? 2 : 3,
          ),
        ],
      ),
      child: _buildResponsiveLayout(context),
    );
  }

  Widget _buildResponsiveLayout(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: _getMaxWidth(context),
      ),
      padding: EdgeInsets.symmetric(
        vertical: _getResponsiveSpacing(context,
            mobileSmall: 30.0,
            mobileLarge: 35.0,
            tabletSmall: 40.0,
            tabletLarge: 45.0,
            desktop: 50.0
        ),
        horizontal: _getResponsivePadding(context),
      ),
      child: Column(
        children: [
          _buildSectionHeader(context),
          SizedBox(height: _getResponsiveSpacing(context,
              mobileSmall: 25.0,
              mobileLarge: 30.0,
              tabletSmall: 35.0,
              tabletLarge: 40.0,
              desktop: 45.0
          )),
          _buildMainContent(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: _isMobileSmall(context) ? 16.0 : 24.0,
              vertical: _isMobileSmall(context) ? 6.0 : 8.0
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
            "TECHNICAL SKILLS",
            style: GoogleFonts.inter(
              color: Colors.blue[300],
              fontWeight: FontWeight.w600,
              fontSize: _getResponsiveFontSize(context,
                  mobileSmall: 10.0,
                  mobileLarge: 11.0,
                  tabletSmall: 12.0,
                  tabletLarge: 13.0,
                  desktop: 14.0
              ),
              letterSpacing: 1.2,
            ),
          ),
        ),
        SizedBox(height: _isMobileSmall(context) ? 12.0 : 16.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: _isMobileSmall(context) ? 8.0 : 16.0),
          child: Text(
            "The Stack Behind the Products I Ship",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: _getResponsiveFontSize(context,
                  mobileSmall: 20.0,
                  mobileLarge: 22.0,
                  tabletSmall: 26.0,
                  tabletLarge: 30.0,
                  desktop: 36.0
              ),
              height: 1.2,
            ),
          ),
        ),
        SizedBox(height: _isMobileSmall(context) ? 12.0 : 16.0),
        Container(
          constraints: BoxConstraints(
              maxWidth: _isMobileSmall(context) ? double.infinity : 600.0
          ),
          padding: EdgeInsets.symmetric(horizontal: _isMobileSmall(context) ? 8.0 : 0.0),
          child: Text(
            "From mobile development to backend architecture, here are the technologies and tools I use to create exceptional digital experiences.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: Colors.grey[300],
              fontSize: _getResponsiveFontSize(context,
                  mobileSmall: 12.0,
                  mobileLarge: 13.0,
                  tabletSmall: 14.0,
                  tabletLarge: 15.0,
                  desktop: 16.0
              ),
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context) {
    if (_isMobile(context)) {
      return _buildMobileLayout(context);
    } else if (_isTablet(context)) {
      return _buildTabletLayout(context);
    } else {
      return _buildDesktopLayout(context);
    }
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildStatsRow(context),
        SizedBox(height: _getResponsiveSpacing(context,
            mobileSmall: 25.0,
            mobileLarge: 30.0
        )),
        _buildSkillsSection(context),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Column(
      children: [
        _buildProfileSection(context),
        SizedBox(height: _getResponsiveSpacing(context,
            tabletSmall: 30.0,
            tabletLarge: 35.0
        )),
        _buildStatsGrid(context, crossAxisCount: _isTabletSmall(context) ? 2 : 3),
        SizedBox(height: _getResponsiveSpacing(context,
            tabletSmall: 35.0,
            tabletLarge: 40.0
        )),
        _buildSkillsSection(context),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int leftFlex = constraints.maxWidth > desktopMedium ? 2 : 1;
        int rightFlex = constraints.maxWidth > desktopMedium ? 3 : 2;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side - Image and stats
            Expanded(
              flex: leftFlex,
              child: Column(
                children: [
                  _buildProfileSection(context),
                  SizedBox(height: _getResponsiveSpacing(context, desktop: 35.0)),
                  _buildStatsGrid(context, crossAxisCount: 1),
                ],
              ),
            ),
            SizedBox(width: constraints.maxWidth > desktopMedium ? 50.0 : 35.0),
            // Right side - Skills
            Expanded(
              flex: rightFlex,
              child: _buildSkillsSection(context),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    double imageSize;
    if (_isMobileSmall(context)) {
      imageSize = 140.0; // Slightly smaller
    } else if (_isMobileLarge(context)) {
      imageSize = 160.0;
    } else if (_isTabletSmall(context)) {
      imageSize = 180.0;
    } else if (_isTabletLarge(context)) {
      imageSize = 200.0;
    } else {
      imageSize = MediaQuery.of(context).size.width > desktopMedium ? 250.0 : 220.0;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_isMobile(context) ? 16.0 : 20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[400]!.withOpacity(0.3),
            blurRadius: _isMobile(context) ? 15.0 : 25.0,
            spreadRadius: _isMobile(context) ? 2.0 : 4.0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_isMobile(context) ? 16.0 : 20.0),
        child: Image.asset(
          "assets/person_small.png",
          width: imageSize,
          height: imageSize,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: _isMobileSmall(context) ? 4.0 : 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStatCard(context, "Years Experience", "3+", Icons.timeline),
          SizedBox(width: _isMobileSmall(context) ? 10.0 : 12.0),
          _buildStatCard(context, "Projects", "25+", Icons.code),
          SizedBox(width: _isMobileSmall(context) ? 10.0 : 12.0),
          _buildStatCard(context, "Technologies", "${skills.length}+", Icons.settings),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, {required int crossAxisCount}) {
    final stats = [
      {"title": "Years Experience", "value": "3+", "icon": Icons.timeline},
      {"title": "Projects Completed", "value": "25+", "icon": Icons.code},
      {"title": "Technologies", "value": "${skills.length}+", "icon": Icons.settings},
    ];

    if (crossAxisCount == 1) {
      return Column(
        children: stats.map((stat) =>
            Container(
              margin: EdgeInsets.only(bottom: 12.0),
              child: _buildStatCard(
                  context,
                  stat["title"] as String,
                  stat["value"] as String,
                  stat["icon"] as IconData
              ),
            )
        ).toList(),
      );
    } else {
      return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: _isTabletSmall(context) ? 2.0 : 2.5,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: stats.length,
        itemBuilder: (context, index) {
          final stat = stats[index];
          return _buildStatCard(
            context,
            stat["title"] as String,
            stat["value"] as String,
            stat["icon"] as IconData,
          );
        },
      );
    }
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon) {
    double cardPadding;
    if (_isMobileSmall(context)) {
      cardPadding = 10.0;
    } else if (_isMobile(context)) {
      cardPadding = 12.0;
    } else if (_isTablet(context)) {
      cardPadding = 14.0;
    } else {
      cardPadding = 16.0;
    }

    return Container(
      constraints: BoxConstraints(
        minWidth: _isMobileSmall(context) ? 90.0 : 110.0,
        maxWidth: _isMobile(context) ? 130.0 : double.infinity,
      ),
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(_isMobile(context) ? 10.0 : 12.0),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1.0,
        ),
      ),
      child: _isMobile(context)
          ? _buildMobileStatContent(context, title, value, icon)
          : _buildDesktopStatContent(context, title, value, icon),
    );
  }

  Widget _buildMobileStatContent(BuildContext context, String title, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(_isMobileSmall(context) ? 5.0 : 6.0),
          decoration: BoxDecoration(
            color: Colors.blue[400]!.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Icon(
            icon,
            color: Colors.blue[300],
            size: _isMobileSmall(context) ? 14.0 : 16.0,
          ),
        ),
        SizedBox(height: _isMobileSmall(context) ? 5.0 : 6.0),
        Text(
          value,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: _getResponsiveFontSize(context,
                mobileSmall: 12.0,
                mobileLarge: 14.0,
                tabletSmall: 16.0
            ),
          ),
        ),
        SizedBox(height: 2.0),
        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            color: Colors.grey[400],
            fontSize: _getResponsiveFontSize(context,
                mobileSmall: 8.0,
                mobileLarge: 9.0,
                tabletSmall: 10.0
            ),
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopStatContent(BuildContext context, String title, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            color: Colors.blue[400]!.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Icon(
            icon,
            color: Colors.blue[300],
            size: 16.0,
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: _getResponsiveFontSize(context,
                      tabletSmall: 14.0,
                      tabletLarge: 15.0,
                      desktop: 16.0
                  ),
                ),
              ),
              Text(
                title,
                style: GoogleFonts.inter(
                  color: Colors.grey[400],
                  fontSize: _getResponsiveFontSize(context,
                      tabletSmall: 9.0,
                      tabletLarge: 10.0,
                      desktop: 11.0
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsSection(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: skills.asMap().entries.map((entry) {
            final index = entry.key;
            final skill = entry.value;
            final animation = _progressAnimations[index];

            return _buildAnimatedSkillBar(context, skill, animation, index);
          }).toList(),
        );
      },
    );
  }

  Widget _buildAnimatedSkillBar(BuildContext context, Skill skill, Animation<double> animation, int index) {
    double bottomMargin;
    if (_isMobileSmall(context)) {
      bottomMargin = 14.0;
    } else if (_isMobile(context)) {
      bottomMargin = 16.0;
    } else if (_isTablet(context)) {
      bottomMargin = 18.0;
    } else {
      bottomMargin = 20.0;
    }

    return Container(
      margin: EdgeInsets.only(bottom: bottomMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skill name and percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  skill.skill,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: _getResponsiveFontSize(context,
                        mobileSmall: 12.0,
                        mobileLarge: 13.0,
                        tabletSmall: 14.0,
                        tabletLarge: 15.0,
                        desktop: 16.0
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              Text(
                "${(animation.value * 100).round()}%",
                style: GoogleFonts.inter(
                  color: Colors.blue[300],
                  fontWeight: FontWeight.w700,
                  fontSize: _getResponsiveFontSize(context,
                      mobileSmall: 12.0,
                      mobileLarge: 13.0,
                      tabletSmall: 14.0,
                      tabletLarge: 15.0,
                      desktop: 16.0
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: _isMobileSmall(context) ? 6.0 : 8.0),

          // Progress bar
          Container(
            height: _isMobileSmall(context) ? 5.0 : _isMobile(context) ? 6.0 : 8.0,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(_isMobileSmall(context) ? 2.5 : _isMobile(context) ? 3.0 : 4.0),
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  widthFactor: animation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getSkillColor(index),
                          _getSkillColor(index).withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(_isMobileSmall(context) ? 2.5 : _isMobile(context) ? 3.0 : 4.0),
                      boxShadow: [
                        BoxShadow(
                          color: _getSkillColor(index).withOpacity(0.4),
                          blurRadius: _isMobile(context) ? 6.0 : 8.0,
                          spreadRadius: _isMobile(context) ? 0.5 : 1.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getSkillColor(int index) {
    final colors = [
      Colors.blue[400]!,
      Colors.green[400]!,
      Colors.orange[400]!,
      Colors.purple[400]!,
      Colors.red[400]!,
      Colors.teal[400]!,
      Colors.indigo[400]!,
      Colors.pink[400]!,
      Colors.amber[400]!,
    ];
    return colors[index % colors.length];
  }
}