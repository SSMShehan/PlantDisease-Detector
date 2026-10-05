import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'package:plant_disease_detector/core/theme/app_theme.dart';
import 'package:plant_disease_detector/core/providers/locale_provider.dart';
import 'package:plant_disease_detector/core/localization/app_strings.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, String>> _getOnboardingData(BuildContext context) {
    return [
      {
        'title': context.tr(
          en: 'Identify Diseases Instantly',
          si: 'බෝග රෝග ක්ෂණිකව හඳුනාගන්න',
          ta: 'பயிர் நோய்களை உடனடியாகக் கண்டறியவும்',
        ),
        'description': context.tr(
          en: 'Take a photo of any sick plant and let our AI diagnose it in seconds.',
          si: 'ඕනෑම රෝගී පැළෑටියක ඡායාරූපයක් ගෙන අපගේ AI මඟින් තත්පර කිහිපයකින් එය හඳුනාගන්න.',
          ta: 'பாதிக்கப்பட்ட பயிரின் புகைப்படத்தை எடுத்து நொடிகளில் எங்கள் AI மூலம் கண்டறியவும்.',
        ),
        'image': 'https://images.unsplash.com/photo-1622383563227-04401ab4e5ea?q=80&w=800&auto=format&fit=crop',
      },
      {
        'title': context.tr(
          en: 'Get Expert Treatments',
          si: 'විශේෂඥ ප්‍රතිකාර ලබාගන්න',
          ta: 'நிபுணர் சிகிச்சை முறைகளைப் பெறுங்கள்',
        ),
        'description': context.tr(
          en: 'Receive step-by-step organic and chemical treatment plans tailored for your crop.',
          si: 'ඔබේ බෝගයට ගැලපෙන පියවරෙන් පියවර කාබනික හා රසායනික ප්‍රතිකාර සැලසුම් ලබාගන්න.',
          ta: 'உங்கள் பயிருக்கான இயற்கை மற்றும் ரசாயன சிகிச்சை முறைகளைப் பெறுங்கள்.',
        ),
        'image': 'https://images.unsplash.com/photo-1592841200221-a6898f307baa?q=80&w=800&auto=format&fit=crop',
      },
      {
        'title': context.tr(
          en: 'Track Yield & Connect',
          si: 'අස්වැන්න ලුහුබඳින්න සහ එක්වන්න',
          ta: 'விளைச்சலைக் கண்காணித்து இணையுங்கள்',
        ),
        'description': context.tr(
          en: 'Manage your farm expenses and join a community of thriving farmers.',
          si: 'ඔබේ ගොවිපල වියදම් කළමනාකරණය කර සාර්ථක ගොවි ප්‍රජාවකට එකතු වන්න.',
          ta: 'பண்ணை செலவுகளை நிர்வகித்து முன்னணி விவசாயிகளுடன் இணையுங்கள்.',
        ),
        'image': 'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?q=80&w=800&auto=format&fit=crop',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Watch locale so this entire screen rebuilds instantly when language changes
    ref.watch(localeProvider);
    final onboardingData = _getOnboardingData(context);
    final currentLang = AppStrings.currentLocaleCode;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Images Carousel
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: onboardingData.length,
            itemBuilder: (context, index) {
              final gradients = AppGradients.onboardingSlides;
              return Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: gradients[index % gradients.length],
                    ),
                  ),
                  Image.network(
                    onboardingData[index]['image']!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      decoration: BoxDecoration(
                        gradient: gradients[index % gradients.length],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.4),
                          Colors.black.withValues(alpha: 0.9),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          
          // Glassmorphic Content Card at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Page Indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            onboardingData.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 8,
                              width: _currentPage == index ? 24 : 8,
                              decoration: BoxDecoration(
                                color: _currentPage == index ? AppColors.primary : Colors.white.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Text Content (keyed with locale so it dynamically transitions)
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            onboardingData[_currentPage]['title']!,
                            key: ValueKey<String>('title_${_currentPage}_$currentLang'),
                            style: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            onboardingData[_currentPage]['description']!,
                            key: ValueKey<String>('desc_${_currentPage}_$currentLang'),
                            style: AppTextStyles.bodyLarge.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        // Action Button
                        ElevatedButton(
                          onPressed: () {
                            if (_currentPage == onboardingData.length - 1) {
                              context.go('/login');
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            minimumSize: const Size(double.infinity, 60),
                            elevation: 0,
                          ),
                          child: Text(
                            _currentPage == onboardingData.length - 1
                                ? context.tr(en: 'Get Started', si: 'ආරම්භ කරන්න', ta: 'தொடங்குங்கள்')
                                : context.tr(en: 'Next', si: 'ඊළඟ', ta: 'அடுத்து'),
                            style: AppTextStyles.titleMedium.copyWith(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Top Header Bar with Back Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                  ),
                  onPressed: () => context.go('/language'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
