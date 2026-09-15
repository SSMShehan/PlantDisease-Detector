import 'package:flutter/material.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';

enum DiseaseSeverity { low, medium, high }

class Disease {
  final String id;
  final String name;
  final String cropName;
  final DiseaseSeverity severity;
  final String description;
  final List<String> symptoms;
  final List<String> causes;
  final List<String> treatments;
  final String imageUrl;

  const Disease({
    required this.id,
    required this.name,
    required this.cropName,
    required this.severity,
    required this.description,
    required this.symptoms,
    required this.causes,
    required this.treatments,
    required this.imageUrl,
  });

  Color get severityColor {
    switch (severity) {
      case DiseaseSeverity.low:
        return const Color(0xFF81B29A); // Green
      case DiseaseSeverity.medium:
        return AppColors.warning; // Orange
      case DiseaseSeverity.high:
        return AppColors.error; // Red
    }
  }

  String get severityLabel {
    switch (severity) {
      case DiseaseSeverity.low:
        return 'Low Severity';
      case DiseaseSeverity.medium:
        return 'Medium Severity';
      case DiseaseSeverity.high:
        return 'High Severity';
    }
  }
}

class DiseaseRepository {
  static const List<Disease> diseases = [
    Disease(
      id: 'd1',
      name: 'Rice Blast',
      cropName: 'Paddy / Rice',
      severity: DiseaseSeverity.high,
      description: 'Rice blast is one of the most destructive diseases of rice worldwide and a major threat to paddy cultivation in Sri Lanka. It can affect all above-ground parts of the plant.',
      symptoms: [
        'Diamond-shaped lesions on leaves with gray centers and dark borders.',
        'Lesions on the neck of the panicle causing it to rot and break over (neck blast).',
        'Stunted growth and empty grains.'
      ],
      causes: [
        'Caused by the fungus Magnaporthe oryzae.',
        'High humidity and frequent, prolonged rain showers.',
        'Excessive nitrogen fertilization.'
      ],
      treatments: [
        'Use blast-resistant rice varieties recommended by the Department of Agriculture.',
        'Apply nitrogen fertilizers in split doses rather than all at once.',
        'Apply systemic fungicides such as Tricyclazole or Isoprothiolane at the first sign of symptoms.',
        'Maintain proper field sanitation by destroying infected crop residue.'
      ],
      imageUrl: 'https://images.unsplash.com/photo-1596541570197-047cf395bc24?q=80&w=800&auto=format&fit=crop', // generic paddy field
    ),
    Disease(
      id: 'd2',
      name: 'Blister Blight',
      cropName: 'Tea',
      severity: DiseaseSeverity.high,
      description: 'A highly destructive leaf disease affecting tea plantations, especially in the hill country of Sri Lanka during monsoon seasons. It affects the young harvestable shoots.',
      symptoms: [
        'Translucent spots on young leaves that later become circular.',
        'Blister-like swellings on the underside of the leaf, which eventually turn white and powdery.',
        'Curling and distortion of young shoots.'
      ],
      causes: [
        'Caused by the fungus Exobasidium vexans.',
        'Thrives in high humidity, low sunlight, and misty conditions typical of up-country Sri Lanka.',
      ],
      treatments: [
        'Modify shade in the plantation to increase sunlight penetration.',
        'Adjust plucking rounds (shorter intervals) during the wet season to remove infected shoots early.',
        'Spray copper-based fungicides (like Copper Oxychloride) immediately after plucking.',
      ],
      imageUrl: 'https://images.unsplash.com/photo-1557999813-f61b3692be2c?q=80&w=800&auto=format&fit=crop', // tea plantation
    ),
    Disease(
      id: 'd3',
      name: 'Early Blight',
      cropName: 'Tomato',
      severity: DiseaseSeverity.medium,
      description: 'A very common fungal disease affecting tomato plants across Sri Lanka, leading to significant defoliation and yield reduction if left unchecked.',
      symptoms: [
        'Dark, concentric rings (target-like spots) on older, lower leaves.',
        'Yellowing of the tissue surrounding the spots.',
        'Dark, sunken lesions on stems and fruit rot at the stem end.'
      ],
      causes: [
        'Caused by the fungus Alternaria solani.',
        'Survives in soil and plant debris; spread by wind and splashing rain.',
        'Warm, humid weather followed by dry spells.'
      ],
      treatments: [
        'Practice crop rotation (do not plant tomatoes or potatoes in the same soil consecutively).',
        'Stake or cage plants to keep foliage off the ground and improve air circulation.',
        'Apply organic mulches to prevent soil from splashing onto leaves.',
        'Use protectant fungicides like Mancozeb or Chlorothalonil preventatively.'
      ],
      imageUrl: 'https://images.unsplash.com/photo-1592841200221-a6898f307baa?q=80&w=800&auto=format&fit=crop', // tomatoes
    ),
    Disease(
      id: 'd4',
      name: 'Papaya Ringspot Virus (PRSV)',
      cropName: 'Papaya',
      severity: DiseaseSeverity.high,
      description: 'A devastating viral disease that severely impacts papaya cultivation in Sri Lanka, causing drastic reductions in fruit yield and quality.',
      symptoms: [
        'Yellow mottling and severe distortion of leaves.',
        'Distinct dark green rings or spots on the fruit surface.',
        'Water-soaked streaks on the leaf stalks and upper stem.'
      ],
      causes: [
        'Transmitted by several species of aphids (insects).',
        'Spread rapidly when infected plants are left in the field.'
      ],
      treatments: [
        'There is no chemical cure for the virus.',
        'Immediately uproot and destroy (burn) infected plants to prevent the virus from spreading.',
        'Control aphid populations using insecticidal soaps or neem oil.',
        'Plant PRSV-tolerant or resistant papaya varieties if available.'
      ],
      imageUrl: 'https://images.unsplash.com/photo-1616688753890-482a87474400?q=80&w=800&auto=format&fit=crop', // papaya
    ),
    Disease(
      id: 'd5',
      name: 'White Root Disease',
      cropName: 'Rubber',
      severity: DiseaseSeverity.high,
      description: 'One of the most lethal root diseases affecting rubber plantations in Sri Lanka. It spreads underground and can wipe out entire patches of trees.',
      symptoms: [
        'Yellowing and premature shedding of leaves.',
        'White, thread-like fungal mycelium on the surface of the roots.',
        'Wood of the root becomes soft and rotted, eventually killing the tree.'
      ],
      causes: [
        'Caused by the fungus Rigidoporus microporus.',
        'Spreads via root contact from infected stumps left in the soil from previous clearings.'
      ],
      treatments: [
        'Thoroughly clear and burn old infected stumps and roots before replanting.',
        'Isolate infected trees by digging isolation trenches (at least 2 feet deep) around them.',
        'Apply sulfur to the soil around infected areas to alter the soil pH, which inhibits fungal growth.',
        'Drench the root zone with recommended systemic fungicides in early stages of infection.'
      ],
      imageUrl: 'https://images.unsplash.com/photo-1610408544577-09d9f582776c?q=80&w=800&auto=format&fit=crop', // rubber tree
    ),
  ];
}
