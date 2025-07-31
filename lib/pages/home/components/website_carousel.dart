import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/constants.dart';
import '../../../utils/screen_helper.dart';

class WebsiteCarousel extends StatefulWidget {
  @override
  _WebsiteCarouselState createState() => _WebsiteCarouselState();
}

class _WebsiteCarouselState extends State<WebsiteCarousel> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<Widget> websites = [
    WebsiteAd(
      title: "PEARL SCHOOL\nA WIX WEBSITE",
      description:
      "Designed and developed a dynamic and interactive website for a school using the Wix platform, enhancing its online presence and accessibility. Focused on creating an intuitive user interface with smooth navigation, ensuring an engaging experience for visitors. Incorporated features like event updates and contact forms to improve functionality and user interaction.",
      imageAsset: "assets/pearl.png",
      websiteUrl: "https://www.pearlmatricschool.com/",
    ),
    WebsiteAd(
      title: "PORTFOLIO LANDING\nPAGE DESIGN",
      description:
      "A creative and responsive landing page for personal branding. Built with animations, clean layout, and smooth scrolling.",
      imageAsset: "assets/landing.png",
      websiteUrl: "https://portfolio.example.com",
    ),
  ];

  void _nextPage() {
    setState(() {
      currentPage = (currentPage + 1) % websites.length;
      _pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: websites.length,
      itemBuilder: (context, index) {
        return websites[index];
      },
    );
  }
}

class WebsiteAd extends StatelessWidget {
  final String title;
  final String description;
  final String imageAsset;
  final String websiteUrl;

  const WebsiteAd({
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.websiteUrl,
  });

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(websiteUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, webOnlyWindowName: '_blank'); // ✅ open in new tab
    } else {
      throw 'Could not launch $websiteUrl';
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Flex(
              direction:
              constraints.maxWidth > 720 ? Axis.horizontal : Axis.vertical,
              children: [
                Expanded(
                  flex: constraints.maxWidth > 720.0 ? 1 : 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "WEBSITE",
                        style: GoogleFonts.oswald(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Text(
                        title,
                        style: GoogleFonts.oswald(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          height: 1.3,
                          fontSize: 35.0,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        description,
                        style: TextStyle(
                          color: kCaptionColor,
                          height: 1.5,
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Row(
                        children: [
                          _buildVisitWebsiteButton(_launchUrl),
                          SizedBox(width: 10.0),
                          _buildButton("NEXT APP", () {
                            final state =
                            context.findAncestorStateOfType<_WebsiteCarouselState>();
                            state?._nextPage();
                          }, outlined: true),
                        ],
                      ),
                      SizedBox(height: 70.0),
                    ],
                  ),
                ),
                SizedBox(width: 25.0),
                Expanded(
                  flex: constraints.maxWidth > 720.0 ? 1 : 0,
                  child: Image.asset(
                    imageAsset,
                    width: constraints.maxWidth > 720.0 ? null : 350.0,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildVisitWebsiteButton(VoidCallback onPressed) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        height: 48.0,
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: TextButton.icon(
          onPressed: onPressed,
          icon: Icon(Icons.open_in_new, color: Colors.white, size: 18),
          label: Text(
            "VISIT WEBSITE",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed,
      {bool outlined = false}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          color: outlined ? Colors.transparent : kPrimaryColor,
          borderRadius: BorderRadius.circular(8.0),
          border: outlined ? Border.all(color: kPrimaryColor) : null,
        ),
        height: 48.0,
        padding: EdgeInsets.symmetric(horizontal: 28.0),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            label,
            style: TextStyle(
              color: outlined ? kPrimaryColor : Colors.white,
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
