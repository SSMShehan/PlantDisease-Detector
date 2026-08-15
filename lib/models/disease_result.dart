/// Disease model for holding AI diagnosis result data.
class DiseaseResult {
  final String diseaseName;
  final double confidenceScore; // 0.0 – 1.0
  final String cropType;
  final List<String> symptoms;
  final List<String> treatments;
  final String severity; // 'low' | 'medium' | 'high'
  final String imagePath;

  const DiseaseResult({
    required this.diseaseName,
    required this.confidenceScore,
    required this.cropType,
    required this.symptoms,
    required this.treatments,
    required this.severity,
    required this.imagePath,
  });

  /// Mock factory – replace with real ML response parsing
  factory DiseaseResult.mock(String imagePath) {
    return DiseaseResult(
      diseaseName: 'Tomato Early Blight',
      confidenceScore: 0.85,
      cropType: 'Tomato',
      severity: 'medium',
      imagePath: imagePath,
      symptoms: [
        'Dark brown circular spots with concentric rings on older leaves',
        'Yellow halo surrounding the lesions',
        'Premature defoliation of lower leaves',
        'Stem lesions that may cause collar rot in seedlings',
        'Reduced fruit size and yield quality',
      ],
      treatments: [
        'Remove and destroy all infected leaves immediately',
        'Apply fungicide containing chlorothalonil or mancozeb every 7–10 days',
        'Avoid overhead irrigation; water at the base of plants',
        'Rotate crops — avoid planting tomatoes in the same location for 2 years',
        'Apply copper-based sprays as a preventive measure next season',
        'Ensure proper plant spacing for adequate air circulation',
      ],
    );
  }
}
