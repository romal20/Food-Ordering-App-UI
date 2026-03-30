// Category item widget used in the home categories carousel.
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/screen.dart';
import '../home_model.dart';

/// Single selectable category avatar + label.
class CategoryItem extends StatefulWidget {
  const CategoryItem({
    super.key,
    required this.category,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final FoodCategory category;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

/// State backing the animated scale effect when tapping the category.
class _CategoryItemState extends State<CategoryItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.9,
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
    final avatar = context.categoryAvatarSize;
    final columnW = (avatar + 14).clamp(72.0, 88.0);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _ctrl.reverse(),
      onTapCancel: () => _ctrl.forward(),
      onTap: () {
        _ctrl.forward();
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) =>
            Transform.scale(scale: _ctrl.value, child: child),
        child: SizedBox(
          width: columnW,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                width: avatar,
                height: avatar,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.isSelected
                        ? AppColors.primary
                        : Colors.transparent,
                    width: 2.5,
                  ),
                  boxShadow: widget.isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.32),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: widget.isDark ? 0.22 : 0.08,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    widget.category.imageUrl,
                    fit: BoxFit.cover,
                    width: avatar,
                    height: avatar,
                    gaplessPlayback: true,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: widget.isDark
                          ? AppColors.cardDark
                          : const Color(0xFFEEEEEE),
                      child: Icon(
                        Icons.restaurant_rounded,
                        color: AppColors.primary,
                        size: avatar * 0.4,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: context.spacing(0.008)),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: GoogleFonts.poppins(
                  fontSize: context.fs(11),
                  fontWeight: widget.isSelected
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: widget.isSelected
                      ? AppColors.primary
                      : (widget.isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight),
                ),
                child: Text(
                  widget.category.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.only(top: 4),
                width: widget.isSelected ? 20 : 0,
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
