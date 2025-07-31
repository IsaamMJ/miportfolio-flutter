import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../utils/constants.dart';
import '../../utils/globals.dart';
import 'components/carousel.dart';
import 'components/cv_section.dart';
import 'components/education_section.dart';
import 'components/footer.dart';
import 'components/header.dart';
import 'components/ios_app_ad.dart';
import 'components/website_carousel.dart';   // ✅ New import
import 'components/portfolio_stats.dart';
import 'components/skill_section.dart';
import 'components/testimonial_widget.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Globals.scaffoldKey,
      endDrawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return headerItems[index].isButton
                    ? MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    decoration: BoxDecoration(
                      color: kDangerColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 28.0),
                    child: TextButton(
                      onPressed: headerItems[index].onTap,
                      child: Text(
                        headerItems[index].title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
                    : ListTile(
                  title: Text(
                    headerItems[index].title,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 10.0);
              },
              itemCount: headerItems.length,
            ),
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(),
              Carousel(),
              SizedBox(height: 20.0),
              CvSection(),

              // ✅ App project section
              Container(
                height: 600.0,
                child: AppCarousel(),
              ),

              // ✅ Website project section
              Container(
                height: 600.0,
                child: WebsiteCarousel(),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 28.0),
                child: PortfolioStats(),
              ),
              SizedBox(height: 50.0),
              EducationSection(),
              SizedBox(height: 50.0),
              SkillSection(),
              SizedBox(height: 50.0),
              SizedBox(height: 50.0),
              TestimonialWidget(),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }
}