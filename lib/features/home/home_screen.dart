import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/screen.dart';
import '../../widgets/app_scaffold_background.dart';
import 'widgets/home_banner_section.dart';
import 'widgets/home_feed_sections.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppScaffoldBackground(
        isDark: isDark,
        child: SafeArea(
          child: RefreshIndicator(
            color: AppColors.primary,
            strokeWidth: 2.5,
            onRefresh: controller.refresh,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.easeOutCubic,
                    builder: (context, t, child) {
                      return Opacity(
                        opacity: t,
                        child: Transform.translate(
                          offset: Offset(0, 12 * (1 - t)),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HomeBannerSection(
                          isDark: isDark,
                          controller: controller,
                        ),
                        SizedBox(height: context.sectionGap),
                        HomeCategoriesStrip(
                          isDark: isDark,
                          controller: controller,
                        ),
                        SizedBox(height: context.spacing(0.015)),
                        HomeFiltersRow(
                          isDark: isDark,
                          controller: controller,
                        ),
                        SizedBox(height: context.sectionGap),
                        const HomeSectionHeader(
                          title: 'Recommended For You',
                        ),
                        SizedBox(height: context.spacing(0.015)),
                        HomeRecommendedStrip(
                          isDark: isDark,
                          controller: controller,
                        ),
                        SizedBox(height: context.sectionGap),
                        const HomeSectionHeader(title: 'Explore More'),
                        SizedBox(height: context.spacing(0.015)),
                        HomeExploreStrip(
                          isDark: isDark,
                          controller: controller,
                        ),
                        SizedBox(height: context.sectionGap * 1.25),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
