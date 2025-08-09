import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/pet_service_data.dart';
import '../../../data/static_data.dart';
import 'service_event.dart';
import 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final String? category;

  ServiceBloc({this.category}) : super(ServiceState.initial(StaticData.petServices)) {
    on<SearchUpdated>(_onSearchUpdated);
    on<FiltersUpdated>(_onFiltersUpdated);
  }

  void _onSearchUpdated(SearchUpdated event, Emitter<ServiceState> emit) {
    final filters = Map<String, dynamic>.from(state.filters);
    final filteredServices = _filterServices(event.searchQuery, filters);
    final query = event.searchQuery.trim().toLowerCase();

    final List<String> suggestions = query.isEmpty
        ? []
        : StaticData.petServices
              .where(
                (service) =>
                    service.name.toLowerCase().contains(query) ||
                    service.type.toLowerCase().contains(query) ||
                    service.petTypes.any((petType) => petType.toLowerCase().contains(query)),
              )
              .map((service) => service.name)
              .toSet()
              .toList();

    emit(
      state.copyWith(
        searchQuery: event.searchQuery,
        filters: filters,
        filteredServices: filteredServices,
        suggestions: suggestions,
      ),
    );
  }

  void _onFiltersUpdated(FiltersUpdated event, Emitter<ServiceState> emit) {
    final filters = Map<String, dynamic>.from(event.filters);
    final filteredServices = _filterServices(state.searchQuery, filters);
    emit(state.copyWith(filters: filters, filteredServices: filteredServices));
  }

  List<PetService> _filterServices(String searchQuery, Map<String, dynamic> filters) {
    final query = searchQuery.trim().toLowerCase();

    return StaticData.petServices.where((service) {
      final matchesCategory = category == null || service.type == category;

      // Search filter
      final matchesSearch =
          query.isEmpty ||
          service.name.toLowerCase().contains(query) ||
          service.type.toLowerCase().contains(query) ||
          service.petTypes.any((petType) => petType.toLowerCase().contains(query));

      // Rating filter
      final ratingFilter = (filters['rating'] ?? 'All').toString();
      var matchesRating = ratingFilter == 'All';
      if (ratingFilter == '4+ Stars') matchesRating = service.rating >= 4.0;
      if (ratingFilter == '3+ Stars') matchesRating = service.rating >= 3.0;

      // Distance filter
      final distanceFilter = (filters['distance'] ?? 'All').toString();
      var matchesDistance = distanceFilter == 'All';
      final d = service.distance ?? double.infinity;
      if (distanceFilter == 'Within 5km') matchesDistance = d <= 5.0;
      if (distanceFilter == 'Within 10km') matchesDistance = d <= 10.0;

      // Facility type filter
      final facilityFilter = (filters['facilityType'] ?? 'All').toString();
      final matchesFacility = facilityFilter == 'All' || service.type == facilityFilter;

      return matchesCategory && matchesSearch && matchesRating && matchesDistance && matchesFacility;
    }).toList();
  }
}
