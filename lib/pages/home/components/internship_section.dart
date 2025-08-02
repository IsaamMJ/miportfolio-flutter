import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:html' as html;

import '../../../data/models/internship_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/screen_helper.dart';

final List<InternshipModel> internshipList = [
  InternshipModel(
    description:
    "Built cross-platform apps with RESTful APIs for data handling and state management via GetX. Optimized widgets and applied lazy loading to boost performance and cut load time by 30%.",
    linkName: "G10X, KOCHI",
    link: "https://g10x.com/",
    period: "MAR 2025 - JUN 2025",
  ),
  InternshipModel(
    description:
    "Utilized cutting-edge Deep Learning techniques to tackle diverse challenges, thereby gaining practical experience in the evolving field of data-driven decision-making.",
    linkName: "CDAC, TRIVANDUM",
    link: "https://www.cdac.in/",
    period: "JUN 2024 - JUL 2024",
  ),
  InternshipModel(
    description:
    "Enrolled in a hands-on course at Inceptez, gaining experience in Hadoop, Spark, Kafka, cloud platforms, real-time streaming, integration, data governance, and DevOps tools for end-to-end data engineering.",
    linkName: "INCEPTEZ, CHENNAI",
    link: "https://www.inceptez.in/",
    period: "MAR 2024 - JAN 2025",
  ),
  InternshipModel(
    description:
    "Designed responsive web interfaces using HTML and CSS, ensuring cross-browser compatibility and contributing to functional enhancements in collaboration with the team.",
    linkName: "ENTERKEY SOLUTIONS, NAGERCOIL",
    link: "https://enterkeysolutions.com/",
    period: "JUN 2023 - JUL 2023",
  ),
];

class InternshipSection extends StatefulWidget {
  @override
  _InternshipSectionState createState() => _InternshipSectionState();
}

class _InternshipSectionState extends State<InternshipSection>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late List<AnimationController> _cardControllers;
  late List<Animation<double>> _cardAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _cardControllers = List.generate(
      internshipList.length,
          (index) => AnimationController(
        duration: Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    _cardAnimations = _cardControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutQuart), // ✅ Changed from easeOutBack
      );
    }).toList();

    _slideAnimations = _cardControllers.map((controller) {
      return Tween<Offset>(
        begin: Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic,
      ));
    }).toList();

    _startAnimations();
  }

  void _startAnimations() async {
    _fadeController.forward();

    for (int i = 0; i < _cardControllers.length; i++) {
      await Future.delayed(Duration(milliseconds: 200));
      if (mounted) {
        _cardControllers[i].forward();
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    for (var controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey[50]!,
            Colors.white,
            Colors.indigo[50]!.withOpacity(0.3),
          ],
        ),
      ),
      child: ScreenHelper(
        desktop: _buildUi(kDesktopMaxWidth, context),
        tablet: _buildUi(kTabletMaxWidth, context),
        mobile: _buildUi(getMobileMaxWidth(context), context),
      ),
    );
  }

  Widget _buildUi(double width, BuildContext context) {
    final bool isMobile = width < 600;

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        vertical: 80.0,
        horizontal: isMobile ? 20.0 : 40.0,
      ),
      child: MaxWidthBox(
        maxWidth: width,
        child: FadeTransition(
          opacity: _fadeController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSectionHeader(),
              SizedBox(height: 60.0),
              _buildInternshipGrid(isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.indigo[100]!.withOpacity(0.8),
                Colors.purple[100]!.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(30.0),
            border: Border.all(
              color: Colors.indigo[200]!.withOpacity(0.5),
              width: 1.0,
            ),
          ),
          child: Text(
            "PROFESSIONAL EXPERIENCE",
            style: GoogleFonts.inter(
              color: Colors.indigo[700],
              fontWeight: FontWeight.w600,
              fontSize: 14.0,
              letterSpacing: 1.2,
            ),
          ),
        ),
        SizedBox(height: 16.0),
        Text(
          "Internships & Training",
          style: GoogleFonts.inter(
            color: Colors.grey[800],
            fontWeight: FontWeight.w800,
            fontSize: 36.0,
            height: 1.2,
          ),
        ),
        SizedBox(height: 16.0),
        Container(
          constraints: BoxConstraints(maxWidth: 600.0),
          child: Text(
            "Each internship was a stepping stone — turning theory into practice, and curiosity into capability through hands-on experience with industry leaders.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: Colors.grey[600],
              fontSize: 16.0,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInternshipGrid(bool isMobile) {
    return Column(
      children: internshipList.asMap().entries.map((entry) {
        final index = entry.key;
        final internship = entry.value;

        return AnimatedBuilder(
          animation: _cardAnimations[index],
          builder: (context, child) {
            return SlideTransition(
              position: _slideAnimations[index],
              child: Transform.scale(
                scale: _cardAnimations[index].value,
                child: Opacity(
                  opacity: _cardAnimations[index].value.clamp(0.0, 1.0), // ✅ Added clamp to fix opacity issue
                  child: _buildInternshipCard(internship, index, isMobile),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildInternshipCard(InternshipModel internship, int index, bool isMobile) {
    return Container(
      margin: EdgeInsets.only(bottom: 30.0),
      child: MouseRegion(
        onEnter: (_) => _onCardHover(index, true),
        onExit: (_) => _onCardHover(index, false),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.all(isMobile ? 20.0 : 32.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: _getColorForIndex(index).withOpacity(0.1),
                blurRadius: 30.0,
                offset: Offset(0, 15),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.grey[200]!.withOpacity(0.5),
                blurRadius: 20.0,
                offset: Offset(0, 5),
                spreadRadius: 0,
              ),
            ],
            border: Border.all(
              color: Colors.grey[200]!,
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with period and company
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline dot
                  Container(
                    margin: EdgeInsets.only(top: 4.0, right: 16.0),
                    width: 12.0,
                    height: 12.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getColorForIndex(index),
                      boxShadow: [
                        BoxShadow(
                          color: _getColorForIndex(index).withOpacity(0.3),
                          blurRadius: 8.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Period badge
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                          decoration: BoxDecoration(
                            color: _getColorForIndex(index).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: _getColorForIndex(index).withOpacity(0.3),
                              width: 1.0,
                            ),
                          ),
                          child: Text(
                            internship.period,
                            style: GoogleFonts.inter(
                              color: _getColorForIndex(index),
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.0),

                        // Company name
                        Text(
                          internship.linkName,
                          style: GoogleFonts.inter(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w700,
                            fontSize: isMobile ? 18.0 : 20.0,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.0),

              // Description
              Container(
                padding: EdgeInsets.only(left: 28.0),
                child: Text(
                  internship.description,
                  style: GoogleFonts.inter(
                    color: Colors.grey[600],
                    fontSize: 15.0,
                    height: 1.6,
                  ),
                ),
              ),

              SizedBox(height: 20.0),

              // Action button
              Container(
                padding: EdgeInsets.only(left: 28.0),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      final url = internship.link.startsWith('http')
                          ? internship.link
                          : 'https://${internship.link}';
                      html.window.open(url, '_blank');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _getColorForIndex(index),
                            _getColorForIndex(index).withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                        boxShadow: [
                          BoxShadow(
                            color: _getColorForIndex(index).withOpacity(0.3),
                            blurRadius: 10.0,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.business,
                            size: 16.0,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            "Visit Company",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(width: 4.0),
                          Icon(
                            Icons.arrow_forward,
                            size: 14.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onCardHover(int index, bool isHovering) {
    // Add subtle hover animation if needed
    if (mounted) {
      setState(() {
        // Could add hover state management here
      });
    }
  }

  Color _getColorForIndex(int index) {
    final colors = [
      Colors.indigo[600]!,
      Colors.purple[600]!,
      Colors.teal[600]!,
      Colors.orange[600]!,
    ];
    return colors[index % colors.length];
  }
}