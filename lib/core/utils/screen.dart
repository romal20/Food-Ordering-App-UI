import 'package:flutter/material.dart';

/// Responsive helpers using [MediaQuery.sizeOf].
extension ScreenExt on BuildContext {
  double get sw => MediaQuery.sizeOf(this).width;
  double get sh => MediaQuery.sizeOf(this).height;

  double get hPad {
    if (sw >= 1024) return sw * 0.15;
    if (sw >= 600) return sw * 0.06;
    return 16.0;
  }

  double fs(double base) {
    if (sw >= 1024) return base * 1.25;
    if (sw >= 600) return base * 1.15;
    return base;
  }

  /// Responsive horizontal gap between major sections.
  double get sectionGap {
    if (sw >= 1024) return 24;
    if (sw >= 600) return 20;
    return 16;
  }

  /// Standard vertical spacing scale (fraction of logical height, clamped).
  double spacing(double t) => (sh * t).clamp(8.0, 48.0);

  double get foodCardWidth {
    if (sw >= 1024) return (sw - hPad * 2 - 32) / 4;
    if (sw >= 600) return (sw - hPad * 2 - 24) / 3;
    return sw * 0.52;
  }

  double foodCardImageHeight(double cardWidth) =>
      (cardWidth * 0.62).clamp(100.0, 160.0);

  int get gridCols {
    if (sw >= 1024) return 4;
    if (sw >= 600) return 3;
    return 2;
  }

  /// Vertical space for the horizontal "Recommended" list. Must fit [FoodCard]
  /// image + text block (padding, title, cuisine, optional price, delivery row).
  double get recommendedHeight {
    final img = foodCardImageHeight(foodCardWidth);
    final textScale = MediaQuery.textScalerOf(this).clamp(maxScaleFactor: 1.8).scale(1.0);
    // ~108px info at scale 1.0; scales with accessibility text size
    final infoReserve = (116 * textScale).clamp(108.0, 160.0);
    return (img + infoReserve).clamp(236.0, 400.0);
  }

  double get cardMaxWidth => sw >= 600 ? 520.0 : double.infinity;

  double get logoSize => sw >= 600 ? 130.0 : 110.0;

  double get bannerHeight {
    final base = sw >= 600 ? 0.36 : 0.32;
    return (sh * base).clamp(220.0, 340.0);
  }

  double get searchBarHeight {
    if (sw >= 600) return 54;
    return 50;
  }

  double get categoryRowHeight {
    final avatar = (sw * 0.14).clamp(56.0, 72.0);
    return avatar + 36;
  }

  double get categoryAvatarSize => (sw * 0.14).clamp(52.0, 64.0);

  double get exploreTileWidth => (sw * 0.38).clamp(132.0, 168.0);

  double get exploreTileHeight => (exploreTileWidth * 0.74).clamp(100.0, 124.0);

  BorderRadius get radiusSheet {
    final r = (sw * 0.08).clamp(24.0, 36.0);
    return BorderRadius.vertical(top: Radius.circular(r));
  }
}
