import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/skill.dart';
import '../../../utils/constants.dart';
import '../../../utils/screen_helper.dart';

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

class SkillSection extends StatelessWidget {
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
          builder: (BuildContext context, BoxConstraints constraints) {
            return Flex(
              direction: ScreenHelper.isMobile(context)
                  ? Axis.vertical
                  : Axis.horizontal,
              children: [
                Expanded(
                  flex: ScreenHelper.isMobile(context) ? 0 : 2,
                  child: Image.asset(
                    "assets/person_small.png",
                    width: 300.0,
                  ),
                ),
                SizedBox(width: 50.0),
                Expanded(
                  flex: ScreenHelper.isMobile(context) ? 0 : 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "SKILLS",
                        style: GoogleFonts.oswald(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                          fontSize: 28.0,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        "The Stack Behind the Products I Ship",
                        style: TextStyle(
                          color: kCaptionColor,
                          height: 1.5,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Column(
                        children: skills.map((skill) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 15.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: skill.percentage,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 10.0),
                                    alignment: Alignment.centerLeft,
                                    height: 38.0,
                                    color: kPrimaryColor,
                                    child: Text(
                                      skill.skill,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.0),
                                Expanded(
                                  flex: 100 - skill.percentage,
                                  child: Divider(color: Colors.white),
                                ),
                                SizedBox(width: 10.0),
                                Text(
                                  "${skill.percentage}%",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                )
                              ],
                            ),
                          );
                        }).toList(),
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
}
