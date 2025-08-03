import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../../../../utils/globals.dart';
import '../../../../../utils/responsive_helper.dart';

class HeaderMenuButton extends StatelessWidget {
  const HeaderMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconSize = ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: 20.0,
      tablet: 22.0,
      desktop: 24.0,
    );

    final buttonPadding = ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: 8.0,
      tablet: 9.0,
      desktop: 10.0,
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Globals.scaffoldKey.currentState?.openEndDrawer(),
        child: Container(
          padding: EdgeInsets.all(buttonPadding),
          decoration: BoxDecoration(
            color: Colors.grey[100]?.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.grey[300]!.withOpacity(0.5),
              width: 1.0,
            ),
          ),
          child: Icon(
            FeatherIcons.menu,
            color: Colors.grey[700],
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
