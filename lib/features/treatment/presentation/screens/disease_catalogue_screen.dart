import 'package:flutter/material.dart';
import 'package:plant_disease_detector/core/theme/app_theme.dart';
import 'package:plant_disease_detector/features/treatment/presentation/screens/disease_comparison_screen.dart';
import 'package:plant_disease_detector/features/treatment/presentation/screens/disease_detail_screen.dart';
import 'package:plant_disease_detector/features/treatment/data/disease_model.dart';

class DiseaseCatalogueScreen extends StatefulWidget {
  const DiseaseCatalogueScreen({super.key});

  @override
  State<DiseaseCatalogueScreen> createState() => _DiseaseCatalogueScreenState();
}

class _DiseaseCatalogueScreenState extends State<DiseaseCatalogueScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredDiseases = DiseaseRepository.diseases.where((d) {
      final query = _searchQuery.toLowerCase();
      return d.name.toLowerCase().contains(query) || d.cropName.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Disease Catalogue', style: AppTextStyles.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.compare_arrows_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DiseaseComparisonScreen()),
              );
            },
            tooltip: 'Compare Diseases',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                style: AppTextStyles.bodyMedium,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                  hintText: 'Search diseases or crops...',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
              ),
            ),
          ),
          
          // List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: filteredDiseases.length,
              itemBuilder: (context, index) {
                return _buildDiseaseCard(filteredDiseases[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseCard(Disease disease) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => DiseaseDetailScreen(disease: disease)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Hero(
              tag: 'disease_img_${disease.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                child: Image.network(
                  disease.imageUrl,
                  width: 100,
                  height: 110,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 100,
                    height: 110,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported_rounded, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(disease.name, style: AppTextStyles.titleMedium),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.grass_rounded, size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(disease.cropName, style: AppTextStyles.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: disease.severityColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      disease.severityLabel,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: disease.severityColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
