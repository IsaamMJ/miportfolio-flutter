import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/screen_helper.dart';

class WebsiteAd extends StatelessWidget {
  final String title;
  final String description;
  final String imageAsset;
  final VoidCallback onNext;

  const WebsiteAd({
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.onNext,
  });

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
                          _buildButton("EXPLORE MORE", () {}),
                          SizedBox(width: 10.0),
                          _buildButton("NEXT APP", onNext, outlined: true),
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
                color: outlined ? kPrimaryColor : Colors.black,
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
