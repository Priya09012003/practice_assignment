class PetService {
  final String name;
  final String type;
  final double rating;
  final String status;
  final List<String> petTypes;
  final String image;
  final double? distance;

  PetService({
    required this.name,
    required this.type,
    required this.rating,
    required this.status,
    required this.petTypes,
    required this.image,
    required this.distance,
  });
}
