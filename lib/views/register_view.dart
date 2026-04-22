import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../viewmodels/register_viewmodel.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterViewModel vm = Get.find<RegisterViewModel>();

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
                  const SizedBox(height: 60), // Top spacing

                  // ──────────────────────── HEADER ────────────────────────
                  _buildHeader(),

                  const SizedBox(height: 40),

                  // ──────────────────────── FIRST & LAST NAME ────────────────────────
                  Row(
                    children: [
                      Expanded(child: _buildFirstNameField(vm)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildLastNameField(vm)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ──────────────────────── EMAIL FIELD ────────────────────────
                  _buildEmailField(vm),
                  const SizedBox(height: 16),

                  // ──────────────────────── PASSWORD FIELD ────────────────────────
                  _buildPasswordField(vm),
                  const SizedBox(height: 32),

                  // ──────────────────────── CREATE ACCOUNT BUTTON ────────────────────────
                  _buildRegisterButton(vm),
                  const SizedBox(height: 32),

                  // ──────────────────────── ALREADY HAVE ACCOUNT ROW ────────────────────────
                  _buildLoginRow(),
                  const SizedBox(height: 40), // Bottom spacing
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ──────────────────────── HEADER ────────────────────────
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'join_with_us'.tr,
          style: GoogleFonts.inter(
            fontSize: 28.0,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'create_account_subtitle'.tr,
          style: GoogleFonts.inter(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  // ──────────────────────── INPUT DECORATION HELPER ────────────────────────
  InputDecoration _buildInputDecoration({
    required String labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: null,
      label: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: labelText),
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
      prefixIcon: prefixIcon,
      prefixIconConstraints: prefixIcon != null ? const BoxConstraints(minWidth: 52) : null,
      suffixIcon: suffixIcon,
      contentPadding: prefixIcon == null 
          ? const EdgeInsets.symmetric(horizontal: 20, vertical: 20) 
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
    );
  }

  // ──────────────────────── FIRST NAME FIELD ────────────────────────
  Widget _buildFirstNameField(RegisterViewModel vm) {
    return TextFormField(
      controller: vm.firstNameController,
      keyboardType: TextInputType.name,
      validator: vm.validateName,
      style: GoogleFonts.inter(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      decoration: _buildInputDecoration(labelText: 'first_name'.tr),
    );
  }

  // ──────────────────────── LAST NAME FIELD ────────────────────────
  Widget _buildLastNameField(RegisterViewModel vm) {
    return TextFormField(
      controller: vm.lastNameController,
      keyboardType: TextInputType.name,
      validator: vm.validateName,
      style: GoogleFonts.inter(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      decoration: _buildInputDecoration(labelText: 'last_name'.tr),
    );
  }

  // ──────────────────────── EMAIL FIELD ────────────────────────
  Widget _buildEmailField(RegisterViewModel vm) {
    return TextFormField(
      controller: vm.emailController,
      keyboardType: TextInputType.emailAddress,
      validator: vm.validateEmail,
      style: GoogleFonts.inter(
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      decoration: _buildInputDecoration(
        labelText: 'email_address'.tr,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, right: 12),
          child: SvgPicture.asset(
            'assets/icons/mail.svg',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(AppColors.textPrimary.withValues(alpha: 0.7), BlendMode.srcIn),
          ),
        ),
      ),
    );
  }

  // ──────────────────────── PASSWORD FIELD ────────────────────────
  Widget _buildPasswordField(RegisterViewModel vm) {
    return Obx(() => TextFormField(
          controller: vm.passwordController,
          obscureText: !vm.isPasswordVisible.value,
          validator: vm.validatePassword,
          style: GoogleFonts.inter(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          decoration: _buildInputDecoration(
            labelText: 'password'.tr,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 12),
              child: SvgPicture.asset(
                'assets/icons/lock.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(AppColors.textPrimary.withValues(alpha: 0.7), BlendMode.srcIn),
              ),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: vm.togglePasswordVisibility,
                icon: SvgPicture.asset(
                  vm.isPasswordVisible.value ? 'assets/icons/eye_open.svg' : 'assets/icons/eye_closed.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(AppColors.textPrimary.withValues(alpha: 0.5), BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ));
  }

  // ──────────────────────── REGISTER BUTTON ────────────────────────
  Widget _buildRegisterButton(RegisterViewModel vm) {
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
            onPressed: vm.isLoading.value ? null : vm.register,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryButton,
              disabledBackgroundColor: AppColors.primaryButton.withValues(alpha: 0.7),
              foregroundColor: AppColors.primaryButtonText,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              elevation: 0,
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
                    'create_account'.tr,
                    style: GoogleFonts.inter(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryButtonText,
                    ),
                  ),
          )),
    );
  }

  // ──────────────────────── LOGIN ROW ────────────────────────
  Widget _buildLoginRow() {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'already_have_account'.tr,
            style: GoogleFonts.inter(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => Get.back(), // Assuming user came from sign-in
            child: Text(
              'log_in'.tr,
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
