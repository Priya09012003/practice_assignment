import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../data/pet_service_data.dart';
import '../widgets/primary_button.dart';

class PetCenterDetailScreen extends StatelessWidget {
  final PetService centerData;

  const PetCenterDetailScreen({Key? key, required this.centerData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final services = {
      'Grooming': {'price': 40.0, 'icon': Icons.cut},
      'Boarding': {'price': 60.0, 'icon': Icons.hotel},
      'Vet Checkup': {'price': 50.0, 'icon': Icons.local_hospital},
    };

    final professionals = [
      {'name': 'Dr. Jane Smith', 'title': 'Veterinarian', 'image': 'assets/img_7.png'},
      {'name': 'Sarah Brown', 'title': 'Groomer', 'image': 'assets/img_9.png'},
      {'name': 'Dr.John Walt', 'title': 'Groomer', 'image': 'assets/img_8.png'},
      {'name': 'Rachel Gilbert', 'title': 'Groomer', 'image': 'assets/img_10.png'},
    ];

    final reviews = [
      {
        'name': 'Emily R.',
        'rating': 5,
        'comment':
            'I couldn’t be happier with the service at this pet center. The staff is friendly, the place is spotless, and they truly care for the animals. My dog Bella came home looking adorable, smelling fresh, and wagging her tail like never before. I’m definitely coming back.',
      },
      {
        'name': 'Michael S.',
        'rating': 4,
        'comment':
            'Friendly staff and clean environment. My cat was well taken care of and came back calm and relaxed.',
      },
      {
        'name': 'Laura P.',
        'rating': 5,
        'comment': 'Highly recommended for pet grooming! They know how to handle even the most energetic pets.',
      },
    ];

    final galleryImages = ['assets/img_1.png', 'assets/img_2.png', 'assets/img_3.png'];

    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.brown600,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(centerData.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: centerData.image,
                    child: Image.asset(centerData.image, fit: BoxFit.cover),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, AppColors.brown600.withOpacity(0.85)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status & rating row
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          customInfoIcon(
                            Icons.info,
                            "Status",
                            centerData.status,
                            centerData.status == 'Open' ? AppColors.openGreen : AppColors.closedRed,
                          ),
                          customInfoIcon(Icons.star, "Rating", "${centerData.rating}", AppColors.amberStar),
                          customInfoIcon(Icons.pets, "Type", centerData.type, AppColors.primaryBrown),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Services section
                  customAnimatedHeader("Services Offered"),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: services.entries.map((entry) {
                      return Container(
                        width: (MediaQuery.of(context).size.width / 2) - 30,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.brown100, AppColors.brown300.withOpacity(0.5)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.brown.shade100, blurRadius: 5)],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(entry.value['icon'] as IconData, color: AppColors.primaryBrown, size: 30),
                            const SizedBox(height: 8),
                            Text(
                              entry.key,
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBrown),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "\$${(entry.value['price'] as double).toStringAsFixed(2)}",
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Professionals section
                  customAnimatedHeader("Our Professionals"),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: professionals.length,
                      itemBuilder: (context, index) {
                        final pro = professionals[index];
                        return Container(
                          width: 160,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.brown.shade200, blurRadius: 6)],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 45,
                                backgroundImage: AssetImage(pro['image']!),
                                backgroundColor: AppColors.brown100,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                pro['name']!,
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBrown),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                pro['title']!,
                                style: const TextStyle(fontSize: 12, color: AppColors.brown300),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Gallery Section
                  customAnimatedHeader("Gallery"),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: galleryImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(image: AssetImage(galleryImages[index]), fit: BoxFit.cover),
                          ),
                          width: 150,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Reviews section
                  customAnimatedHeader("Customer Reviews"),
                  const SizedBox(height: 12),
                  Column(
                    children: reviews.map((review) {
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person, color: AppColors.primaryBrown),
                                  const SizedBox(width: 8),
                                  Text('Customer'!, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const Spacer(),
                                  Row(
                                    children: List.generate(
                                      review['rating'] as int,
                                      (index) => const Icon(Icons.star, size: 16, color: Colors.amber),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ' I couldn’t be happier with the service at this pet center. \nThe staff is friendly, the place is spotless, and they truly care for the animals.\n My dog Bella came home looking adorable, smelling fresh, and wagging her tail like never before.\n I’m definitely coming back',
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),

                  // Location Section
                  customAnimatedHeader("Location"),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset('assets/img_11.png', height: 200, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 30),

                  // Book Appointment button
                  Center(
                    child: PrimaryButton(text: "Book Appointment", width: 250, height: 55, function: () {}),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget customAnimatedHeader(String title) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(offset: Offset(0, (1 - value) * 20), child: child),
        );
      },
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryBrown),
      ),
    );
  }

  Widget customInfoIcon(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(
          value,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
