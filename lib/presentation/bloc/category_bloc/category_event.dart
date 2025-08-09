import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class SelectCategory extends CategoryEvent {
  final int index;

  const SelectCategory(this.index);

  @override
  List<Object?> get props => [index];
}
