import 'package:equatable/equatable.dart';
import '../../../data/pet_service_data.dart';

class ServiceState extends Equatable {
  final String searchQuery;
  final Map<String, dynamic> filters;
  final List<PetService> filteredServices;
  final List<String> suggestions;

  const ServiceState({
    this.searchQuery = '',
    required this.filters,
    required this.filteredServices,
    required this.suggestions,
  });

  /// Factory to create the initial state with defaults
  factory ServiceState.initial(List<PetService> allServices) => ServiceState(
    searchQuery: '',
    filters: {'rating': 'All', 'distance': 'All', 'facilityType': 'All'},
    filteredServices: allServices,
    suggestions: [],
  );

  ServiceState copyWith({
    String? searchQuery,
    Map<String, dynamic>? filters,
    List<PetService>? filteredServices,
    List<String>? suggestions,
  }) {
    return ServiceState(
      searchQuery: searchQuery ?? this.searchQuery,
      filters: filters ?? Map<String, dynamic>.from(this.filters),
      filteredServices: filteredServices ?? List<PetService>.from(this.filteredServices),
      suggestions: suggestions ?? List<String>.from(this.suggestions),
    );
  }

  @override
  List<Object?> get props => [searchQuery, filters, filteredServices, suggestions];
}
