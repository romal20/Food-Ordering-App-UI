import 'package:flutter/material.dart';

/// Responsive helpers using MediaQuery.sizeOf(context).
/// Breakpoints use context.sw directly to avoid conflicts with GetX extensions.
extension ScreenExt on BuildContext {
  // ── Dimensions ────────────────────────────────────────────────────────────
  double get sw => MediaQuery.sizeOf(this).width;
  double get sh => MediaQuery.sizeOf(this).height;

  // ── Horizontal padding ────────────────────────────────────────────────────
  double get hPad {
    if (sw >= 1024) return sw * 0.15;
    if (sw >= 600) return sw * 0.06;
    return 16.0;
  }

  // ── Font size ─────────────────────────────────────────────────────────────
  double fs(double base) {
    if (sw >= 1024) return base * 1.25;
    if (sw >= 600) return base * 1.15;
    return base;
  }

  // ── Food card width (horizontal list) ────────────────────────────────────
  double get foodCardWidth {
    if (sw >= 1024) return (sw - hPad * 2 - 32) / 4;
    if (sw >= 600) return (sw - hPad * 2 - 24) / 3;
    return sw * 0.52;
  }

  // ── Explore grid columns ──────────────────────────────────────────────────
  int get gridCols {
    if (sw >= 1024) return 4;
    if (sw >= 600) return 3;
    return 2;
  }

  // ── Recommended list height ───────────────────────────────────────────────
  double get recommendedHeight => sw >= 600 ? 270.0 : 230.0;

  // ── Login card max-width ──────────────────────────────────────────────────
  double get cardMaxWidth => sw >= 600 ? 520.0 : double.infinity;

  // ── Logo size ─────────────────────────────────────────────────────────────
  double get logoSize => sw >= 600 ? 130.0 : 110.0;
}
