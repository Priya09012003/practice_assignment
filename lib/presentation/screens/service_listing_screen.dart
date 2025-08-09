import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/routes/routes_name.dart';
import '../../core/theme/colors.dart';
import '../../data/pet_service_data.dart';
import '../../data/static_data.dart';
import '../bloc/service_bloc/service_bloc.dart';
import '../bloc/service_bloc/service_event.dart';
import '../bloc/service_bloc/service_state.dart';

class ServiceListingScreen extends StatelessWidget {
  final String category;

  const ServiceListingScreen({Key? key, required this.category}) : super(key: key);

  void _showFilterModal(BuildContext context, ServiceState state) {
    Map<String, dynamic> tempFilters = Map.from(state.filters);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      backgroundColor: AppColors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter $category Services',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.brown500),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.brown500),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFilterOption(
                    context,
                    'Rating',
                    ['4+ Stars', '3+ Stars', 'All'],
                    tempFilters['rating'],
                    (value) => setModalState(() => tempFilters['rating'] = value),
                  ),
                  const SizedBox(height: 12),
                  _buildFilterOption(
                    context,
                    'Distance',
                    ['Within 5km', 'Within 10km', 'All'],
                    tempFilters['distance'],
                    (value) => setModalState(() => tempFilters['distance'] = value),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brown500,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 5,
                        ),
                        onPressed: () {
                          context.read<ServiceBloc>().add(FiltersUpdated(tempFilters));
                          Navigator.pop(context);
                        },
                        child: const Text('Apply Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterOption(
    BuildContext context,
    String title,
    List<String> options,
    String selectedValue,
    Function(String) onSelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.brown500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            return ChoiceChip(
              label: Text(option),
              selected: selectedValue == option,
              onSelected: (selected) {
                if (selected) onSelected(option);
              },
              selectedColor: AppColors.brown300,
              backgroundColor: AppColors.greyBackground,
              labelStyle: TextStyle(
                color: selectedValue == option ? AppColors.white : AppColors.brown700,
                fontWeight: FontWeight.w500,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppColors.brown200),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ServiceBloc(category: null)
            ..add(FiltersUpdated({'rating': 'All', 'distance': 'All', 'facilityType': category})),
      child: Scaffold(
        backgroundColor: AppColors.brown50,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(
                '$category Services',
                style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
              ),
              floating: true,
              backgroundColor: AppColors.brown600,
              actions: [
                BlocBuilder<ServiceBloc, ServiceState>(
                  builder: (context, state) {
                    return IconButton(
                      icon: const Icon(Icons.filter_list, color: AppColors.white),
                      onPressed: () => _showFilterModal(context, state),
                    );
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customSearchBar(context),
                    const SizedBox(height: 8),
                    BlocBuilder<ServiceBloc, ServiceState>(
                      builder: (context, state) {
                        return state.searchQuery.isEmpty
                            ? const SizedBox.shrink()
                            : Text(
                                'Searching for: ${state.searchQuery}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.brown700,
                                  fontStyle: FontStyle.italic,
                                ),
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<ServiceBloc, ServiceState>(
              builder: (context, state) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = state.filteredServices[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.petdetailScreen, arguments: {'centerData': item});
                      },
                      child: AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(milliseconds: 500),
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          elevation: 6,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                                child: Image.asset(item.image, width: 120, height: 120, fit: BoxFit.cover),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.brown500,
                                        ),
                                      ),
                                      Text(
                                        "${item.type} • ${item.petTypes.join(', ')}",
                                        style: const TextStyle(color: AppColors.brown300, fontSize: 12),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.star, color: AppColors.amberStar, size: 16),
                                          const SizedBox(width: 4),
                                          Text('${item.rating}', style: const TextStyle(fontSize: 12)),
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: item.status == 'Open' ? AppColors.openGreen : AppColors.closedRed,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              item.status,
                                              style: const TextStyle(
                                                color: AppColors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }, childCount: state.filteredServices.length),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget customSearchBar(BuildContext context) {
    final TextEditingController _searchController = TextEditingController();
    final FocusNode _focusNode = FocusNode();
    return BlocBuilder<ServiceBloc, ServiceState>(
      builder: (context, state) {
        final query = state.searchQuery.toLowerCase();
        final suggestions = query.isEmpty
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

        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(color: AppColors.brown500.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                onChanged: (value) {
                  context.read<ServiceBloc>().add(SearchUpdated(value));
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  hintText: 'Search $category services',
                  hintStyle: const TextStyle(color: AppColors.brown300),
                  prefixIcon: const Icon(Icons.search, color: AppColors.brown500),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close, color: AppColors.brown500),
                    onPressed: () {
                      _searchController.clear();
                      context.read<ServiceBloc>().add(const SearchUpdated(''));
                    },
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            if (suggestions.isNotEmpty && _focusNode.hasFocus)
              Positioned(
                top: 60,
                left: 16,
                right: 16,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.brown500.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = suggestions[index];
                        return ListTile(
                          title: Text(suggestion, style: const TextStyle(color: AppColors.brown700)),
                          onTap: () {
                            _searchController.text = suggestion;
                            context.read<ServiceBloc>().add(SearchUpdated(suggestion));
                            _focusNode.unfocus();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
