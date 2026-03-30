import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/screen.dart';
import '../home_controller.dart';
import '../home_model.dart';
import 'category_item.dart';
import 'food_card.dart';

class HomeCategoriesStrip extends StatelessWidget {
  const HomeCategoriesStrip({
    super.key,
    required this.isDark,
    required this.controller,
  });

  final bool isDark;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final h = context.categoryRowHeight;
    return SizedBox(
      height: h,
      child: Obx(
        () {
          // Read Rx values here so GetX subscribes; reads inside ListView
          // itemBuilder run outside Obx's synchronous scope and won't rebuild.
          final selectedId = controller.selectedCategory.value;
          final categories = controller.categories;
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: context.hPad),
            itemCount: categories.length,
            separatorBuilder: (context, index) =>
                SizedBox(width: context.spacing(0.02)),
            itemBuilder: (_, i) {
              final cat = categories[i];
              final isSelected = selectedId == cat.id;
              return CategoryItem(
                category: cat,
                isSelected: isSelected,
                isDark: isDark,
                onTap: () => controller.selectCategory(cat.id),
              );
            },
          );
        },
      ),
    );
  }
}

class HomeFiltersRow extends StatelessWidget {
  const HomeFiltersRow({
    super.key,
    required this.isDark,
    required this.controller,
  });

  final bool isDark;
  final HomeController controller;

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
              isSelected: controller.isFilterSelected('Filters'),
              onTap: () => controller.toggleFilter('Filters'),
            ),
            SizedBox(width: context.spacing(0.02)),
            _FilterChip(
              label: 'Gourmet',
              isDark: isDark,
              isSelected: controller.isFilterSelected('Gourmet'),
              onTap: () => controller.toggleFilter('Gourmet'),
            ),
            SizedBox(width: context.spacing(0.02)),
            _FilterChip(
              label: 'Under ₹200',
              isDark: isDark,
              isSelected: controller.isFilterSelected('Under ₹200'),
              onTap: () => controller.toggleFilter('Under ₹200'),
            ),
            SizedBox(width: context.spacing(0.02)),
            _FilterChip(
              label: 'Schedule',
              icon: Icons.access_time_rounded,
              isDark: isDark,
              hasDropdown: true,
              isSelected: controller.isFilterSelected('Schedule'),
              onTap: () => controller.toggleFilter('Schedule'),
            ),
            SizedBox(width: context.spacing(0.02)),
            _FilterChip(
              label: 'Rating 4.0+',
              icon: Icons.star_rounded,
              iconColor: AppColors.warning,
              isDark: isDark,
              isSelected: controller.isFilterSelected('Rating 4.0+'),
              onTap: () => controller.toggleFilter('Rating 4.0+'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    this.icon,
    this.iconColor,
    required this.isDark,
    this.hasDropdown = false,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData? icon;
  final Color? iconColor;
  final bool isDark;
  final bool hasDropdown;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textColor = isSelected
        ? Colors.white
        : scheme.onSurface;
    final effectiveIconColor = isSelected
        ? Colors.white
        : (iconColor ?? scheme.onSurface);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: context.fs(12),
            vertical: context.fs(8),
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.cardDark : scheme.surface),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : scheme.outline.withValues(alpha: isDark ? 0.5 : 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.28)
                    : Colors.black.withValues(alpha: isDark ? 0.22 : 0.06),
                blurRadius: isSelected ? 12 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: effectiveIconColor),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: context.fs(12),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: textColor,
                ),
              ),
              if (hasDropdown) ...[
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: textColor,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
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
              color: scheme.onSurface,
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: context.fs(4)),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
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

class HomeRecommendedStrip extends StatelessWidget {
  const HomeRecommendedStrip({
    super.key,
    required this.isDark,
    required this.controller,
  });

  final bool isDark;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final cardW = context.foodCardWidth;
    final imgH = context.foodCardImageHeight(cardW);
    return SizedBox(
      height: context.recommendedHeight,
      child: Obx(() {
        if (controller.isLoading.value) {
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: context.hPad),
            itemCount: 4,
            separatorBuilder: (_, __) => SizedBox(width: context.sectionGap * 0.5),
            itemBuilder: (_, __) => FoodCardShimmer(
              width: cardW,
              imageHeight: imgH,
              isDark: isDark,
            ),
          );
        }
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: context.hPad),
          itemCount: controller.recommended.length,
          separatorBuilder: (_, __) => SizedBox(width: context.sectionGap * 0.5),
          itemBuilder: (_, i) => FoodCard(
            restaurant: controller.recommended[i],
            width: cardW,
            imageHeight: imgH,
            isDark: isDark,
          ),
        );
      }),
    );
  }
}

class HomeExploreStrip extends StatelessWidget {
  const HomeExploreStrip({
    super.key,
    required this.isDark,
    required this.controller,
  });

  final bool isDark;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final tileW = context.exploreTileWidth;
    final tileH = context.exploreTileHeight;
    return SizedBox(
      height: tileH,
      child: Obx(() {
        if (controller.isLoading.value) {
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: context.hPad),
            itemCount: 6,
            separatorBuilder: (_, __) => SizedBox(width: context.spacing(0.025)),
            itemBuilder: (_, __) => _ExploreShimmer(
              isDark: isDark,
              width: tileW,
              height: tileH,
            ),
          );
        }
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: context.hPad),
          itemCount: controller.exploreItems.length,
          itemBuilder: (_, i) {
            final item = controller.exploreItems[i];
            return Padding(
              padding: EdgeInsets.only(
                right: i < controller.exploreItems.length - 1
                    ? context.spacing(0.025)
                    : 0,
              ),
              child: _ExploreTile(
                item: item,
                isDark: isDark,
                width: tileW,
                height: tileH,
              ),
            );
          },
        );
      }),
    );
  }
}

class _ExploreTile extends StatefulWidget {
  const _ExploreTile({
    required this.item,
    required this.isDark,
    required this.width,
    required this.height,
  });

  final ExploreItem item;
  final bool isDark;
  final double width;
  final double height;

  @override
  State<_ExploreTile> createState() => _ExploreTileState();
}

class _ExploreTileState extends State<_ExploreTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.94,
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
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: widget.isDark ? 0.35 : 0.1,
                ),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _ExploreImage(item: widget.item, isDark: widget.isDark),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.45, 1.0],
                      colors: [
                        Colors.black.withValues(alpha: 0.05),
                        Colors.black.withValues(alpha: 0.28),
                        Colors.black.withValues(alpha: 0.75),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _iconFor(widget.item.iconType),
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: Text(
                    widget.item.title,
                    style: GoogleFonts.poppins(
                      fontSize: context.fs(12),
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

class _ExploreImage extends StatelessWidget {
  const _ExploreImage({required this.item, required this.isDark});

  final ExploreItem item;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      item.imageUrl,
      fit: BoxFit.cover,
      gaplessPlayback: true,
      errorBuilder: (_, __, ___) => Container(
        color: isDark ? AppColors.cardDark : const Color(0xFFE8E8E8),
        child: const Icon(Icons.image_not_supported_outlined),
      ),
    );
  }
}

class _ExploreShimmer extends StatelessWidget {
  const _ExploreShimmer({
    required this.isDark,
    required this.width,
    required this.height,
  });

  final bool isDark;
  final double width;
  final double height;

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
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}
