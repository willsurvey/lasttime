import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/activity_model.dart';

class ActivityCard extends StatelessWidget {
  final ActivityModel activity;

  const ActivityCard({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Circle
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: activity.iconColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              activity.icon,
              color: AppColors.textPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terakhir: ${activity.lastDate}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.daysAgo,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Status Button
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              activity.status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}