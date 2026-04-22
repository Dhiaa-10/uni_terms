import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthViewModel vm = Get.find<AuthViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFEFE7F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: vm.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),

                  // ─── Title ───
                  Text(
                    'welcome_back'.tr,
                    style: GoogleFonts.inter(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ─── Subtitle ───
                  Text(
                    'sign_in_subtitle'.tr,
                    style: GoogleFonts.inter(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // ─── Email Input ───
                  _buildEmailField(vm),
                  const SizedBox(height: 16),

                  // ─── Password Input ───
                  _buildPasswordField(vm),
                  const SizedBox(height: 24),

                  // ─── Forget Password ───
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: GestureDetector(
                      onTap: () => Get.toNamed('/forget_password/email'),
                      child: Text(
                        'forget_password'.tr,
                        style: GoogleFonts.inter(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // ─── Login Button ───
                  Center(child: _buildLoginButton(vm)),
                  const SizedBox(height: 32),

                  // ─── Don't have account? Create one ───
                  _buildCreateAccountRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ──────────────────────── EMAIL FIELD ────────────────────────
  Widget _buildEmailField(AuthViewModel vm) {
    return TextFormField(
      controller: vm.emailController,
      keyboardType: TextInputType.emailAddress,
      validator: vm.validateEmail,
      style: GoogleFonts.inter(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: null,
        label: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'email_address'.tr),
              TextSpan(
                text: ' *',
                style: GoogleFonts.inter(
                  color: const Color(0xFFC67C7C), // Muted red for asterisk
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          style: GoogleFonts.inter(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary.withValues(alpha: 0.5),
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, right: 12),
          child: SvgPicture.asset(
            'assets/icons/mail.svg',
            width: 24, // Increased size
            height: 24, // Increased size
            colorFilter: ColorFilter.mode(AppColors.textPrimary.withValues(alpha: 0.7), BlendMode.srcIn),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 52,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: const BorderSide(color: Color(0xFF8D64AA), width: 1.2), // Darker purple border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: const BorderSide(color: Color(0xFF3A294F), width: 2), // Even darker on focus
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: const BorderSide(color: AppColors.inputBorderError, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: const BorderSide(color: AppColors.inputBorderError, width: 2),
        ),
        filled: true,
        fillColor: Colors.transparent, // Transparent to match page background
      ),
    );
  }

  // ──────────────────────── PASSWORD FIELD ────────────────────────
  Widget _buildPasswordField(AuthViewModel vm) {
    return Obx(() => TextFormField(
          controller: vm.passwordController,
          obscureText: !vm.isPasswordVisible.value,
          validator: vm.validatePassword,
          style: GoogleFonts.inter(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: null,
            label: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'password'.tr),
                  TextSpan(
                    text: ' *',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFC67C7C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              style: GoogleFonts.inter(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary.withValues(alpha: 0.5),
              ),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 12),
              child: SvgPicture.asset(
                'assets/icons/lock.svg',
                width: 24, // Increased size
                height: 24, // Increased size
                colorFilter: ColorFilter.mode(AppColors.textPrimary.withValues(alpha: 0.7), BlendMode.srcIn),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 52,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: vm.togglePasswordVisibility,
                icon: SvgPicture.asset(
                  vm.isPasswordVisible.value ? 'assets/icons/eye_open.svg' : 'assets/icons/eye_closed.svg',
                  width: 24, // Increased size
                  height: 24, // Increased size
                  colorFilter: ColorFilter.mode(AppColors.textPrimary.withValues(alpha: 0.5), BlendMode.srcIn),
                ),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
              borderSide: const BorderSide(color: Color(0xFF8D64AA), width: 1.2), // Darker purple border
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
              borderSide: const BorderSide(color: Color(0xFF3A294F), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
              borderSide: const BorderSide(color: AppColors.inputBorderError, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
              borderSide: const BorderSide(color: AppColors.inputBorderError, width: 2),
            ),
            filled: true,
            fillColor: Colors.transparent, // Transparent to match page background
          ),
        ));
  }

  // ──────────────────────── LOGIN BUTTON ────────────────────────
  Widget _buildLoginButton(AuthViewModel vm) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryButton.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Obx(() => ElevatedButton(
            onPressed: vm.isLoading.value ? null : vm.login,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryButton,
              disabledBackgroundColor: AppColors.primaryButton.withValues(alpha: 0.7),
              foregroundColor: AppColors.primaryButtonText,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              elevation: 0, // Elevation is handled by Container decoration
            ),
            child: vm.isLoading.value
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.cardBg),
                    ),
                  )
                : Text(
                    'log_in'.tr,
                    style: GoogleFonts.inter(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryButtonText,
                    ),
                  ),
          )),
    );
  }

  // ──────────────────────── CREATE ACCOUNT ROW ────────────────────────
  Widget _buildCreateAccountRow() {
    return Align(
      alignment: AlignmentDirectional.centerStart, // Aligned to the left
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'dont_have_account'.tr,
            style: GoogleFonts.inter(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => Get.toNamed('/register'),
            child: Text(
              'create_one'.tr,
              style: GoogleFonts.inter(
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
