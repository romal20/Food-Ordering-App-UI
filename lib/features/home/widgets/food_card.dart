import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../home_controller.dart';
import '../home_model.dart';

class FoodCard extends StatefulWidget {
  const FoodCard({
    super.key,
    required this.restaurant,
    required this.width,
    required this.imageHeight,
    required this.isDark,
  });

  final Restaurant restaurant;
  final double width;
  final double imageHeight;
  final bool isDark;

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleCtrl;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTapDown: (_) => _scaleCtrl.reverse(),
      onTapUp: (_) => _scaleCtrl.forward(),
      onTapCancel: () => _scaleCtrl.forward(),
      onTap: () {},
      child: AnimatedBuilder(
        animation: _scaleCtrl,
        builder: (_, child) =>
            Transform.scale(scale: _scaleCtrl.value, child: child),
        child: Container(
          width: widget.width,
          decoration: BoxDecoration(
            color: widget.isDark ? AppColors.cardDark : scheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: widget.isDark ? 0.32 : 0.08,
                ),
                blurRadius: 18,
                spreadRadius: 0,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(
              color: scheme.outline.withValues(alpha: widget.isDark ? 0.35 : 0.12),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CardImage(
                restaurant: widget.restaurant,
                width: widget.width,
                height: widget.imageHeight,
              ),
              _CardInfo(
                restaurant: widget.restaurant,
                isDark: widget.isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  const _CardImage({
    required this.restaurant,
    required this.width,
    required this.height,
  });

  final Restaurant restaurant;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Image.asset(
            restaurant.imageUrl,
            width: width,
            height: height,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            errorBuilder: (_, __, ___) => Container(
              width: width,
              height: height,
              color: const Color(0xFFEEEEEE),
              child: const Icon(
                Icons.broken_image_outlined,
                color: AppColors.primary,
                size: 28,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            child: Container(
              height: height * 0.38,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.55),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
        if (restaurant.discountPercent != null &&
            restaurant.discountPercent! > 0)
          Positioned(
            top: 10,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '${restaurant.discountPercent}% OFF',
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        if (restaurant.offer.isNotEmpty)
          Positioned(
            top: 10,
            left: 0,
            child: Container(
              constraints: BoxConstraints(maxWidth: width * 0.62),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF8A00), Color(0xFFFF6B00)],
                ),
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x44FF6B00),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                restaurant.offer,
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        Positioned(
          bottom: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, size: 12, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  restaurant.rating.toStringAsFixed(1),
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CardInfo extends StatelessWidget {
  const _CardInfo({required this.restaurant, required this.isDark});

  final Restaurant restaurant;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textPrimary = scheme.onSurface;
    final textSecondary = scheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            restaurant.name,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: textPrimary,
              letterSpacing: -0.1,
              height: 1.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            restaurant.cuisine,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: textSecondary,
              height: 1.25,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (restaurant.priceLabel != null &&
              restaurant.priceLabel!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              restaurant.priceLabel!,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                height: 1.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 4),
          _DeliveryRow(restaurant: restaurant, isDark: isDark),
        ],
      ),
    );
  }
}

class _DeliveryRow extends StatefulWidget {
  const _DeliveryRow({required this.restaurant, required this.isDark});

  final Restaurant restaurant;
  final bool isDark;

  @override
  State<_DeliveryRow> createState() => _DeliveryRowState();
}

class _DeliveryRowState extends State<_DeliveryRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fade;
  String _prevLabel = '';

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: 1.0,
    );
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _animateChange() {
    _fadeCtrl.reverse().then((_) {
      if (mounted) _fadeCtrl.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textSecondary = scheme.onSurfaceVariant;

    return Obx(() {
      final ctrl = Get.find<HomeController>();
      ctrl.deliveryLabelIndex[widget.restaurant.id];

      final label = ctrl.deliveryLabel(widget.restaurant);
      final isNF = ctrl.isNearFastLabel(widget.restaurant);

      if (_prevLabel.isNotEmpty && _prevLabel != label) {
        _animateChange();
      }
      _prevLabel = label;

      return FadeTransition(
        opacity: _fade,
        child: Row(
          children: [
            Icon(
              isNF ? Icons.bolt_rounded : Icons.access_time_rounded,
              size: 14,
              color: isNF ? AppColors.success : textSecondary,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isNF ? AppColors.success : textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.restaurant.deliveryFee == 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'FREE',
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: AppColors.success,
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}

class FoodCardShimmer extends StatelessWidget {
  const FoodCardShimmer({
    super.key,
    required this.width,
    required this.imageHeight,
    required this.isDark,
  });

  final double width;
  final double imageHeight;
  final bool isDark;

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
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width,
              height: imageHeight,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: width * 0.7,
                    height: 12,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: width * 0.5,
                    height: 10,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: width * 0.4,
                    height: 10,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
