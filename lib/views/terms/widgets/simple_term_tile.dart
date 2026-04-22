import 'package:flutter/material.dart';
import '../../../../models/term_model.dart';
import '../../../../core/app_colors.dart';

class SimpleTermTile extends StatelessWidget {
  final int index;
  final TermModel term;
  final VoidCallback onTap;

  const SimpleTermTile({
    super.key,
    required this.index,
    required this.term,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.sectionBorder, width: 1),
        ),
        child: Row(
          children: [
            // Index Number
            SizedBox(
              width: 36,
              child: Text(
                index.toString().padLeft(2, '0'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  fontFamily: 'Inter',
                ),
              ),
            ),
            // Term Title
            Expanded(
              child: Text(
                term.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontFamily: 'Inter',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
