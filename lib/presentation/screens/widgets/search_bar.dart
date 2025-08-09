import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/colors.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const CustomSearchBar({super.key, required this.controller, this.hintText = 'Search', this.onChanged, this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: AppColors.brown600.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.brown300),
          prefixIcon: const Icon(Icons.search, color: AppColors.brown500),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close, color: AppColors.brown500),
            onPressed: () {
              controller.clear();
              if (onClear != null) onClear!();
            },
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
