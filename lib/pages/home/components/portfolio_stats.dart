import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/stat.dart';
import '../../../utils/constants.dart';
import '../../../utils/screen_helper.dart';

final List<Stat> stats = [
  Stat(count: "2", text: "Clients"),
  Stat(count: "10", text: "Projects"),
  Stat(count: "5", text: "Awards"),
  Stat(count: "2", text: "Years\nExperience"),
];

class PortfolioStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 40.0),
      child: ScreenHelper(
        desktop: _buildUi(kDesktopMaxWidth, context),
        tablet: _buildUi(kTabletMaxWidth, context),
        mobile: _buildUi(getMobileMaxWidth(context), context),
      ),
    );
  }

  Widget _buildUi(double width, BuildContext context) {
    return Container(
      width: width,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraint) {
          return Wrap(
            spacing: 20.0,
            runSpacing: 20.0,
            children: stats.map((stat) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                width: ScreenHelper.isMobile(context)
                    ? constraint.maxWidth / 2.0 - 20
                    : (constraint.maxWidth / 4.0 - 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      stat.count,
                      style: GoogleFonts.oswald(
                        fontWeight: FontWeight.w700,
                        fontSize: 32.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Flexible(
                      child: Text(
                        stat.text,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: kCaptionColor,
                        ),
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
