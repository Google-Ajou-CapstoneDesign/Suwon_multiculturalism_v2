import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// MVP 범위 밖 18개 카테고리용 스켈레톤 화면. "준비 중" 안내만 노출.
class CategoryPlaceholderScreen extends StatelessWidget {
  const CategoryPlaceholderScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.hourglass_empty, size: 40, color: AppColors.textMuted),
            SizedBox(height: 12),
            Text('콘텐츠 준비 중입니다', style: TextStyle(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
