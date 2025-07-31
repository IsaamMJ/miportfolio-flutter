import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../utils/constants.dart';
import '../../../utils/screen_helper.dart';
import 'carousel_items.dart';

class Carousel extends StatelessWidget {
  final CarouselSliderController carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    double carouselContainerHeight = MediaQuery.of(context).size.height *
        (ScreenHelper.isMobile(context) ? .7 : .85);

    return Container(
      height: carouselContainerHeight,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CarouselSlider.builder(
            itemCount: carouselItems.length,
            carouselController: carouselController, // ✅ Now works correctly
            options: CarouselOptions(
              viewportFraction: 1,
              scrollPhysics: const NeverScrollableScrollPhysics(),
              height: carouselContainerHeight,
            ),
            itemBuilder: (context, index, realIndex) {
              return Container(
                constraints: BoxConstraints(
                  minHeight: carouselContainerHeight,
                ),
                child: ScreenHelper(
                  desktop: _buildDesktop(
                    context,
                    carouselItems[index].text,
                    carouselItems[index].image,
                  ),
                  tablet: _buildTablet(
                    context,
                    carouselItems[index].text,
                    carouselItems[index].image,
                  ),
                  mobile: _buildMobile(
                    context,
                    carouselItems[index].text,
                    carouselItems[index].image,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Desktop Layout
Widget _buildDesktop(BuildContext context, Widget text, Widget image) {
  return Center(
    child: MaxWidthBox(
      maxWidth: kDesktopMaxWidth,
      child: Row(
        children: [
          Expanded(child: text),
          Expanded(child: image),
        ],
      ),
    ),
  );
}

// Tablet Layout
Widget _buildTablet(BuildContext context, Widget text, Widget image) {
  return Center(
    child: MaxWidthBox(
      maxWidth: kTabletMaxWidth,
      child: Row(
        children: [
          Expanded(child: text),
          Expanded(child: image),
        ],
      ),
    ),
  );
}

// Mobile Layout (conditional image display)
Widget _buildMobile(BuildContext context, Widget text, Widget image) {
  double screenWidth = MediaQuery.of(context).size.width;
  bool showImage = screenWidth > 600; // Show image only if width > 600px

  return Center(
    child: MaxWidthBox(
      maxWidth: getMobileMaxWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showImage ? Expanded(flex: 2, child: text) : Expanded(child: text),
          if (showImage) ...[
            const SizedBox(height: 20),
            Expanded(flex: 1, child: image),
          ],
        ],
      ),
    ),
  );
}