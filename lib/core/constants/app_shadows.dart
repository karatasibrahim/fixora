import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppShadows {
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: AppColors.shadowColor,
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> md = [
    BoxShadow(
      color: AppColors.shadowColor,
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: AppColors.shadowColor,
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> lg = [
    BoxShadow(
      color: AppColors.shadowColorMedium,
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: AppColors.shadowColor,
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0A0F172A),
      blurRadius: 12,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x060F172A),
      blurRadius: 4,
      offset: Offset(0, 1),
      spreadRadius: 0,
    ),
  ];
}
