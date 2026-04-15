import 'package:flutter/material.dart';

class ActivityModel {
  final String title;
  final String lastDate;
  final String daysAgo;
  final Color iconColor;
  final IconData icon;
  final String status;

  ActivityModel({
    required this.title,
    required this.lastDate,
    required this.daysAgo,
    required this.iconColor,
    required this.icon,
    required this.status,
  });
}