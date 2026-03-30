// Home feature controller.
//
// Manages reactive UI state for the home screen (category selection, filters,
// banner pagination) and seeds mock data for the feed sections.
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_assets.dart';
import 'home_model.dart';

// GetX controller backing the main home feed.
class HomeController extends GetxController {
  final selectedCategory = 'all'.obs;
  final isLocationOn = true.obs;
  final isLoading = true.obs;
  final isVegOnly = false.obs;
  /// Active quick-filters on the home feed (multi-select).
  final selectedFilters = <String>[].obs;

  final categories = <FoodCategory>[].obs;
  final recommended = <Restaurant>[].obs;
  final exploreItems = <ExploreItem>[].obs;

  final banners = <BannerItem>[
    const BannerItem(
      headline: 'MEALS UNDER\n₹250',
      subline: 'FINAL PRICE, BEST OFFER APPLIED',
      cta: 'Order Now →',
      gradientColors: [0xFF5B8DEF, 0xFF3A5BA0],
      foodImageUrl: AppAssets.pizza,
    ),
    const BannerItem(
      headline: 'FREE DELIVERY\nTODAY ONLY',
      subline: 'ON ORDERS ABOVE ₹199',
      cta: 'Grab Deal →',
      gradientColors: [0xFF43A047, 0xFF1B5E20],
      foodImageUrl: AppAssets.burger,
    ),
    const BannerItem(
      headline: '50% OFF\nFIRST ORDER',
      subline: 'USE CODE: FOODIE50',
      cta: 'Claim Now →',
      gradientColors: [0xFFE53935, 0xFF880E4F],
      foodImageUrl: AppAssets.biryani,
    ),
    const BannerItem(
      headline: 'BIRYANI FEST\nSTARTS TODAY',
      subline: 'OVER 50 RESTAURANTS PARTICIPATING',
      cta: 'Explore →',
      gradientColors: [0xFFFF8F00, 0xFFE65100],
      foodImageUrl: AppAssets.indianThali,
    ),
  ];

  final bannerPage = 0.obs;
  late final PageController bannerPageController;
  Timer? _bannerTimer;

  final deliveryLabelIndex = <String, int>{}.obs;
  Timer? _deliveryTimer;

  @override
  /// Initializes the banner controller, starts auto-scrolling, and seeds data.
  void onInit() {
    super.onInit();
    bannerPageController = PageController(initialPage: 0);
    _startAutoScroll();
    _loadData();
  }

  /// Periodically advances the banner carousel.
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

  /// Updates [bannerPage] when the user manually swipes between banners.
  void onBannerPageChanged(int page) => bannerPage.value = page;

  /// Cycles the "Near & Fast" label for near-fast restaurants.
  void _startDeliveryLabelCycle() {
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

  /// Returns the displayed delivery label for a restaurant card.
  String deliveryLabel(Restaurant r) {
    if (!r.isNearFast) return r.deliveryTime;
    final idx = deliveryLabelIndex[r.id] ?? 0;
    return idx == 0 ? 'Near & Fast' : r.deliveryTime;
  }

  /// Whether the current delivery label should show "Near & Fast".
  bool isNearFastLabel(Restaurant r) {
    if (!r.isNearFast) return false;
    return (deliveryLabelIndex[r.id] ?? 0) == 0;
  }

  @override
  /// Cancels timers and disposes the banner page controller.
  void onClose() {
    _bannerTimer?.cancel();
    _deliveryTimer?.cancel();
    bannerPageController.dispose();
    super.onClose();
  }

  /// Loads (mock) feed data and toggles [isLoading].
  Future<void> _loadData() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 1400));
    _seedCategories();
    _seedRestaurants();
    _seedExplore();
    isLoading.value = false;
    _startDeliveryLabelCycle();
  }

  /// Selects a single category by id.
  void selectCategory(String id) => selectedCategory.value = id;

  /// Toggles the "location on/off" UI state.
  void toggleLocation() => isLocationOn.value = !isLocationOn.value;

  /// Toggles the "VEG only" UI state.
  void toggleVeg() => isVegOnly.value = !isVegOnly.value;

  /// Toggles a quick filter chip in [selectedFilters] (multi-select).
  void toggleFilter(String label) {
    final next = List<String>.from(selectedFilters);
    if (next.contains(label)) {
      next.remove(label);
    } else {
      next.add(label);
    }
    selectedFilters.assignAll(next);
  }

  /// Checks whether a given filter chip is selected.
  bool isFilterSelected(String label) => selectedFilters.contains(label);

  @override
  /// Pull-to-refresh action (mocked).
  Future<void> refresh() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 1000));
    isLoading.value = false;
  }

  /// Seeds category list (mock).
  void _seedCategories() {
    categories.assignAll([
      const FoodCategory(
        id: 'all',
        name: 'All',
        imageUrl: AppAssets.foodSpread,
      ),
      const FoodCategory(
        id: 'pizza',
        name: 'Pizza',
        imageUrl: AppAssets.pizza,
      ),
      const FoodCategory(
        id: 'biryani',
        name: 'Biryani',
        imageUrl: AppAssets.biryani,
      ),
      const FoodCategory(
        id: 'burger',
        name: 'Burger',
        imageUrl: AppAssets.burger,
      ),
      const FoodCategory(
        id: 'sushi',
        name: 'Sushi',
        imageUrl: AppAssets.sushi,
      ),
      const FoodCategory(
        id: 'dessert',
        name: 'Dessert',
        imageUrl: AppAssets.dessert,
      ),
      const FoodCategory(
        id: 'chinese',
        name: 'Chinese',
        imageUrl: AppAssets.chinese,
      ),
    ]);
  }

  /// Seeds restaurant list (mock).
  void _seedRestaurants() {
    recommended.assignAll([
      const Restaurant(
        id: '1',
        name: "Jumboking Burgers",
        imageUrl: AppAssets.burger,
        rating: 4.1,
        deliveryTime: '20-25 mins',
        offer: '₹75 OFF above ₹149',
        isNearFast: true,
        cuisine: 'Burgers, Fast Food',
        deliveryFee: 0,
        priceLabel: '₹250 for two',
        discountPercent: 30,
      ),
      const Restaurant(
        id: '2',
        name: "Namaste Nepal",
        imageUrl: AppAssets.pizza,
        rating: 4.1,
        deliveryTime: '30-35 mins',
        offer: '₹100 OFF above ₹199',
        isNearFast: true,
        cuisine: 'Nepali, North Indian',
        deliveryFee: 20,
        priceLabel: '₹350 for two',
        discountPercent: 25,
      ),
      const Restaurant(
        id: '3',
        name: 'Veg Sutra',
        imageUrl: AppAssets.indianThali,
        rating: 4.1,
        deliveryTime: '30-35 mins',
        offer: '₹100 OFF above ₹199',
        isNearFast: false,
        cuisine: 'North Indian, Thali',
        deliveryFee: 0,
        priceLabel: '₹280 for two',
      ),
      const Restaurant(
        id: '4',
        name: "McDonald's",
        imageUrl: AppAssets.burgerPlate,
        rating: 3.9,
        deliveryTime: '30-35 mins',
        offer: '35% OFF select items',
        isNearFast: true,
        cuisine: 'Burgers, Fast Food',
        deliveryFee: 0,
        priceLabel: '₹199 for two',
        discountPercent: 35,
      ),
      const Restaurant(
        id: '5',
        name: 'Thambbi',
        imageUrl: AppAssets.southIndian,
        rating: 4.3,
        deliveryTime: '30-35 mins',
        offer: '₹125 OFF above ₹199',
        isNearFast: false,
        cuisine: 'South Indian',
        deliveryFee: 15,
        priceLabel: '₹320 for two',
      ),
      const Restaurant(
        id: '6',
        name: 'Bikkgane Biryani',
        imageUrl: AppAssets.biryani,
        rating: 4.2,
        deliveryTime: '35-40 mins',
        offer: 'Items starting at ₹99',
        isNearFast: false,
        cuisine: 'Biryani, Mughlai',
        deliveryFee: 25,
        priceLabel: '₹400 for two',
        discountPercent: 20,
      ),
    ]);
  }

  /// Seeds explore tile list (mock).
  void _seedExplore() {
    exploreItems.assignAll([
      const ExploreItem(
        id: '1',
        title: 'Gourmet',
        imageUrl: AppAssets.gourmet,
        iconType: 'gourmet',
      ),
      const ExploreItem(
        id: '2',
        title: 'Plan a Party',
        imageUrl: AppAssets.party,
        iconType: 'party',
      ),
      const ExploreItem(
        id: '3',
        title: 'Collections',
        imageUrl: AppAssets.foodSpread,
        iconType: 'collection',
      ),
      const ExploreItem(
        id: '4',
        title: 'Gift Cards',
        imageUrl: AppAssets.gift,
        iconType: 'gift',
      ),
      const ExploreItem(
        id: '5',
        title: 'Food on Train',
        imageUrl: AppAssets.train,
        iconType: 'train',
      ),
      const ExploreItem(
        id: '6',
        title: 'Offers',
        imageUrl: AppAssets.offers,
        iconType: 'offer',
      ),
    ]);
  }
}
