import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_model.dart';

class HomeController extends GetxController {
  final selectedCategory = 'all'.obs;
  final isLocationOn = true.obs;
  final isLoading = true.obs;
  final isVegOnly = false.obs;
  final selectedFilter = ''.obs;

  final categories = <FoodCategory>[].obs;
  final recommended = <Restaurant>[].obs;
  final exploreItems = <ExploreItem>[].obs;

  // ── Banner carousel ───────────────────────────────────────────────────────
  final banners = <BannerItem>[
    const BannerItem(
      headline: 'MEALS UNDER\n₹250',
      subline: 'FINAL PRICE, BEST OFFER APPLIED',
      cta: 'Order Now →',
      gradientColors: [0xFF5B8DEF, 0xFF3A5BA0],
      foodImageUrl:
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&q=80',
    ),
    const BannerItem(
      headline: 'FREE DELIVERY\nTODAY ONLY',
      subline: 'ON ORDERS ABOVE ₹199',
      cta: 'Grab Deal →',
      gradientColors: [0xFF43A047, 0xFF1B5E20],
      foodImageUrl:
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&q=80',
    ),
    const BannerItem(
      headline: '50% OFF\nFIRST ORDER',
      subline: 'USE CODE: FOODIE50',
      cta: 'Claim Now →',
      gradientColors: [0xFFE53935, 0xFF880E4F],
      foodImageUrl:
          'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=400&q=80',
    ),
    const BannerItem(
      headline: 'BIRYANI FEST\nSTARTS TODAY',
      subline: 'OVER 50 RESTAURANTS PARTICIPATING',
      cta: 'Explore →',
      gradientColors: [0xFFFF8F00, 0xFFE65100],
      foodImageUrl:
          'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=400&q=80',
    ),
  ];

  final bannerPage = 0.obs;
  late final PageController bannerPageController;
  Timer? _bannerTimer;

  @override
  void onInit() {
    super.onInit();
    bannerPageController = PageController(initialPage: 0);
    _startAutoScroll();
    _loadData();
  }

  void _startAutoScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!bannerPageController.hasClients) return;
      final next = (bannerPage.value + 1) % banners.length;
      bannerPageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void onBannerPageChanged(int page) => bannerPage.value = page;

  // ── Dynamic delivery label per restaurant ─────────────────────────────────
  // Maps restaurant id → current display label index (0 = nearFast, 1 = time)
  final deliveryLabelIndex = <String, int>{}.obs;
  Timer? _deliveryTimer;

  void _startDeliveryLabelCycle() {
    // Initialise all nearFast restaurants at index 0
    for (final r in recommended) {
      if (r.isNearFast) deliveryLabelIndex[r.id] = 0;
    }
    _deliveryTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      for (final r in recommended) {
        if (!r.isNearFast) continue;
        final current = deliveryLabelIndex[r.id] ?? 0;
        deliveryLabelIndex[r.id] = current == 0 ? 1 : 0;
      }
    });
  }

  /// Returns the label to show for a restaurant's delivery row.
  /// nearFast restaurants alternate between "Near & Fast" and their time.
  String deliveryLabel(Restaurant r) {
    if (!r.isNearFast) return r.deliveryTime;
    final idx = deliveryLabelIndex[r.id] ?? 0;
    return idx == 0 ? 'Near & Fast' : r.deliveryTime;
  }

  bool isNearFastLabel(Restaurant r) {
    if (!r.isNearFast) return false;
    return (deliveryLabelIndex[r.id] ?? 0) == 0;
  }

  @override
  void onClose() {
    _bannerTimer?.cancel();
    _deliveryTimer?.cancel();
    bannerPageController.dispose();
    super.onClose();
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 1400));
    _seedCategories();
    _seedRestaurants();
    _seedExplore();
    isLoading.value = false;
    _startDeliveryLabelCycle();
  }

  void selectCategory(String id) => selectedCategory.value = id;
  void toggleLocation() => isLocationOn.value = !isLocationOn.value;
  void toggleVeg() => isVegOnly.value = !isVegOnly.value;
  void selectFilter(String f) =>
      selectedFilter.value = selectedFilter.value == f ? '' : f;

  @override
  Future<void> refresh() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 1000));
    isLoading.value = false;
  }

  void _seedCategories() {
    categories.assignAll([
      const FoodCategory(
        id: 'all',
        name: 'All',
        imageUrl:
            'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=200&q=80',
      ),
      const FoodCategory(
        id: 'pizza',
        name: 'Pizza',
        imageUrl:
            'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=200&q=80',
      ),
      const FoodCategory(
        id: 'biryani',
        name: 'Biryani',
        imageUrl:
            'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=200&q=80',
      ),
      const FoodCategory(
        id: 'burger',
        name: 'Burger',
        imageUrl:
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=200&q=80',
      ),
      const FoodCategory(
        id: 'sushi',
        name: 'Sushi',
        imageUrl:
            'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=200&q=80',
      ),
      const FoodCategory(
        id: 'dessert',
        name: 'Dessert',
        imageUrl:
            'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=200&q=80',
      ),
      const FoodCategory(
        id: 'chinese',
        name: 'Chinese',
        imageUrl:
            'https://images.unsplash.com/photo-1563245372-f21724e3856d?w=200&q=80',
      ),
    ]);
  }

  void _seedRestaurants() {
    recommended.assignAll([
      const Restaurant(
        id: '1',
        name: "Jumboking Burgers",
        imageUrl:
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&q=80',
        rating: 4.1,
        deliveryTime: '20-25 mins',
        offer: '₹75 OFF above ₹149',
        isNearFast: true,
        cuisine: 'Burgers, Fast Food',
        deliveryFee: 0,
      ),
      const Restaurant(
        id: '2',
        name: "Namaste Nepal",
        imageUrl:
            'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=600&q=80',
        rating: 4.1,
        deliveryTime: '30-35 mins',
        offer: '₹100 OFF above ₹199',
        isNearFast: true,
        cuisine: 'Nepali, North Indian',
        deliveryFee: 20,
      ),
      const Restaurant(
        id: '3',
        name: 'Veg Sutra',
        imageUrl:
            'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=600&q=80',
        rating: 4.1,
        deliveryTime: '30-35 mins',
        offer: '₹100 OFF above ₹199',
        isNearFast: false,
        cuisine: 'North Indian, Thali',
        deliveryFee: 0,
      ),
      const Restaurant(
        id: '4',
        name: "McDonald's",
        imageUrl:
            'https://images.unsplash.com/photo-1550547660-d9450f859349?w=600&q=80',
        rating: 3.9,
        deliveryTime: '30-35 mins',
        offer: '35% OFF select items',
        isNearFast: true,
        cuisine: 'Burgers, Fast Food',
        deliveryFee: 0,
      ),
      const Restaurant(
        id: '5',
        name: 'Thambbi',
        imageUrl:
            'https://images.unsplash.com/photo-1589301760014-d929f3979dbc?w=600&q=80',
        rating: 4.3,
        deliveryTime: '30-35 mins',
        offer: '₹125 OFF above ₹199',
        isNearFast: false,
        cuisine: 'South Indian',
        deliveryFee: 15,
      ),
      const Restaurant(
        id: '6',
        name: 'Bikkgane Biryani',
        imageUrl:
            'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600&q=80',
        rating: 4.2,
        deliveryTime: '35-40 mins',
        offer: 'Items starting at ₹99',
        isNearFast: false,
        cuisine: 'Biryani, Mughlai',
        deliveryFee: 25,
      ),
    ]);
  }

  void _seedExplore() {
    exploreItems.assignAll([
      const ExploreItem(
        id: '1',
        title: 'Gourmet',
        imageUrl:
            'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?w=400&q=80',
        iconType: 'gourmet',
      ),
      const ExploreItem(
        id: '2',
        title: 'Plan a Party',
        imageUrl:
            'https://images.unsplash.com/photo-1530103862676-de8c9debad1d?w=400&q=80',
        iconType: 'party',
      ),
      const ExploreItem(
        id: '3',
        title: 'Collections',
        imageUrl:
            'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400&q=80',
        iconType: 'collection',
      ),
      const ExploreItem(
        id: '4',
        title: 'Gift Cards',
        imageUrl:
            'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=400&q=80',
        iconType: 'gift',
      ),
      const ExploreItem(
        id: '5',
        title: 'Food on Train',
        imageUrl:
            'https://images.unsplash.com/photo-1474487548417-781cb71495f3?w=400&q=80',
        iconType: 'train',
      ),
      const ExploreItem(
        id: '6',
        title: 'Offers',
        imageUrl:
            'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=400&q=80',
        iconType: 'offer',
      ),
    ]);
  }
}
