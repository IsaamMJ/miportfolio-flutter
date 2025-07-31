import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/constants.dart';
import '../../../utils/screen_helper.dart';

class AppCarousel extends StatefulWidget {
  @override
  _AppCarouselState createState() => _AppCarouselState();
}

class _AppCarouselState extends State<AppCarousel> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<Widget> apps = [
    IosAppAd(),
    AnotherAppAd(),
  ];

  void _nextPage() {
    setState(() {
      currentPage = (currentPage + 1) % apps.length;
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
      itemCount: apps.length,
      itemBuilder: (context, index) {
        return apps[index];
      },
    );
  }
}

class IosAppAd extends StatelessWidget {
  final VoidCallback? onNext;

  IosAppAd({this.onNext});

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
              direction: constraints.maxWidth > 720
                  ? Axis.horizontal
                  : Axis.vertical,
              children: [
                Expanded(
                  flex: constraints.maxWidth > 720.0 ? 1 : 0,
                  child: Image.asset(
                    "assets/skyfeed.png",
                    width: constraints.maxWidth > 720.0 ? null : 350.0,
                  ),
                ),
                SizedBox(width: constraints.maxWidth > 720.0 ? 25.0 : 0),
                Expanded(
                  flex: constraints.maxWidth > 720.0 ? 1 : 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "SkyFeed",
                        style: GoogleFonts.oswald(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Text(
                        "PERSONALIZED\nNEWS & FORECASTS",
                        style: GoogleFonts.oswald(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          height: 1.3,
                          fontSize: 35.0,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "This application is designed to seamlessly integrate real-time weather data with curated news content, offering users a personalized and intuitive experience...",
                        style: TextStyle(
                          color: kCaptionColor,
                          height: 1.5,
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Row(
                        children: [
                          _buildButton("EXPLORE MORE", () {}),
                          SizedBox(width: 10.0),
                          _buildButton("NEXT APP", () {
                            // Find the parent PageView controller
                            final state = context.findAncestorStateOfType<_AppCarouselState>();
                            state?._nextPage();
                          }, outlined: true),
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
          child: Center(
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
      ),
    );
  }
}

class AnotherAppAd extends StatelessWidget {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Another App",
              style: GoogleFonts.oswald(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Description and features of another app go here.",
              style: TextStyle(fontSize: 16, color: kCaptionColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                final state = context.findAncestorStateOfType<_AppCarouselState>();
                state?._nextPage();
              },
              child: Text("NEXT APP"),
            )
          ],
        ),
      ),
    );
  }
}
