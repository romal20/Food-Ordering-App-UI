import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';

enum LoginType { email, google, apple, guest }

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;
  final activeLoginType = Rxn<LoginType>();

  bool get _isBusy => isLoading.value;

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email or phone is required';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Minimum 6 characters';
    return null;
  }

  Future<void> login() async {
    if (_isBusy) return;
    if (!formKey.currentState!.validate()) return;
    _startLoading(LoginType.email);
    await Future.delayed(const Duration(milliseconds: 1200));
    _stopLoading();
    Get.offAllNamed(AppRoutes.home);
  }

  Future<void> loginWithGoogle() async {
    if (_isBusy) return;
    _startLoading(LoginType.google);
    await Future.delayed(const Duration(milliseconds: 900));
    _stopLoading();
    Get.offAllNamed(AppRoutes.home);
  }

  Future<void> loginWithApple() async {
    if (_isBusy) return;
    _startLoading(LoginType.apple);
    await Future.delayed(const Duration(milliseconds: 900));
    _stopLoading();
    Get.offAllNamed(AppRoutes.home);
  }

  Future<void> loginAsGuest() async {
    if (_isBusy) return;
    _startLoading(LoginType.guest);
    await Future.delayed(const Duration(milliseconds: 600));
    _stopLoading();
    Get.offAllNamed(AppRoutes.home);
  }

  void forgotPassword() {
    Get.snackbar(
      'Reset Password',
      'A reset link has been sent to your email.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  void signUp() {
    Get.snackbar(
      'Sign Up',
      'Sign up flow coming soon.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void _startLoading(LoginType type) {
    activeLoginType.value = type;
    isLoading.value = true;
  }

  void _stopLoading() {
    isLoading.value = false;
    activeLoginType.value = null;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
