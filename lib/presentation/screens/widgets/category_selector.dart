import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/category_bloc/category_bloc.dart';
import '../../bloc/category_bloc/category_event.dart';
import '../../bloc/category_bloc/category_state.dart';
import '../../widgets/custom_outline_button.dart';

class CategorySelector extends StatelessWidget {
  final List<String> categories;
  final Function(String category) onCategorySelected;

  const CategorySelector({super.key, required this.categories, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return Container(
          height: 50,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final isSelected = index == state.selectedIndex;
              return CustomOutlineButton(
                title: categories[index],
                isSelected: isSelected,
                onTap: () {
                  context.read<CategoryBloc>().add(SelectCategory(index));
                  onCategorySelected(categories[index]);
                },
              );
            },
          ),
        );
      },
    );
  }
}
