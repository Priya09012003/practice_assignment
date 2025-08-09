import 'package:equatable/equatable.dart';

class CategoryState extends Equatable {
  final int selectedIndex;

  const CategoryState({this.selectedIndex = 0});

  CategoryState copyWith({int? selectedIndex}) {
    return CategoryState(selectedIndex: selectedIndex ?? this.selectedIndex);
  }

  @override
  List<Object?> get props => [selectedIndex];
}
