import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_assignment/presentation/screens/widgets/category_selector.dart';
import 'package:practice_assignment/presentation/screens/widgets/search_bar.dart';
import 'package:practice_assignment/presentation/widgets/primary_button.dart';
import '../../config/routes/routes_name.dart';
import '../../core/theme/colors.dart';
import '../../data/pet_service_data.dart';
import '../bloc/category_bloc/category_bloc.dart';
import '../bloc/service_bloc/service_bloc.dart';
import '../bloc/service_bloc/service_event.dart';
import '../bloc/service_bloc/service_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late final TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.brown600,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'PetPal Services',
                style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/img.png', fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppColors.brown600.withOpacity(0.7)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSearchBar(
                    controller: searchController,
                    hintText: 'Search for grooming, vet, or boarding',
                    onChanged: (value) {
                      context.read<ServiceBloc>().add(SearchUpdated(value));
                    },
                    onClear: () {
                      context.read<ServiceBloc>().add(const SearchUpdated(''));
                    },
                  ),

                  const SizedBox(height: 8),
                  BlocBuilder<ServiceBloc, ServiceState>(
                    builder: (context, state) {
                      return state.searchQuery.isEmpty
                          ? const SizedBox.shrink()
                          : Text(
                              'Searching for: ${state.searchQuery}',
                              style: TextStyle(fontSize: 14, color: AppColors.brown700, fontStyle: FontStyle.italic),
                            );
                    },
                  ),
                  const SizedBox(height: 16),
                  CategorySelector(
                    categories: const ['Grooming', 'Boarding', 'Vet'],
                    onCategorySelected: (category) {
                      Navigator.pushNamed(context, RoutesName.serviceListingScreen, arguments: {'category': category});
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      sectionTitle('Featured Pet Centers'),
                      BlocBuilder<ServiceBloc, ServiceState>(
                        builder: (context, state) {
                          return IconButton(
                            icon: const Icon(Icons.filter_list, color: AppColors.brown500),
                            onPressed: () => showFilterModal(context, state),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  featuredList(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget featuredList(BuildContext context) {
    return BlocBuilder<ServiceBloc, ServiceState>(
      builder: (context, state) {
        return SizedBox(
          height: 340, // Matches your card height
          child: state.filteredServices.isEmpty
              ? const Center(
                  child: Text('No services found', style: TextStyle(color: AppColors.brown500)),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.filteredServices.length,
                  itemBuilder: (context, index) {
                    final center = state.filteredServices[index];
                    return customServiceInfoCard(context, center); // Calling your custom card
                  },
                ),
        );
      },
    );
  }

  Widget customServiceInfoCard(BuildContext context, PetService center) {
    return Container(
      width: 240, // Slightly wider
      margin: const EdgeInsets.only(right: 16, bottom: 12, top: 8),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadowColor: AppColors.brown500.withOpacity(0.2),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.pushNamed(context, RoutesName.petdetailScreen, arguments: {'centerData': center});
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with gradient overlay and badges
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.asset(
                      center.image,
                      height: 140, // Taller image area
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.4)],
                      ),
                    ),
                  ),
                  // Status badge (top-left)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: center.status == 'Open' ? AppColors.openGreen : AppColors.closedRed,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        center.status.toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // Rating chip (bottom-left)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: AppColors.amberStar, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            center.rating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Content area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Service name with pet type icons
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              center.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.brown500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (center.petTypes.contains('Dog'))
                            const Icon(Icons.pets, size: 16, color: AppColors.brown300),
                          if (center.petTypes.contains('Cat'))
                            const Icon(Icons.catching_pokemon, size: 16, color: AppColors.brown300),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Service type with distance
                      Row(
                        children: [
                          Text(center.type, style: TextStyle(color: AppColors.brown300, fontSize: 12)),
                          const Spacer(),
                          Icon(Icons.location_on, size: 12, color: AppColors.brown300),
                          const SizedBox(width: 4),
                          Text(
                            '${center.distance?.toStringAsFixed(1) ?? 'N/A'} km',
                            style: TextStyle(color: AppColors.brown300, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Pet types as chips
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: center.petTypes
                            .map(
                              (pet) => Chip(
                                label: Text(pet),
                                backgroundColor: AppColors.brown100,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                labelStyle: const TextStyle(fontSize: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            )
                            .toList(),
                      ),
                      const Spacer(),
                      // Book Now button
                      PrimaryButton(
                        text: 'Book Now',
                        function: () {
                          Navigator.pushNamed(context, RoutesName.petdetailScreen, arguments: {'centerData': center});
                        },
                        width: double.infinity,
                        height: 40,
                        buttonColor: AppColors.brown500,
                        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.brown500),
    );
  }
}

void showFilterModal(BuildContext outerContext, ServiceState state) {
  final filters = {
    'rating': state.filters['rating']?.toString() ?? 'All',
    'distance': state.filters['distance']?.toString() ?? 'All',
    'facilityType': state.filters['facilityType']?.toString() ?? 'All',
  };

  showModalBottomSheet(
    context: outerContext,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    backgroundColor: AppColors.white,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          Widget filterOption(
            String title,
            List<String> options,
            String? selectedValue,
            ValueChanged<String> onSelected,
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
                    final isSelected = selectedValue == option;
                    return ChoiceChip(
                      label: Text(option),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) onSelected(option);
                      },
                      selectedColor: AppColors.brown300,
                      backgroundColor: AppColors.greyBackground,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.white : AppColors.brown700,
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

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter Services',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.brown500),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.brown500),
                      onPressed: () => Navigator.pop(outerContext),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                filterOption(
                  'Rating',
                  const ['4+ Stars', '3+ Stars', 'All'],
                  filters['rating'],
                  (value) => setModalState(() => filters['rating'] = value),
                ),
                const SizedBox(height: 12),
                filterOption(
                  'Distance',
                  const ['Within 5km', 'Within 10km', 'All'],
                  filters['distance'],
                  (value) => setModalState(() => filters['distance'] = value),
                ),
                const SizedBox(height: 12),
                filterOption(
                  'Facility Type',
                  const ['Grooming', 'Boarding', 'Vet', 'All'],
                  filters['facilityType'],
                  (value) => setModalState(() => filters['facilityType'] = value),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brown500,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                    ),
                    onPressed: () {
                      outerContext.read<ServiceBloc>().add(
                        FiltersUpdated({
                          'rating': filters['rating'] ?? 'All',
                          'distance': filters['distance'] ?? 'All',
                          'facilityType': filters['facilityType'] ?? 'All',
                        }),
                      );
                      Navigator.pop(outerContext);
                    },
                    child: const Text('Apply Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
