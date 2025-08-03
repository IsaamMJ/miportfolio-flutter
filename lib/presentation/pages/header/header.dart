import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:miportfolio/present'
    'ation/pages/header/widgets/app_logo.dart';
import 'package:miportfolio/presentation/pages/header/widgets/header_menu_button.dart';
import 'package:miportfolio/presentation/pages/header/widgets/header_nav_item.dart';
import '../../../data/models/header_item.dart';
import '../../../data/repositories/header_repository_impl.dart';
import '../../../domain/repository/header_repository.dart';
import '../../../utils/globals.dart';
import '../../../utils/responsive_helper.dart';
import 'header_animation_mixin.dart';

final HeaderRepository _headerRepository = HeaderRepositoryImpl();
final List<HeaderItem> headerItems = _headerRepository.getHeaderItems();

class EnhancedHeader extends StatefulWidget {
  final ScrollController? scrollController;

  const EnhancedHeader({Key? key, this.scrollController}) : super(key: key);

  @override
  _EnhancedHeaderState createState() => _EnhancedHeaderState();
}

class _EnhancedHeaderState extends State<EnhancedHeader>
    with TickerProviderStateMixin, HeaderAnimationMixin {
  bool _isScrolled = false;
  int _hoveredIndex = -1;
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    initHeaderAnimations();

    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController!.addListener(_onScroll);

    slideController.forward();
    fadeController.forward();
  }

  void _onScroll() {
    final isScrolled = _scrollController!.offset > 50;
    if (isScrolled != _isScrolled) {
      setState(() {
        _isScrolled = isScrolled;
      });
    }
  }

  @override
  void dispose() {
    disposeHeaderAnimations();
    if (widget.scrollController == null) {
      _scrollController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: _isScrolled ? 8 : 0,
      shadowColor: Colors.black.withOpacity(0.1),
      child: SlideTransition(
        position: slideAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.transparent),
            child: ResponsiveHelper.isMobile(context)
                ? _buildMobileHeader()
                : ResponsiveHelper.isTablet(context)
                ? _buildTabletHeader()
                : _buildDesktopHeader(),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopHeader() {
    final padding = ResponsiveHelper.getResponsivePadding(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: _isScrolled
          ? ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: _buildHeaderBase(padding, true),
        ),
      )
          : _buildHeaderBase(padding, false),
    );
  }

  Widget _buildTabletHeader() => _buildMobileOrTabletHeader();
  Widget _buildMobileHeader() => _buildMobileOrTabletHeader();

  Widget _buildMobileOrTabletHeader() {
    final padding = ResponsiveHelper.getResponsivePadding(context);
    final verticalPadding = ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: 12.0,
      tablet: 14.0,
      desktop: 16.0,
    );

    return SafeArea(
      bottom: false,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: padding,
              vertical: verticalPadding,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[200]!.withOpacity(0.5),
                  width: 1.0,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20.0,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppLogo(isScrolled: _isScrolled),
                const HeaderMenuButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderBase(double padding, bool scrolled) {
    final verticalPadding = ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: 14.0,
      tablet: 15.0,
      desktop: 16.0,
    );

    final maxWidth = ResponsiveHelper.getResponsiveValue<double>(
      context,
      mobile: double.infinity,
      tablet: 1200.0,
      desktop: 1400.0,
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: scrolled ? Colors.white.withOpacity(0.85) : Colors.transparent,
        border: scrolled
            ? Border(
          bottom: BorderSide(
            color: Colors.grey[200]!.withOpacity(0.5),
            width: 1.0,
          ),
        )
            : null,
        boxShadow: scrolled
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 25.0,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          )
        ]
            : [],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppLogo(isScrolled: _isScrolled),
            _buildDesktopNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopNavigation() {
    return Flexible(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ValueListenableBuilder<int>(
          valueListenable: Globals.activeSectionIndex,
          builder: (context, activeIndex, _) {
            return Row(
              children: headerItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                return HeaderNavItem(
                  item: item,
                  isHovered: _hoveredIndex == index,
                  isActive: activeIndex == index,
                  isScrolled: _isScrolled,
                  onTap: () {
                    Globals.activeSectionIndex.value = index;
                    item.onTap();
                  },
                  onEnter: () => setState(() => _hoveredIndex = index),
                  onExit: () => setState(() => _hoveredIndex = -1),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

}
