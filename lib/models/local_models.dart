import 'package:flutter/material.dart';

class BoardModel {
  final String? title;
  final String? description;
  final String? image;

  BoardModel(
      this.title,
      this.image,
      this.description,
      );
}

class MoreFeature {
  final String title;
  final IconData icon;
  final Function()? function;
  final Widget? trailing;

  MoreFeature({
    required this.title,
    required this.icon,
    this.function,
    this.trailing,
  });
}
