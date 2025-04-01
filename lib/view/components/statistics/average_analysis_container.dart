import 'package:flutter/material.dart';
import '../../utilities/app_color.dart';

class AverageAnalysisContainer extends StatelessWidget {
  const AverageAnalysisContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // SIN WITH PARA QUE EXPANDA
      height: 200,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.lightVioletColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(2, 4),
          ),
        ],
      ),
    );
  }
}