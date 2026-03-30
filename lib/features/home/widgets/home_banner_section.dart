// Home banner section widgets.
//
// Implements the top carousel with a decorative stripe background, floating
// search row, and light/dark/theme + veg toggle overlays.
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/theme_controller.dart';
import '../home_controller.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/screen.dart';
import '../home_model.dart';

// Top banner carousel + overlays (location/theme buttons and search row).
class HomeBannerSection extends StatelessWidget {
  const HomeBannerSection({
    super.key,
    required this.isDark,
    required this.controller,
  });

  final bool isDark;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final bannerHeight = context.bannerHeight;
    final searchH = context.searchBarHeight;
    final totalHeight = bannerHeight + searchH + context.spacing(0.012);

    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
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
                parentContext: context,
              ),
            ),
          ),
          Positioned(
            bottom: searchH + 10,
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
                    width: controller.bannerPage.value == i ? 22 : 6,
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _TopBarOverlay(
              isDark: isDark,
              controller: controller,
            ),
          ),
          Positioned(
            bottom: 0,
            left: context.hPad,
            right: context.hPad,
            child: _FloatingSearchRow(
              isDark: isDark,
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }
}

/// A single banner slide that lays out headline/subline/CTA plus hero image.
class _BannerSlide extends StatelessWidget {
  const _BannerSlide({
    required this.banner,
    required this.parentContext,
  });

  final BannerItem banner;
  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    final c1 = Color(banner.gradientColors[0]);
    final c2 = Color(banner.gradientColors[1]);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [c1, c2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: c2.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bw = constraints.maxWidth;
            final bh = constraints.maxHeight;
            final pad = parentContext.hPad;
            final isNarrow = bw < 360;
            final isWide = bw >= 600;
            // Image column: ~32–40% of width; never eat the whole row
            final imageColW = (bw * (isNarrow ? 0.30 : (isWide ? 0.40 : 0.36)))
                .clamp(100.0, bw * 0.44);
            // Vertical budget: avoid padding that leaves no room for text + image row
            final paddingBottom =
                math.max(12.0, bh * 0.055).clamp(12.0, 20.0);
            final topBarClearance = math.max(52.0, bh * 0.12) +
                (isNarrow ? 6.0 : parentContext.spacing(0.012));
            // Minimum space for headline + tag + CTA (2-line title, tight gaps)
            const minContentHeight = 118.0;
            final maxPaddingTop = math.max(
              44.0,
              bh - paddingBottom - minContentHeight,
            );
            final paddingTop = math.min(topBarClearance, maxPaddingTop);
            final availableH = math.max(1.0, bh - paddingTop - paddingBottom);
            final headlinePx = math
                .min(parentContext.fs(22), bw * 0.065)
                .clamp(14.0, 28.0);
            final coinLarge = (bw * 0.055).clamp(16.0, 24.0);
            final coinSmall = coinLarge * 0.62;
            // Tighter gaps on short banners
            final tight = bh < 260;
            final gapTitleToOffer =
                (math.max(8.0, bh * 0.022).clamp(8.0, 14.0)) * (tight ? 0.92 : 1.0);
            final gapOfferToCta =
                (math.max(12.0, bh * 0.028).clamp(12.0, 18.0)) * (tight ? 0.92 : 1.0);
            // Inset hero image from banner edge (dp)
            final imageTrailInset = math.max(12.0, math.min(16.0, pad * 0.75));
            final imageRadius = 20.0;
            final imageDisplayW = (imageColW - imageTrailInset).clamp(96.0, imageColW);
            // Never ask for more image height than fits beside the text row
            final imageDisplayH = math.min(
              (bh * 0.58).clamp(96.0, bh * 0.72),
              availableH,
            );

            return Stack(
              clipBehavior: Clip.hardEdge,
              fit: StackFit.expand,
              children: [
                const Positioned.fill(
                  child: CustomPaint(painter: _StripePainter()),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    pad,
                    paddingTop,
                    imageTrailInset,
                    paddingBottom,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: availableH,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.topLeft,
                            child: SizedBox(
                              width: math.max(
                                1.0,
                                bw - pad - imageColW - imageTrailInset - 8,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    banner.headline,
                                    style: GoogleFonts.poppins(
                                      fontSize: headlinePx,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      height: 1.12,
                                      letterSpacing: -0.3,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.25),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: gapTitleToOffer),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: parentContext.fs(8),
                                        vertical: parentContext.fs(4),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade700,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.2),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        banner.subline,
                                        style: GoogleFonts.poppins(
                                          fontSize: parentContext.fs(9),
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          letterSpacing: 0.3,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: gapOfferToCta),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {},
                                      borderRadius: BorderRadius.circular(28),
                                      child: Ink(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: parentContext.fs(16),
                                          vertical: parentContext.fs(9),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black
                                              .withValues(alpha: 0.88),
                                          borderRadius:
                                              BorderRadius.circular(28),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.25,
                                              ),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          banner.cta,
                                          style: GoogleFonts.poppins(
                                            fontSize: parentContext.fs(12),
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: imageColW,
                        height: availableH,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.bottomRight,
                          children: [
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: _BannerHeroImage(
                                assetPath: banner.foodImageUrl,
                                width: imageDisplayW,
                                height: imageDisplayH,
                                borderRadius: imageRadius,
                              ),
                            ),
                            Positioned(
                              right: imageDisplayW * 0.22,
                              top: bh * 0.08,
                              child: _CoinDot(size: coinLarge),
                            ),
                            Positioned(
                              right: imageDisplayW * 0.48,
                              top: bh * 0.17,
                              child: _CoinDot(size: coinSmall),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Rounded hero image with subtle depth; inset from banner edge via parent.
class _BannerHeroImage extends StatelessWidget {
  const _BannerHeroImage({
    required this.assetPath,
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  final String assetPath;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(borderRadius);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: r,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: r,
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          width: width,
          height: height,
          alignment: Alignment.bottomRight,
          gaplessPlayback: true,
          errorBuilder: (context, error, stackTrace) =>
              const SizedBox.shrink(),
        ),
      ),
    );
  }
}

/// Decorative coin dots used to add depth to the banner.
class _CoinDot extends StatelessWidget {
  const _CoinDot({required this.size});

  final double size;

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

/// Paints a subtle diagonal stripe pattern across the banner background.
class _StripePainter extends CustomPainter {
  const _StripePainter();

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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Top overlay row shown above the banner (location, theme toggle, etc.).
class _TopBarOverlay extends StatelessWidget {
  const _TopBarOverlay({
    required this.isDark,
    required this.controller,
  });

  final bool isDark;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final themeCtrl = Get.find<ThemeController>();
    final avatar = (context.sw * 0.09).clamp(34.0, 44.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.hPad,
        context.spacing(0.016),
        context.hPad,
        10,
      ),
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
                    size: 20,
                  ),
                  const SizedBox(width: 6),
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
          _RoundIconButton(
            size: avatar,
            icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            onTap: themeCtrl.toggleTheme,
          ),
          SizedBox(width: context.spacing(0.01)),
          _RoundIconButton(
            size: avatar,
            icon: Icons.person_2_rounded,
            onTap: () {},
          ),
          SizedBox(width: context.spacing(0.01)),
          _RoundIconButton(
            size: avatar,
            icon: Icons.logout_rounded,
            onTap: () => Get.offAllNamed(AppRoutes.login),
          ),
        ],
      ),
    );
  }
}

/// Circular icon button used in the top overlay.
class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.size,
    required this.icon,
    required this.onTap,
  });

  final double size;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, color: Colors.black87, size: size * 0.55),
        ),
      ),
    );
  }
}

/// Search row + mic icon and the right-side interactions.
class _FloatingSearchRow extends StatelessWidget {
  const _FloatingSearchRow({
    required this.isDark,
    required this.controller,
  });

  final bool isDark;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final h = context.searchBarHeight;
    final fill = Theme.of(context).colorScheme.surface;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: h,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: TextField(
              cursorColor: AppColors.primary,
              style: GoogleFonts.inter(
                fontSize: context.fs(13),
                fontWeight: FontWeight.w500,
                color: onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Search dishes & restaurants',
                filled: true,
                fillColor: fill,
                hintStyle: GoogleFonts.inter(
                  fontSize: context.fs(13),
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 22,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 1,
                      height: 22,
                      color: Theme.of(context).dividerTheme.color?.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.mic_none_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: h * 0.22),
              ),
            ),
          ),
        ),
        SizedBox(width: context.spacing(0.025)),
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

/// VEG toggle pill (animated) shown at the bottom of the banner overlay.
class _VegToggle extends StatelessWidget {
  const _VegToggle({
    required this.isOn,
    required this.onTap,
    required this.isDark,
  });

  final bool isOn;
  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final trackW = (context.sw * 0.11).clamp(40.0, 48.0);
    final trackH = trackW * 0.52;

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
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            width: trackW,
            height: trackH,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              color: isOn
                  ? AppColors.accent
                  : (isDark
                      ? const Color(0xFF444444)
                      : const Color(0xFFDDDDDD)),
              boxShadow: isOn
                  ? [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : const [],
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              alignment: isOn ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: trackH - 4,
                height: trackH - 4,
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
