import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ultra_client/generated/locale_keys.g.dart';

import '../../../../core/constants/app_colors.dart';

class ImagesPaths {
  static const onb1 = 'assets/images/onb1.png';
  static const onb2 = 'assets/images/onb2.png';
  static const onb3 = 'assets/images/onb3.png';
}

class OnboardingSlide {
  final String image;
  final String titleKey;
  final String subtitleKey;
  OnboardingSlide({required this.image, required this.titleKey, required this.subtitleKey});
}

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentIndex = 0;

  final _slides = <OnboardingSlide>[
    OnboardingSlide(
      image: ImagesPaths.onb1,
      titleKey: LocaleKeys.Onboarding_slide1Title,
      subtitleKey: LocaleKeys.Onboarding_slide1Subtitle,
    ),
    OnboardingSlide(
      image: ImagesPaths.onb2,
      titleKey: LocaleKeys.Onboarding_slide2Title,
      subtitleKey: LocaleKeys.Onboarding_slide2Subtitle,
    ),
    OnboardingSlide(
      image: ImagesPaths.onb3,
      titleKey: LocaleKeys.Onboarding_slide3Title,
      subtitleKey: LocaleKeys.Onboarding_slide3Subtitle,
    ),
  ];



  void _next() {
    if (_currentIndex < _slides.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    } else {
      // TODO: انتقلي لصفحة التسجيل/الدخول
      // Navigator.pushReplacementNamed(context, SignupScreen.routeName);
    }
  }

  void _skip() {
    // TODO: إغلاق / الذهاب لتسجيل الدخول
    // Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final total = _slides.length;
    final progress = ((_currentIndex + 1) / total) * 100;

    return Scaffold(
resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: _CircleIconButton(
                  onTap: _skip,
                  icon: Icons.close,
                ),
              ),
              const Spacer(),
              // صورة داخل دائرة تتبدل خلفيتها زي تصميمك
              Container(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (_currentIndex > 0 && _currentIndex < 3)
                      ? AppColors.white
                      : AppColors.amber,
                ),
                child: SizedBox(
                  height: 300,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _slides.length,
                    onPageChanged: (i) => setState(() => _currentIndex = i),
                    itemBuilder: (_, index) {
                      return Image.asset(
                        _slides[index].image,
                        fit: BoxFit.fitWidth,
                      );
                    },
                  ),
                ),
              ),
              const Spacer(),
              // العنوان
              Text(
                _slides[_currentIndex].titleKey.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              // الوصف
              Text(
                _slides[_currentIndex].subtitleKey.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  height: 1.5,
                  color: AppColors.grey600,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 28),
              // شريط التقدم
              Container(
                height: 6,
                width: 100,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: AppColors.grey500,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: LayoutBuilder(
                  builder: (_, constraints) {
                    final maxW = constraints.maxWidth;
                    final w = (progress / 100.0) * maxW;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 6,
                      width: w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.black,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              // مؤشرات نقاط (اختياري – UI فقط)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  total,
                      (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _currentIndex == i ? 18 : 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == i ? AppColors.black : AppColors.grey400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              // زر التالي / لنبدأ
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _next,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(
                    _currentIndex + 1 == total
                        ? LocaleKeys.Onboarding_startButton.tr()
                        : LocaleKeys.Onboarding_nextButton.tr(),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  const _CircleIconButton({required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: Icon(icon, color: AppColors.black, size: 28),
      ),
    );
  }
}
