import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBg,
      appBar: AppBar(title: const Text('Create Account'), backgroundColor: Colors.transparent, elevation: 0),
      body: Center(child: Text('Register screen coming soon', style: TextStyle(color: Colors.grey))),
    );
  }
}
