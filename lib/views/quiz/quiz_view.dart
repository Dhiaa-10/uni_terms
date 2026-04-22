import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/app_colors.dart';
import '../../viewmodels/quiz_viewmodel.dart';

class QuizView extends StatelessWidget {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuizViewModel());

    return Scaffold(
      backgroundColor: AppColors.screenBg,
      body: Obx(() {
        if (controller.currentView.value == QuizViewType.majors) {
          return _buildMajorsView(controller);
        } else if (controller.currentView.value == QuizViewType.levels) {
          return _buildLevelsView(controller);
        } else if (controller.currentView.value == QuizViewType.questions) {
          return _buildQuestionsView(controller);
        } else {
          return _buildResultsView(controller);
        }
      }),
    );
  }

  Widget _buildResultsView(QuizViewModel controller) {
    final score = controller.correctAnswersCount.value;
    final total = controller.quizQuestions.length;
    final percentage = (score / total * 100).toInt();
    final isPerfect = score == total;

    return Column(
      children: [
        // Result Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 60, 16, 40),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.headerGradientStart, AppColors.headerGradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: const Icon(Icons.emoji_events_outlined, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 16),
              Text(
                'final_score'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Score Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE9E0F2)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$score/$total',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF5A406D),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        controller.resultMessage,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3B2A51),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'percentage_correct'.trParams({'percent': percentage.toString()}),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                
                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: isPerfect ? () => controller.currentView.value = QuizViewType.levels : controller.retryQuiz,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A406D),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 0,
                    ),
                    child: Text(
                      isPerfect ? 'next_level'.tr : 'retry_quiz'.tr,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    onPressed: () => controller.currentView.value = QuizViewType.majors,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF5A406D)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Text(
                      'back_to_majors'.tr,
                      style: const TextStyle(color: Color(0xFF5A406D), fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionsView(QuizViewModel controller) {
    return Column(
      children: [
        // Premium Header for Questions
        Container(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.headerGradientStart, AppColors.headerGradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: controller.goBack,
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'back_to_major'.tr,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'level'.tr + ' ${controller.selectedLevel.value}'.padLeft(2, '0'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Obx(() => Text(
                        '${'question'.tr} ${controller.currentQuestionIndex.value + 1} ${'of'.tr} ${controller.quizQuestions.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      )),
                ],
              ),
              const SizedBox(height: 24),
              // Progress Bar
              Obx(() {
                double progress = (controller.currentQuestionIndex.value + 1) / controller.quizQuestions.length;
                return Container(
                  height: 6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Obx(() {
              if (controller.quizQuestions.isEmpty) return const SizedBox();
              final question = controller.quizQuestions[controller.currentQuestionIndex.value];
              
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE9E0F2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.question,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B2A51),
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...List.generate(question.options.length, (index) {
                      return _buildOptionCard(
                        text: question.options[index],
                        index: index,
                        controller: controller,
                        correctIndex: question.correctAnswerIndex,
                      );
                    }),
                  ],
                ),
              );
            }),
          ),
        ),

        // Action Buttons
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 55,
                child: Obx(() => ElevatedButton(
                      onPressed: controller.isAnswered.value ? controller.nextQuestion : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5A406D),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 0,
                      ),
                      child: Text(
                        'next'.tr,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    )),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: Obx(() => OutlinedButton(
                      onPressed: controller.currentQuestionIndex.value > 0 ? controller.previousQuestion : null,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF5A406D)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text(
                        'back'.tr,
                        style: const TextStyle(color: Color(0xFF5A406D), fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required String text,
    required int index,
    required QuizViewModel controller,
    required int correctIndex,
  }) {
    return Obx(() {
      bool isSelected = controller.selectedOptionIndex.value == index;
      bool isCorrect = index == correctIndex;
      bool isAnswered = controller.isAnswered.value;

      Color borderColor = const Color(0xFFE5E7EB);
      Color bgColor = Colors.white;
      Widget icon = Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF5A406D), width: 2),
        ),
      );

      if (isAnswered) {
        if (isCorrect) {
          borderColor = const Color(0xFF22C55E);
          bgColor = const Color(0xFFF0FDF4);
          icon = const Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 24);
        } else if (isSelected) {
          borderColor = const Color(0xFFEF4444);
          bgColor = const Color(0xFFFEF2F2);
          icon = const Icon(Icons.cancel, color: Color(0xFFEF4444), size: 24);
        }
      }

      return GestureDetector(
        onTap: () => controller.selectOption(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Row(
            children: [
              icon,
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isAnswered && isCorrect 
                        ? const Color(0xFF166534) 
                        : isAnswered && isSelected && !isCorrect 
                            ? const Color(0xFF991B1B) 
                            : const Color(0xFF3B2A51),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMajorsView(QuizViewModel controller) {
    return Column(
      children: [
        // Premium Header with Search Integrated
        Container(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.headerGradientStart, AppColors.headerGradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              Text(
                'quizzes'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: controller.goBack,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: controller.searchController,
                        onChanged: controller.updateSearchQuery,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'search_majors_placeholder'.tr,
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
                          prefixIcon: const Icon(Icons.search_rounded, color: Colors.white, size: 20),
                          suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                              ? IconButton(
                                  icon: SvgPicture.asset(
                                    'assets/icons/curved_close_circle.svg',
                                    width: 22,
                                    height: 22,
                                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                  ),
                                  onPressed: controller.clearSearch,
                                )
                              : const SizedBox()),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Content Area with White Card
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE9E0F2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'select_major'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B2A51),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Obx(() => ListView.builder(
                        itemCount: controller.filteredMajors.length,
                        itemBuilder: (context, index) {
                          final major = controller.filteredMajors[index];
                          return _buildMajorCard(major, () => controller.selectMajor(major));
                        },
                      )),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMajorCard(Map<String, dynamic> major, VoidCallback onTap) {
    final isAr = Get.locale?.languageCode == 'ar';
    final title = isAr ? major['arabicTitle'] : major['title'];
    final count = major['count'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF5A406D), // Dark purple background
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(major['icon'], color: Colors.white, size: 24), // White icon
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B2A51),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'terms_available'.trParams({'count': count.toString()}),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              SvgPicture.asset(
                'assets/icons/play.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(Color(0xFF5A406D), BlendMode.srcIn),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelsView(QuizViewModel controller) {
    return Column(
      children: [
        // Premium Header (Matches Majors View)
        Container(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.headerGradientStart, AppColors.headerGradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              Text(
                'levels'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: controller.goBack,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Content Area with White Card
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE9E0F2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'select_level'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B2A51),
                      ),
                    ),
                    // Crown Icon and Score
                    Obx(() => Column(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/crown-2.svg',
                          height: 28,
                          width: 28,
                          colorFilter: const ColorFilter.mode(Colors.green, BlendMode.srcIn),
                        ),
                        Text(
                          '${controller.totalTrophies.value}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.3,
                    ),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      final isLocked = controller.isLevelLocked(index);
                      return _buildLevelCard(index + 1, isLocked, () {
                        if (isLocked) {
                          _showLockedDialog();
                        } else {
                          controller.startQuiz(index);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLevelCard(int level, bool isLocked, VoidCallback onTap) {
    // Gradients based on Figma design
    final unlockedGradient = const LinearGradient(
      colors: [Color(0xFFFFFFFF), Color(0xFFF5F0FF)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final lockedGradient = const LinearGradient(
      colors: [Color(0xFF7C59A4), Color(0xFF412960)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final Color textColor = isLocked ? Colors.white : const Color(0xFF3B2A51);
    final IconData icon = isLocked ? Icons.lock_outline : Icons.lock_open_outlined;
    final String levelText = '${'level'.tr} ${level.toString().padLeft(2, '0')}';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          gradient: isLocked ? lockedGradient : unlockedGradient,
          borderRadius: BorderRadius.circular(20),
          border: isLocked ? null : Border.all(color: const Color(0xFFE9E0F2), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: isLocked 
                ? const Color(0xFF3B2A51).withOpacity(0.3) 
                : const Color(0xFF7C3AED).withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              isLocked ? 'assets/icons/lock-on.svg' : 'assets/icons/lock-off.svg',
              height: 34,
              width: 34,
              colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
            ),
            const SizedBox(height: 10),
            Text(
              levelText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLockedDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with Icon and Text
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/icons/lock-on.svg',
                    height: 40,
                    width: 40,
                    colorFilter: const ColorFilter.mode(Color(0xFF3B2A51), BlendMode.srcIn),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'level_locked'.tr.toLowerCase(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3B2A51),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'complete_previous'.tr,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              const SizedBox(height: 24),

              // OK Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A406D),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
                  ),
                  child: Text(
                    'ok'.tr.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Cancel Button
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'cancel'.tr,
                  style: const TextStyle(
                    color: Color(0xFF5A406D),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
