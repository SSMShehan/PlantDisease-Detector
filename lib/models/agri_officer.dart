class AgriOfficer {
  final String name;
  final String title;
  final String zone;
  final String phone;
  final String center;
  final double distanceKm;
  final String imageUrl;
  final String availability;
  final List<String> specializations;

  const AgriOfficer({
    required this.name,
    required this.title,
    required this.zone,
    required this.phone,
    required this.center,
    required this.distanceKm,
    required this.imageUrl,
    required this.availability,
    required this.specializations,
  });
}

// Nearest officer (changes based on GPS zone in a real implementation)
final AgriOfficer nearestOfficer = AgriOfficer(
  name: 'Rajitha Perera',
  title: 'Senior Agricultural Officer',
  zone: 'Zone 4 – Western Province',
  phone: '+94 77 123 4567',
  center: 'Kelaniya Agrarian Services Center',
  distanceKm: 2.5,
  imageUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=200&h=200&fit=crop&auto=format',
  availability: 'Available · Mon–Fri, 8AM–4PM',
  specializations: ['Tomato Diseases', 'Paddy Pest Control', 'Organic Farming'],
);
