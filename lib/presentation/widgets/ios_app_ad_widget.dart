import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/models/app_data.dart';
import '../../../utils/constants.dart';

class IosAppAdWidget extends StatelessWidget {
  final AppData appData;
  final VoidCallback onNext;
  final VoidCallback onRestart;

  const IosAppAdWidget({
    Key? key,
    required this.appData,
    required this.onNext,
    required this.onRestart,
  }) : super(key: key);

  // 📱 CONSISTENT RESPONSIVE BREAKPOINTS
  static const double mobileBreakpoint = 768.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1200.0;

  // 📏 RESPONSIVE UTILITIES
  bool _isMobile(BuildContext context) => MediaQuery.of(context).size.width < mobileBreakpoint;
  bool _isTablet(BuildContext context) => MediaQuery.of(context).size.width >= mobileBreakpoint && MediaQuery.of(context).size.width < tabletBreakpoint;
  bool _isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= tabletBreakpoint;

  double _getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= desktopBreakpoint) return 60.0;
    if (screenWidth >= tabletBreakpoint) return 40.0;
    if (screenWidth >= mobileBreakpoint) return 30.0;
    return 20.0;
  }

  double _getResponsiveFontSize(BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (_isDesktop(context)) return desktop;
    if (_isTablet(context)) return tablet;
    return mobile;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: _getResponsivePadding(context),
        vertical: _isMobile(context) ? 20 : 40,
      ),
      child: _buildAppAd(
        context,
        BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }

  Widget _buildAppAd(BuildContext context, BoxConstraints constraints) {
    // Create different layouts based on app type for variety
    switch (appData.name.toLowerCase()) {
      case 'skyfeed':
        return _buildSkyFeedLayout(context, constraints);
      case 'weatherpro':
        return _buildWeatherProLayout(context, constraints);
      case 'newshub':
        return _buildNewsHubLayout(context, constraints);
      default:
        return _buildDefaultLayout(context, constraints);
    }
  }

  Widget _buildSkyFeedLayout(BuildContext context, BoxConstraints constraints) {
    bool isWideLayout = constraints.maxWidth > 800 && !_isMobile(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return IntrinsicHeight(
          child: Flex(
            direction: isWideLayout ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image section
              Flexible(
                flex: isWideLayout ? 1 : 0,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isWideLayout ? double.infinity :
                    _isMobile(context) ? 280 : 400,
                    maxHeight: _isMobile(context) ? 250 : 350,
                  ),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Stack(
                      children: [
                        // Glow effect
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(_isMobile(context) ? 15 : 20),
                            boxShadow: [
                              BoxShadow(
                                color: _getAppColor().withOpacity(0.3),
                                blurRadius: _isMobile(context) ? 20 : 30,
                                spreadRadius: _isMobile(context) ? 3 : 5,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(_isMobile(context) ? 15 : 20),
                            child: appData.imagePath != null
                                ? Image.asset(appData.imagePath!, fit: BoxFit.cover)
                                : Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [_getAppColor(), _getAppColor().withOpacity(0.7)],
                                ),
                              ),
                              child: Icon(
                                _getAppIcon(),
                                size: _isMobile(context) ? 80 : 120,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        // Floating elements - responsive visibility
                        if (constraints.maxWidth > 350)
                          Positioned(
                            top: -5,
                            right: -5,
                            child: Container(
                              width: _isMobile(context) ? 40 : 60,
                              height: _isMobile(context) ? 40 : 60,
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(_isMobile(context) ? 20 : 30),
                              ),
                              child: Icon(
                                Icons.wb_sunny,
                                color: Colors.white,
                                size: _isMobile(context) ? 16 : 24,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: isWideLayout ? (_isMobile(context) ? 20 : 30) : 0,
                height: isWideLayout ? 0 : (_isMobile(context) ? 15 : 20),
              ),

              // Content section with its own scrolling
              Expanded(
                flex: isWideLayout ? 1 : 0,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isWideLayout ? double.infinity : 600,
                    maxHeight: constraints.maxHeight * (isWideLayout ? 1.0 : 0.6),
                  ),
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: isWideLayout ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // App badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: _isMobile(context) ? 8 : 12,
                            vertical: _isMobile(context) ? 4 : 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getAppColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(_isMobile(context) ? 15 : 20),
                            border: Border.all(color: _getAppColor().withOpacity(0.3)),
                          ),
                          child: Text(
                            "FEATURED APP",
                            style: GoogleFonts.poppins(
                              color: _getAppColor(),
                              fontWeight: FontWeight.w600,
                              fontSize: _getResponsiveFontSize(context,
                                  mobile: 10, tablet: 11, desktop: 12),
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        SizedBox(height: _isMobile(context) ? 10 : 15),

                        // App name with animation
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [_getAppColor(), _getAppColor().withOpacity(0.7)],
                          ).createShader(bounds),
                          child: Text(
                            appData.name,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: _getResponsiveFontSize(context,
                                  mobile: 24, tablet: 30, desktop: 36),
                              height: 1.1,
                            ),
                            textAlign: isWideLayout ? TextAlign.left : TextAlign.center,
                          ),
                        ),

                        SizedBox(height: _isMobile(context) ? 8 : 12),
                        Text(
                          appData.subtitle.toUpperCase(),
                          style: GoogleFonts.poppins(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                            fontSize: _getResponsiveFontSize(context,
                                mobile: 14, tablet: 16, desktop: 18),
                            letterSpacing: 0.5,
                          ),
                          textAlign: isWideLayout ? TextAlign.left : TextAlign.center,
                        ),

                        SizedBox(height: _isMobile(context) ? 12 : 15),
                        Container(
                          padding: EdgeInsets.all(_isMobile(context) ? 12 : 16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(_isMobile(context) ? 12 : 15),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Text(
                            appData.description,
                            style: GoogleFonts.inter(
                              color: Colors.grey[700],
                              height: 1.5,
                              fontSize: _getResponsiveFontSize(context,
                                  mobile: 12, tablet: 13, desktop: 14),
                            ),
                            textAlign: isWideLayout ? TextAlign.left : TextAlign.center,
                            maxLines: _isMobile(context) ? 3 : 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        SizedBox(height: _isMobile(context) ? 15 : 20),

                        // Rating and stats
                        Wrap(
                          spacing: _isMobile(context) ? 8 : 15,
                          runSpacing: _isMobile(context) ? 8 : 10,
                          alignment: isWideLayout ? WrapAlignment.start : WrapAlignment.center,
                          children: [
                            _buildStatCard("${appData.rating}★", "Rating", context),
                            _buildStatCard("${appData.downloads}+", "Downloads", context),
                            _buildStatCard(appData.price == 0 ? "Free" : "\$${appData.price}", "Price", context),
                          ],
                        ),

                        SizedBox(height: _isMobile(context) ? 15 : 20),

                        // Action buttons
                        Wrap(
                          spacing: _isMobile(context) ? 10 : 15,
                          runSpacing: 10,
                          alignment: isWideLayout ? WrapAlignment.start : WrapAlignment.center,
                          children: [
                            _buildButton(
                              context,
                              "EXPLORE APP",
                                  () => _handleExploreApp(context),
                              primary: true,
                              icon: Icons.launch,
                            ),
                            _buildButton(
                              context,
                              "NEXT",
                              onNext,
                              primary: false,
                              icon: Icons.arrow_forward,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeatherProLayout(BuildContext context, BoxConstraints constraints) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App icon with glow
          Container(
            width: _isMobile(context) ? 80 : _isTablet(context) ? 100 : 120,
            height: _isMobile(context) ? 80 : _isTablet(context) ? 100 : 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_getAppColor(), _getAppColor().withOpacity(0.7)],
              ),
              borderRadius: BorderRadius.circular(_isMobile(context) ? 20 : 30),
              boxShadow: [
                BoxShadow(
                  color: _getAppColor().withOpacity(0.4),
                  blurRadius: _isMobile(context) ? 15 : 20,
                  spreadRadius: _isMobile(context) ? 3 : 5,
                ),
              ],
            ),
            child: appData.imagePath != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(_isMobile(context) ? 20 : 30),
              child: Image.asset(appData.imagePath!, fit: BoxFit.cover),
            )
                : Icon(
              _getAppIcon(),
              color: Colors.white,
              size: _isMobile(context) ? 40 : _isTablet(context) ? 50 : 60,
            ),
          ),

          SizedBox(height: _isMobile(context) ? 20 : 30),

          Text(
            appData.name,
            style: GoogleFonts.poppins(
              fontSize: _getResponsiveFontSize(context,
                  mobile: 28, tablet: 35, desktop: 42),
              fontWeight: FontWeight.w800,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: _isMobile(context) ? 8 : 10),
          Container(
            constraints: BoxConstraints(
              maxWidth: _isMobile(context) ? double.infinity : 400,
            ),
            child: Text(
              appData.subtitle,
              style: GoogleFonts.inter(
                fontSize: _getResponsiveFontSize(context,
                    mobile: 14, tablet: 16, desktop: 18),
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: _isMobile(context) ? 30 : 40),

          // Features from app data
          if (appData.features.isNotEmpty)
            Container(
              constraints: BoxConstraints(maxWidth: 600),
              child: Wrap(
                spacing: _isMobile(context) ? 10 : 20,
                runSpacing: _isMobile(context) ? 10 : 15,
                alignment: WrapAlignment.center,
                children: appData.features.map((feature) =>
                    _buildFeatureChip(feature, _getFeatureIcon(feature), context)
                ).toList(),
              ),
            ),

          SizedBox(height: _isMobile(context) ? 30 : 40),

          ElevatedButton.icon(
            onPressed: onNext,
            icon: Icon(Icons.arrow_forward, size: _isMobile(context) ? 16 : 18),
            label: Text(
              "DISCOVER MORE",
              style: TextStyle(
                fontSize: _getResponsiveFontSize(context,
                    mobile: 12, tablet: 14, desktop: 16),
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _getAppColor(),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: _isMobile(context) ? 20 : 30,
                vertical: _isMobile(context) ? 12 : 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_isMobile(context) ? 20 : 25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsHubLayout(BuildContext context, BoxConstraints constraints) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated news icon
          Container(
            width: _isMobile(context) ? 80 : _isTablet(context) ? 100 : 120,
            height: _isMobile(context) ? 80 : _isTablet(context) ? 100 : 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_getAppColor(), _getAppColor().withOpacity(0.7)],
              ),
              borderRadius: BorderRadius.circular(_isMobile(context) ? 20 : 30),
              boxShadow: [
                BoxShadow(
                  color: _getAppColor().withOpacity(0.4),
                  blurRadius: _isMobile(context) ? 15 : 20,
                  spreadRadius: _isMobile(context) ? 3 : 5,
                ),
              ],
            ),
            child: appData.imagePath != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(_isMobile(context) ? 20 : 30),
              child: Image.asset(appData.imagePath!, fit: BoxFit.cover),
            )
                : Icon(
              _getAppIcon(),
              color: Colors.white,
              size: _isMobile(context) ? 40 : _isTablet(context) ? 50 : 60,
            ),
          ),

          SizedBox(height: _isMobile(context) ? 20 : 30),

          Text(
            appData.name,
            style: GoogleFonts.poppins(
              fontSize: _getResponsiveFontSize(context,
                  mobile: 28, tablet: 35, desktop: 42),
              fontWeight: FontWeight.w800,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: _isMobile(context) ? 8 : 10),
          Container(
            constraints: BoxConstraints(
              maxWidth: _isMobile(context) ? double.infinity : 400,
            ),
            child: Text(
              appData.subtitle,
              style: GoogleFonts.inter(
                fontSize: _getResponsiveFontSize(context,
                    mobile: 14, tablet: 16, desktop: 18),
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: _isMobile(context) ? 30 : 40),

          // Categories from app data
          if (appData.categories.isNotEmpty)
            Container(
              constraints: BoxConstraints(maxWidth: 600),
              child: Wrap(
                spacing: _isMobile(context) ? 8 : 15,
                runSpacing: _isMobile(context) ? 8 : 10,
                alignment: WrapAlignment.center,
                children: appData.categories.map((category) =>
                    _buildCategoryTag(category, context)
                ).toList(),
              ),
            ),

          SizedBox(height: _isMobile(context) ? 30 : 40),

          Wrap(
            spacing: _isMobile(context) ? 10 : 15,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => _handleExploreApp(context),
                icon: Icon(Icons.launch, size: _isMobile(context) ? 16 : 18),
                label: Text(
                  "EXPLORE",
                  style: TextStyle(
                    fontSize: _getResponsiveFontSize(context,
                        mobile: 12, tablet: 14, desktop: 16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getAppColor(),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: _isMobile(context) ? 20 : 25,
                    vertical: _isMobile(context) ? 10 : 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_isMobile(context) ? 20 : 25),
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: onRestart,
                icon: Icon(Icons.refresh, size: _isMobile(context) ? 16 : 18),
                label: Text(
                  "RESTART",
                  style: TextStyle(
                    fontSize: _getResponsiveFontSize(context,
                        mobile: 12, tablet: 14, desktop: 16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _getAppColor(),
                  padding: EdgeInsets.symmetric(
                    horizontal: _isMobile(context) ? 20 : 25,
                    vertical: _isMobile(context) ? 10 : 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_isMobile(context) ? 20 : 25),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultLayout(BuildContext context, BoxConstraints constraints) {
    return _buildSkyFeedLayout(context, constraints);
  }

  // URL launcher function
  Future<void> _handleExploreApp(BuildContext context) async {
    final url = appData.appStoreUrl;
    if (url != null && url.isNotEmpty) {
      try {
        final Uri uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          _showErrorSnackBar(context, 'Could not open app store');
        }
      } catch (e) {
        _showErrorSnackBar(context, 'Error launching URL: $e');
      }
    } else {
      _showErrorSnackBar(context, 'App store link not available');
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
    if (scaffoldMessenger != null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red[400],
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildStatCard(String value, String label, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _isMobile(context) ? 8 : 12,
        vertical: _isMobile(context) ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_isMobile(context) ? 8 : 10),
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
              fontSize: _getResponsiveFontSize(context,
                  mobile: 12, tablet: 13, desktop: 14),
              color: _getAppColor(),
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: _getResponsiveFontSize(context,
                  mobile: 9, tablet: 10, desktop: 11),
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String label, VoidCallback onPressed,
      {required bool primary, IconData? icon}) {
    return Container(
      height: _isMobile(context) ? 40 : 50,
      constraints: BoxConstraints(
        minWidth: _isMobile(context) ? 100 : 120,
      ),
      decoration: BoxDecoration(
        gradient: primary
            ? LinearGradient(
          colors: [_getAppColor(), _getAppColor().withOpacity(0.7)],
        )
            : null,
        color: primary ? null : Colors.white,
        borderRadius: BorderRadius.circular(_isMobile(context) ? 20 : 25),
        border: primary ? null : Border.all(color: _getAppColor()),
        boxShadow: [
          BoxShadow(
            color: primary
                ? _getAppColor().withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: primary ? 15 : 5,
            offset: Offset(0, primary ? 5 : 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(_isMobile(context) ? 20 : 25),
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _isMobile(context) ? 16 : 24,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: primary ? Colors.white : _getAppColor(),
                    size: _isMobile(context) ? 14 : 18,
                  ),
                  SizedBox(width: _isMobile(context) ? 4 : 8),
                ],
                Flexible(
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: primary ? Colors.white : _getAppColor(),
                      fontSize: _getResponsiveFontSize(context,
                          mobile: 12, tablet: 13, desktop: 14),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String label, IconData icon, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _isMobile(context) ? 12 : 16,
        vertical: _isMobile(context) ? 6 : 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_isMobile(context) ? 15 : 20),
        border: Border.all(color: _getAppColor().withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: _isMobile(context) ? 14 : 16,
            color: _getAppColor(),
          ),
          SizedBox(width: _isMobile(context) ? 4 : 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: _getResponsiveFontSize(context,
                  mobile: 11, tablet: 12, desktop: 12),
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTag(String category, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _isMobile(context) ? 10 : 12,
        vertical: _isMobile(context) ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: _getAppColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(_isMobile(context) ? 12 : 15),
        border: Border.all(color: _getAppColor().withOpacity(0.3)),
      ),
      child: Text(
        category,
        style: GoogleFonts.inter(
          fontSize: _getResponsiveFontSize(context,
              mobile: 10, tablet: 11, desktop: 12),
          color: _getAppColor(),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Helper methods for app-specific styling
  Color _getAppColor() {
    switch (appData.name.toLowerCase()) {
      case 'skyfeed':
        return kPrimaryColor;
      case 'weatherpro':
        return Colors.blue[400]!;
      case 'newshub':
        return Colors.red[400]!;
      default:
        return kPrimaryColor;
    }
  }

  IconData _getAppIcon() {
    switch (appData.name.toLowerCase()) {
      case 'skyfeed':
        return Icons.rss_feed;
      case 'weatherpro':
        return Icons.cloud;
      case 'newshub':
        return Icons.newspaper;
      default:
        return Icons.apps;
    }
  }

  IconData _getFeatureIcon(String feature) {
    switch (feature.toLowerCase()) {
      case 'real-time updates':
        return Icons.update;
      case 'ai predictions':
        return Icons.psychology;
      case 'multi-location':
        return Icons.location_on;
      case 'weather alerts':
        return Icons.notifications;
      case 'personalized':
        return Icons.person;
      case 'offline reading':
        return Icons.offline_pin;
      default:
        return Icons.star;
    }
  }
}