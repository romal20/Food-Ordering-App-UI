// Login feature controller.
//
// Owns form state, input validation, provider sign-in actions (Google/Apple),
// and navigation to the home screen on success.
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/platform_checks.dart';

// Distinguishes which login button/action is currently active.
enum LoginType { email, google, apple, guest }

// GetX controller for the login screen.
class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;
  final activeLoginType = Rxn<LoginType>();

  bool get _isBusy => isLoading.value;

  /// Toggles password visibility.
  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  /// Validates the email/phone field.
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email or phone is required';
    }
    return null;
  }

  /// Validates the password field.
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Minimum 6 characters';
    return null;
  }

  /// Handles the "Login" button using the existing mocked flow.
  Future<void> login() async {
    if (_isBusy) return;
    if (!formKey.currentState!.validate()) return;
    _startLoading(LoginType.email);
    await Future.delayed(const Duration(milliseconds: 1200));
    _stopLoading();
    Get.offAllNamed(AppRoutes.home);
  }

  /// Starts Google Sign-In and navigates to the home screen on success.
  ///
  /// Notes:
  /// - This project navigates on success only (no backend session is created).
  /// - Shows a snackbar for cancellation and configuration errors.
  Future<void> loginWithGoogle() async {
    if (_isBusy) return;
    _startLoading(LoginType.google);
    try {
      if (kIsWeb) {
        Get.snackbar(
          'Google Sign-In',
          'Google sign-in not supported on web in this app',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          mainButton: TextButton(
            onPressed: () {
              if (!isLoading.value && !isClosed) loginWithGoogle();
            },
            child: const Text(
              'Retry',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        return;
      }

      await GoogleSignIn.instance.authenticate();
      // A real backend session isn't set up in this app; we only navigate on success.
      Get.offAllNamed(AppRoutes.home);
    } on GoogleSignInException catch (e, st) {
      debugPrint('GoogleSignInException: $e\n$st');
      final isCanceled = e.code == GoogleSignInExceptionCode.canceled;
      if (isCanceled) {
        Get.snackbar(
          'Google Sign-In',
          'Sign-in cancelled.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        return;
      }

      Get.snackbar(
        'Google Sign-In failed',
        'Google sign-in failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        mainButton: TextButton(
          onPressed: () {
            if (!isLoading.value && !isClosed) loginWithGoogle();
          },
          child: const Text(
            'Retry',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } on UnimplementedError catch (e, st) {
      debugPrint('Google sign-in UnimplementedError: $e\n$st');
      Get.snackbar(
        'Google Sign-In',
        'Sign-in not supported on this device.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e, st) {
      debugPrint('Google sign-in error: $e\n$st');
      Get.snackbar(
        'Google Sign-In failed',
        'Google sign-in failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        mainButton: TextButton(
          onPressed: () {
            if (!isLoading.value && !isClosed) loginWithGoogle();
          },
          child: const Text(
            'Retry',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } finally {
      if (!isClosed) {
        _stopLoading();
      }
    }
  }

  /// Starts Sign in with Apple on iOS only and navigates to home on success.
  ///
  /// On non-iOS platforms the button is still wired, but the action is guarded
  /// and a snackbar is shown instead.
  Future<void> loginWithApple() async {
    if (_isBusy) return;
    _startLoading(LoginType.apple);
    try {
      if (!isIOS) {
        Get.snackbar(
          'Apple Sign-In',
          'Apple Sign-In is not supported on this device',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        return;
      }

      await SignInWithApple.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // A real backend session isn't set up in this app; we only navigate on success.
      Get.offAllNamed(AppRoutes.home);
    } on SignInWithAppleAuthorizationException catch (e, st) {
      debugPrint('Apple sign-in error: $e\n$st');
      final isCanceled = e.code == AuthorizationErrorCode.canceled;
      if (isCanceled) {
        Get.snackbar(
          'Apple Sign-In',
          'Sign-in cancelled.',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        return;
      }

      Get.snackbar(
        'Apple Sign-In failed',
        'Apple sign-in failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        mainButton: TextButton(
          onPressed: () {
            if (!isLoading.value && !isClosed) loginWithApple();
          },
          child: const Text(
            'Retry',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } catch (e) {
      debugPrint('Apple sign-in error: $e');
      Get.snackbar(
        'Apple Sign-In failed',
        'Apple sign-in failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        mainButton: TextButton(
          onPressed: () {
            if (!isLoading.value && !isClosed) loginWithApple();
          },
          child: const Text(
            'Retry',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } finally {
      if (!isClosed) {
        _stopLoading();
      }
    }
  }

  /// Continues as a guest (mocked) and navigates to home.
  Future<void> loginAsGuest() async {
    if (_isBusy) return;
    _startLoading(LoginType.guest);
    await Future.delayed(const Duration(milliseconds: 600));
    _stopLoading();
    Get.offAllNamed(AppRoutes.home);
  }

  /// Shows a snackbar for the mocked "Forgot password" flow.
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

  /// Shows a snackbar for the placeholder "Sign Up" action.
  void signUp() {
    Get.snackbar(
      'Sign Up',
      'Sign up flow coming soon.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  /// Marks the UI as busy and indicates which login action is active.
  void _startLoading(LoginType type) {
    activeLoginType.value = type;
    isLoading.value = true;
  }

  /// Clears loading state and active login action.
  void _stopLoading() {
    isLoading.value = false;
    activeLoginType.value = null;
  }

  @override
  void onClose() {
    // Dispose of controllers to avoid leaks when GetX removes this controller.
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
