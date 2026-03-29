// Data models for the Home screen

class FoodCategory {
  final String id;
  final String name;
  final String imageUrl;

  const FoodCategory({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

class Restaurant {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String deliveryTime;
  final String offer;
  final bool isNearFast;
  final String cuisine;
  final int deliveryFee;

  const Restaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.deliveryTime,
    required this.offer,
    required this.isNearFast,
    required this.cuisine,
    this.deliveryFee = 0,
  });
}

class ExploreItem {
  final String id;
  final String title;
  final String imageUrl;
  final String iconType;

  const ExploreItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.iconType,
  });
}

class BannerItem {
  final String headline;
  final String subline;
  final String cta;
  final List<int> gradientColors; // two ARGB ints
  final String foodImageUrl;

  const BannerItem({
    required this.headline,
    required this.subline,
    required this.cta,
    required this.gradientColors,
    required this.foodImageUrl,
  });
}
