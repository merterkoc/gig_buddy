import 'package:flutter/material.dart';
import 'package:gig_buddy/src/route/router.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingPagePresenter(
        onSkip: () {
          goRouter.goNamed(AppRoute.homeView.name);
        },
        onFinish: () {
          goRouter.goNamed(AppRoute.homeView.name);
        },
        pages: [
          OnboardingPageModel(
            title: 'Konserlerle Dolu Bir Dünyaya Katıl!',
            description:
                'En sevdiğin sanatçıların konserlerini keşfet, tek bir yerde bul.',
            imagePath: 'assets/images/onboarding/ob_1.jpg',
            bgColor: Colors.indigo,
          ),
          OnboardingPageModel(
            title: 'Anılar Biriktirmek İçin Plan Yap!',
            description:
                'Konserleri takvimine ekleyip, unutulmaz bir deneyim için hazırlığını yap.',
            imagePath: 'assets/images/onboarding/ob_2.jpg',
            bgColor: const Color(0xff1eb090),
          ),
          OnboardingPageModel(
            title: 'Seninle Aynı Müziği Sevenleri Bul!',
            description:
                'Konsere yalnız gitme! Müzik zevkine uygun arkadaşlarla tanış.',
            imagePath: 'assets/images/onboarding/ob_3.jpg',
            bgColor: const Color(0xfffeae4f),
          ),
          OnboardingPageModel(
            title: 'Müziği Yaşa, Anın Tadını Çıkar!',
            description:
                'Unutulmaz konser anıları bir tık uzağında. Eğlenceye başla!',
            imagePath: 'assets/images/onboarding/ob_4.jpg',
            bgColor: Colors.purple,
          ),
        ],
      ),
    );
  }
}

class OnboardingPagePresenter extends StatefulWidget {
  const OnboardingPagePresenter({
    required this.pages,
    super.key,
    this.onSkip,
    this.onFinish,
  });

  final List<OnboardingPageModel> pages;
  final VoidCallback? onSkip;
  final VoidCallback? onFinish;

  @override
  State<OnboardingPagePresenter> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPagePresenter> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          image: DecorationImage(
            opacity: 0.8,
            image: AssetImage(widget.pages[_currentPage].imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                // Pageview to render each page
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.pages.length,
                  onPageChanged: (idx) {
                    // Change current page when pageview changes
                    setState(() {
                      _currentPage = idx;
                    });
                  },
                  itemBuilder: (context, idx) {
                    final item = widget.pages[idx];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Expanded(
                        //   flex: 3,
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(32),
                        //     child: Image.network(
                        //       item.imageUrl,
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Stack(
                                  children: [
                                    Text(
                                      item.title,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: item.textColor,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 13,
                                            color:
                                                Colors.black.withOpacity(0.5),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 280),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 8,
                                ),
                                child: Text(
                                  item.description,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                    color: item.textColor,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 13,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Current page indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.pages
                    .map(
                      (item) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width:
                            _currentPage == widget.pages.indexOf(item) ? 30 : 8,
                        height: 8,
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )
                    .toList(),
              ),

              // Bottom buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 34),
                child: SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.comfortable,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          widget.onSkip?.call();
                        },
                        child: const Text('Skip'),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.comfortable,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          if (_currentPage == widget.pages.length - 1) {
                            widget.onFinish?.call();
                          } else {
                            _pageController.animateToPage(
                              _currentPage + 1,
                              curve: Curves.easeInOutCubic,
                              duration: const Duration(milliseconds: 250),
                            );
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              _currentPage == widget.pages.length - 1
                                  ? 'Get Started'
                                  : 'Next',
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              _currentPage == widget.pages.length - 1
                                  ? Icons.done
                                  : Icons.arrow_forward,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPageModel {
  OnboardingPageModel({
    required this.title,
    required this.description,
    required this.imagePath,
    this.bgColor = Colors.blue,
    this.textColor = Colors.white,
  });

  final String title;
  final String description;
  final String imagePath;
  final Color bgColor;
  final Color textColor;
}
