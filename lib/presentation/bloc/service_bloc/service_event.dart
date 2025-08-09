import 'package:equatable/equatable.dart';

abstract class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object?> get props => [];
}

class SearchUpdated extends ServiceEvent {
  final String searchQuery;
  const SearchUpdated(this.searchQuery);

  @override
  List<Object?> get props => [searchQuery];
}

class FiltersUpdated extends ServiceEvent {
  final Map<String, dynamic> filters;
  const FiltersUpdated(this.filters);

  @override
  List<Object?> get props => [filters];
}
