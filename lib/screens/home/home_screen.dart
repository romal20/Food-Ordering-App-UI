import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/screen.dart';
import '../../widgets/category_item.dart';
import '../../widgets/food_card.dart';
import 'home_controller.dart';
import 'home_model.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      body: SafeArea(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeroBanner(isDark: isDark, controller: controller),
                    const SizedBox(height: 16),
                    _CategoriesSection(isDark: isDark, controller: controller),
                    const SizedBox(height: 12),
                    _FiltersRow(isDark: isDark, controller: controller),
                    const SizedBox(height: 20),
                    _SectionHeader(
                      title: 'Recommended For You',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),
                    _RecommendedSection(isDark: isDark, controller: controller),
                    const SizedBox(height: 24),
                    _SectionHeader(title: 'Explore More', isDark: isDark),
                    const SizedBox(height: 12),
                    _ExploreSection(isDark: isDark, controller: controller),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Hero Banner (Top bar + Search + Carousel) ───────────────────────────────

class _HeroBanner extends StatelessWidget {
  final bool isDark;
  final HomeController controller;
  const _HeroBanner({required this.isDark, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bannerHeight = context.sw >= 600 ? 300.0 : 250.0;
    // Total height = banner + full search bar (50) + gap below search (8)
    final totalHeight = bannerHeight + 58.0;

    return Container(
      color: Colors.white, // ✅ FIX
      child: SizedBox(
        height: totalHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ── Carousel fills banner area only
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: bannerHeight,
              child: PageView.builder(
                controller: controller.bannerPageController,
                onPageChanged: controller.onBannerPageChanged,
                itemCount: controller.banners.length,
                itemBuilder: (_, i) => _BannerSlide(
                  banner: controller.banners[i],
                  context: context,
                ),
              ),
            ),

            // ── Dot indicators — inside banner, above search bar
            Positioned(
              bottom: 66,
              left: 0,
              right: 0,
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    controller.banners.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: controller.bannerPage.value == i ? 20 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: controller.bannerPage.value == i
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Top bar row — overlaid at top of banner
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _TopBarOverlay(isDark: isDark, controller: controller),
            ),

            // ── Floating search + veg toggle — straddles banner bottom edge
            Positioned(
              bottom: 0,
              left: context.hPad,
              right: context.hPad,
              child: _FloatingSearchBar(isDark: isDark, controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Single banner slide ──────────────────────────────────────────────────────

class _BannerSlide extends StatelessWidget {
  final BannerItem banner;
  final BuildContext context;
  const _BannerSlide({required this.banner, required this.context});

  @override
  Widget build(BuildContext ctx) {
    final c1 = Color(banner.gradientColors[0]);
    final c2 = Color(banner.gradientColors[1]);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [c1, c2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Subtle vertical stripe texture
          Positioned.fill(child: CustomPaint(painter: _StripePainter())),

          // Food image — right side, slightly overflowing top
          Positioned(
            right: -10,
            top: 30,
            bottom: 40,
            width: context.sw * 0.48,
            child: CachedNetworkImage(
              imageUrl: banner.foodImageUrl,
              fit: BoxFit.contain,
              placeholder: (_, __) => const SizedBox(),
              errorWidget: (_, __, ___) => const SizedBox(),
            ),
          ),

          // Coin decorations
          Positioned(
            right: context.sw * 0.28,
            top: 55,
            child: _CoinDot(size: 22),
          ),
          Positioned(
            right: context.sw * 0.38,
            top: 90,
            child: _CoinDot(size: 14),
          ),

          // Text content — left side
          Positioned(
            left: context.hPad,
            top: 60,
            right: context.sw * 0.42,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  banner.headline,
                  style: GoogleFonts.poppins(
                    fontSize: context.fs(22),
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.15,
                    letterSpacing: -0.3,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade700,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    banner.subline,
                    style: GoogleFonts.poppins(
                      fontSize: context.fs(9),
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      banner.cta,
                      style: GoogleFonts.poppins(
                        fontSize: context.fs(12),
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Coin decoration dot ──────────────────────────────────────────────────────

class _CoinDot extends StatelessWidget {
  final double size;
  const _CoinDot({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFFFFD54F), Color(0xFFFFA000)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.5),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}

// ─── Stripe texture painter ───────────────────────────────────────────────────

class _StripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1;
    const spacing = 18.0;
    for (double x = 0; x < size.width + size.height; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x - size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StripePainter old) => false;
}

// ─── Top bar overlay (on banner) ─────────────────────────────────────────────

class _TopBarOverlay extends StatelessWidget {
  final bool isDark;
  final HomeController controller;
  const _TopBarOverlay({required this.isDark, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(context.hPad, 14, context.hPad, 0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'Thane',
                                style: GoogleFonts.poppins(
                                  fontSize: context.fs(14),
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: Colors.white70,
                            ),
                          ],
                        ),
                        Text(
                          'Mumbai, Maharashtra',
                          style: GoogleFonts.poppins(
                            fontSize: context.fs(10),
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Profile avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white, // ✅ solid
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_2_rounded,
              color: Colors.black87,
              size: 24,
            ),
          ),
          const SizedBox(width: 8),
          // Logout button
          GestureDetector(
            onTap: () => Get.offAllNamed('/login'),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // ✅ solid
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Colors.black87,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Floating search bar ──────────────────────────────────────────────────────

class _FloatingSearchBar extends StatelessWidget {
  final bool isDark;
  final HomeController controller;

  const _FloatingSearchBar({required this.isDark, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12), // 🔥 softer
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              cursorColor: AppColors.primary,
              style: GoogleFonts.poppins(
                fontSize: context.fs(13),
                fontWeight: FontWeight.w500,
                color: Colors.black87, // ✅ FIXED properly
              ),

              decoration: InputDecoration(
                hintText: 'Search "curries"',
                filled: true,
                fillColor: Colors.white,

                hintStyle: GoogleFonts.poppins(
                  fontSize: context.fs(13),
                  color: Colors.grey.shade500, // ✅ visible hint
                ),

                // 🔍 prefix
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Colors.grey.shade700,
                  size: 22,
                ),

                // 🎤 suffix
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 1,
                      height: 20,
                      color:
                          Colors.grey.shade300, // ✅ better than theme divider
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.mic_none_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                  ],
                ),

                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // 🥬 Veg Toggle
        Obx(
          () => _VegToggle(
            isOn: controller.isVegOnly.value,
            onTap: controller.toggleVeg,
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}

// ─── Veg Toggle ──────────────────────────────────────────────────────────────

class _VegToggle extends StatelessWidget {
  final bool isOn;
  final VoidCallback onTap;
  final bool isDark;

  const _VegToggle({
    required this.isOn,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'VEG',
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: isOn
                  ? AppColors.accent
                  : (isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight),
            ),
          ),
          const SizedBox(height: 4),

          // 🔥 ONLY SWITCH (NO BOX)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: 42,
            height: 22,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: isOn
                  ? AppColors.accent
                  : (isDark
                        ? const Color(0xFF444444)
                        : const Color(0xFFDDDDDD)),
              boxShadow: isOn
                  ? [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Categories ───────────────────────────────────────────────────────────────

class _CategoriesSection extends StatelessWidget {
  final bool isDark;
  final HomeController controller;
  const _CategoriesSection({required this.isDark, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: Obx(
        () => ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: context.hPad),
          itemCount: controller.categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final cat = controller.categories[i];
            final isSelected = controller.selectedCategory.value == cat.id;
            return CategoryItem(
              category: cat,
              isSelected: isSelected,
              isDark: isDark,
              onTap: () => controller.selectCategory(cat.id),
            );
          },
        ),
      ),
    );
  }
}

// ─── Filter Chips ─────────────────────────────────────────────────────────────

class _FiltersRow extends StatelessWidget {
  final bool isDark;
  final HomeController controller;
  const _FiltersRow({required this.isDark, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: context.hPad),
      child: Obx(
        () => Row(
          children: [
            _FilterChip(
              label: 'Filters',
              icon: Icons.tune_rounded,
              isDark: isDark,
              hasDropdown: true,
              isSelected: false,
              onTap: () {},
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'Gourmet',
              isDark: isDark,
              isSelected: controller.selectedFilter.value == 'Gourmet',
              onTap: () => controller.selectFilter('Gourmet'),
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'Under ₹200',
              isDark: isDark,
              isSelected: controller.selectedFilter.value == 'Under ₹200',
              onTap: () => controller.selectFilter('Under ₹200'),
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'Schedule',
              icon: Icons.access_time_rounded,
              isDark: isDark,
              hasDropdown: true,
              isSelected: false,
              onTap: () {},
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: 'Rating 4.0+',
              icon: Icons.star_rounded,
              iconColor: AppColors.warning,
              isDark: isDark,
              isSelected: controller.selectedFilter.value == 'Rating 4.0+',
              onTap: () => controller.selectFilter('Rating 4.0+'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? iconColor;
  final bool isDark;
  final bool hasDropdown;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    this.icon,
    this.iconColor,
    required this.isDark,
    this.hasDropdown = false,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isSelected
        ? Colors.white
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight);
    final effectiveIconColor = isSelected
        ? Colors.white
        : (iconColor ??
              (isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight));

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.cardDark : Colors.white),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.dividerDark : AppColors.dividerLight),
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.25)
                  : Colors.black.withValues(alpha: isDark ? 0.15 : 0.05),
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: effectiveIconColor),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: textColor,
              ),
            ),
            if (hasDropdown) ...[
              const SizedBox(width: 3),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 14,
                color: textColor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isDark;
  const _SectionHeader({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.hPad),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: context.fs(12),
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              'See all',
              style: GoogleFonts.poppins(
                fontSize: context.fs(12),
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Recommended Section ──────────────────────────────────────────────────────

class _RecommendedSection extends StatelessWidget {
  final bool isDark;
  final HomeController controller;
  const _RecommendedSection({required this.isDark, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.recommendedHeight,
      child: Obx(() {
        if (controller.isLoading.value) {
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: context.hPad),
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, __) =>
                FoodCardShimmer(width: context.foodCardWidth, isDark: isDark),
          );
        }
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: context.hPad),
          itemCount: controller.recommended.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, i) => FoodCard(
            restaurant: controller.recommended[i],
            width: context.foodCardWidth,
            isDark: isDark,
          ),
        );
      }),
    );
  }
}

// ─── Explore Section ──────────────────────────────────────────────────────────

// ─── Explore Section — compact horizontal scroll ──────────────────────────────

class _ExploreSection extends StatelessWidget {
  final bool isDark;
  final HomeController controller;
  const _ExploreSection({required this.isDark, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Obx(() {
        if (controller.isLoading.value) {
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: context.hPad),
            itemCount: 6,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, __) => _ExploreShimmer(isDark: isDark),
          );
        }
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: context.hPad),
          itemCount: controller.exploreItems.length,
          itemBuilder: (_, i) => Padding(
            padding: EdgeInsets.only(
              right: i < controller.exploreItems.length - 1 ? 10 : 0,
            ),
            child: _ExploreCard(
              item: controller.exploreItems[i],
              isDark: isDark,
            ),
          ),
        );
      }),
    );
  }
}

// ─── Explore Card — compact horizontal tile ───────────────────────────────────

class _ExploreCard extends StatefulWidget {
  final ExploreItem item;
  final bool isDark;
  const _ExploreCard({required this.item, required this.isDark});

  @override
  State<_ExploreCard> createState() => _ExploreCardState();
}

class _ExploreCardState extends State<_ExploreCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.93,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.reverse(),
      onTapUp: (_) => _ctrl.forward(),
      onTapCancel: () => _ctrl.forward(),
      onTap: () {},
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) =>
            Transform.scale(scale: _ctrl.value, child: child),
        child: Container(
          width: 148,
          height: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: widget.isDark ? 0.28 : 0.09,
                ),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                CachedNetworkImage(
                  imageUrl: widget.item.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: widget.isDark
                        ? AppColors.cardDark
                        : const Color(0xFFE8E8E8),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: widget.isDark
                        ? AppColors.cardDark
                        : const Color(0xFFE8E8E8),
                  ),
                ),

                // Gradient overlay — stronger at bottom for text legibility
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.45, 1.0],
                      colors: [
                        Colors.black.withValues(alpha: 0.05),
                        Colors.black.withValues(alpha: 0.25),
                        Colors.black.withValues(alpha: 0.72),
                      ],
                    ),
                  ),
                ),

                // Icon — top-left
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Icon(
                      _iconFor(widget.item.iconType),
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),

                // Title — bottom-left
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: Text(
                    widget.item.title,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                      shadows: const [
                        Shadow(color: Colors.black54, blurRadius: 4),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'gourmet':
        return Icons.restaurant_menu_rounded;
      case 'party':
        return Icons.celebration_rounded;
      case 'collection':
        return Icons.collections_bookmark_rounded;
      case 'gift':
        return Icons.card_giftcard_rounded;
      case 'train':
        return Icons.train_rounded;
      case 'offer':
        return Icons.local_offer_rounded;
      default:
        return Icons.restaurant_rounded;
    }
  }
}

// ─── Explore Shimmer ─────────────────────────────────────────────────────────

class _ExploreShimmer extends StatelessWidget {
  final bool isDark;
  const _ExploreShimmer({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final base = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0);
    final highlight = isDark
        ? const Color(0xFF3A3A3A)
        : const Color(0xFFF5F5F5);
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Container(
        width: 148,
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
