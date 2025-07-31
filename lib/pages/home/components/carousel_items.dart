import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/carousel_item_model.dart';
import '../../../utils/constants.dart';
import 'dart:html' as html; // ✅ Required for web download

List<CarouselItemModel> carouselItems = List.generate(
  5,
      (index) => CarouselItemModel(
    text: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "PRODUCT DEVELOPER",
            style: GoogleFonts.oswald(
              color: kPrimaryColor,
              fontWeight: FontWeight.w900,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 18.0),
          Text(
            "MOHAMED\nISAAM M J",
            style: GoogleFonts.oswald(
              color: Colors.black,
              fontSize: 40.0,
              fontWeight: FontWeight.w900,
              height: 1.3,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            "Cross Platform App Developer, based on India",
            style: TextStyle(
              color: kCaptionColor,
              fontSize: 15.0,
              height: 1.0,
            ),
          ),
          SizedBox(height: 10.0),
          Wrap(
            children: [
              Text(
                "Have a product in mind?",
                style: TextStyle(
                  color: kCaptionColor,
                  fontSize: 15.0,
                  height: 1.5,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Text(
                    " Got a project? Let's talk.",
                    style: TextStyle(
                      height: 1.5,
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 25.0),
          Row(
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  height: 48.0,
                  padding: EdgeInsets.symmetric(horizontal: 28.0),
                  child: TextButton(
                    onPressed: () {
                      html.AnchorElement anchor = html.AnchorElement(href: 'https://github.com/IsaamMJ')
                        ..target = '_blank'
                        ..click();
                    },

                    child: Text(
                      "EXPLORE MY GITHUB",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.0),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  height: 48.0,
                  padding: EdgeInsets.symmetric(horizontal: 28.0),
                  child: TextButton(
                    onPressed: () {
                      html.AnchorElement anchor = html.AnchorElement(href: 'assets/resume.pdf')
                        ..setAttribute("download", "Mohamed_Isaam_Resume.pdf")
                        ..click();

                    },
                    child: Text(
                      "DOWNLOAD CV",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    image: Container(
      child: Image.asset(
        "assets/person.png",
        fit: BoxFit.contain,
      ),
    ),
  ),
);
