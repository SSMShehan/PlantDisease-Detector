import 'dart:math';

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

  /// Mock factory – returns a random disease result for demo/HCI purposes.
  /// Replace with real ML response parsing when the model is integrated.
  factory DiseaseResult.mock(String imagePath) {
    final results = _mockDataset(imagePath);
    return results[Random().nextInt(results.length)];
  }

  static List<DiseaseResult> _mockDataset(String imagePath) => [
        DiseaseResult(
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
        ),
        DiseaseResult(
          diseaseName: 'Powdery Mildew',
          confidenceScore: 0.91,
          cropType: 'Cucumber',
          severity: 'low',
          imagePath: imagePath,
          symptoms: [
            'White powdery patches on upper leaf surfaces',
            'Yellowing and curling of affected leaves',
            'Stunted plant growth in severe cases',
            'Affected leaves may dry out and fall off prematurely',
          ],
          treatments: [
            'Apply neem oil spray every 7 days as a natural fungicide',
            'Use potassium bicarbonate or baking soda solution as a foliar spray',
            'Improve air circulation by pruning dense foliage',
            'Avoid excess nitrogen fertilizers which promote soft growth',
            'Apply sulphur-based fungicide if infection is severe',
          ],
        ),
        DiseaseResult(
          diseaseName: 'Bacterial Leaf Blight',
          confidenceScore: 0.78,
          cropType: 'Rice',
          severity: 'high',
          imagePath: imagePath,
          symptoms: [
            'Water-soaked lesions along leaf margins that turn yellow then brown',
            'Leaves wilt and dry out starting from the tips',
            'Milky or opaque bacterial ooze visible in humid conditions',
            'Wilting of entire tillers in severe cases (kresek symptom)',
            'Significant reduction in grain filling and yield',
          ],
          treatments: [
            'Remove and burn heavily infected plant material immediately',
            'Apply copper-based bactericides such as copper oxychloride',
            'Drain and dry fields periodically to reduce moisture',
            'Use certified disease-free seeds for the next planting season',
            'Apply balanced fertilization — avoid excess nitrogen',
            'Plant resistant rice varieties recommended for your region',
          ],
        ),
        DiseaseResult(
          diseaseName: 'Anthracnose',
          confidenceScore: 0.82,
          cropType: 'Mango',
          severity: 'medium',
          imagePath: imagePath,
          symptoms: [
            'Dark, water-soaked lesions on leaves, flowers, and fruit',
            'Brown to black sunken spots on ripening fruit',
            'Infected flowers turn brown and drop prematurely',
            'Shot-hole appearance on leaves as lesions dry and fall out',
          ],
          treatments: [
            'Prune and destroy infected branches and fruit material',
            'Apply mancozeb or copper fungicide before and during flowering',
            'Avoid wetting foliage — use drip irrigation where possible',
            'Apply post-harvest hot water treatment (52°C for 5 minutes) on fruit',
            'Ensure good canopy ventilation by regular pruning',
          ],
        ),
        DiseaseResult(
          diseaseName: 'Downy Mildew',
          confidenceScore: 0.74,
          cropType: 'Grape',
          severity: 'high',
          imagePath: imagePath,
          symptoms: [
            'Oil-spot-like yellow patches on upper leaf surface',
            'White cottony fungal growth on the underside of leaves',
            'Infected shoots become stunted and twisted',
            'Fruit turns brown and mummifies without ripening',
            'Severe defoliation during humid, wet weather periods',
          ],
          treatments: [
            'Apply copper-based fungicides preventively before wet seasons',
            'Use systemic fungicides such as metalaxyl during active infection',
            'Remove and destroy all fallen infected leaves and fruit',
            'Improve vineyard air circulation through proper canopy management',
            'Avoid working in the vineyard when foliage is wet',
            'Plant downy mildew resistant grape varieties where possible',
          ],
        ),
      ];
}
