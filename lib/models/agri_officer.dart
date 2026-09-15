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

// Dynamic Nearest Officer based on location
AgriOfficer getNearestOfficer(String location) {
  final lowerLoc = location.toLowerCase();

  if (lowerLoc.contains('dambulla')) {
    return const AgriOfficer(
      name: 'Sunil Bandara',
      title: 'Senior Agricultural Officer',
      zone: 'Zone 2 – Central Province',
      phone: '+94 77 987 6543',
      center: 'Dambulla Agrarian Services Center',
      distanceKm: 1.2,
      imageUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200&h=200&fit=crop&auto=format',
      availability: 'Available · Mon–Fri, 8AM–4PM',
      specializations: ['Vegetable Cultivation', 'Pest Control', 'Greenhouse Farming'],
    );
  } else if (lowerLoc.contains('anuradhapura')) {
    return const AgriOfficer(
      name: 'Nimal Silva',
      title: 'District Agriculture Director',
      zone: 'Zone 1 – North Central',
      phone: '+94 71 234 5678',
      center: 'Anuradhapura Agricultural Office',
      distanceKm: 3.5,
      imageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop&auto=format',
      availability: 'Available · Mon–Sat, 8AM–5PM',
      specializations: ['Paddy Diseases', 'Dry Zone Farming', 'Irrigation'],
    );
  }

  // Default Fallback
  return const AgriOfficer(
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
}

// Keeping the old one just in case it's used elsewhere statically without location context
final AgriOfficer nearestOfficer = getNearestOfficer('default');
