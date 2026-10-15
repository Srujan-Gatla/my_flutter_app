import 'package:flutter/material.dart';
import '../models/portfolio_data.dart';
import '../theme/app_colors.dart';
import '../widgets/contact_modal.dart';
import '../widgets/custom_tab_bar.dart';
import '../widgets/glass_container.dart';
import '../widgets/mesh_background.dart';
import 'payment_invoice_screen.dart';
import 'tabs/education_tab.dart';
import 'tabs/experience_tab.dart';
import 'tabs/profile_tab.dart';
import 'tabs/projects_tab.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  late final PageController _pageController;

  final List<CustomTabBarItem> _navItems = const [
    CustomTabBarItem(
      icon: Icons.person_rounded,
      label: 'About',
    ),
    CustomTabBarItem(
      icon: Icons.work_history_rounded,
      label: 'Experience',
    ),
    CustomTabBarItem(
      icon: Icons.rocket_launch_rounded,
      label: 'Projects',
    ),
    CustomTabBarItem(
      icon: Icons.school_rounded,
      label: 'Education',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: MeshBackground(
        child: Stack(
          children: [
            // Top App Bar + Tab Page View
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Glass Top Header
                  _buildTopBar(context),

                  // Tab Views with PageController
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        ProfileTab(
                          onExploreProjects: () => _onTabSelected(2),
                        ),
                        const ExperienceTab(),
                        const ProjectsTab(),
                        const EducationTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Floating Glass Navigation Bar at the bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomFloatingTabBar(
                selectedIndex: _currentIndex,
                onTabSelected: _onTabSelected,
                items: _navItems,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GlassContainer(
        blur: 14,
        opacity: 0.10,
        borderRadius: 20,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        borderColor: AppColors.glassBorderHighlight,
        child: Row(
          children: [
            // Mini logo initials badge
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.secondary, AppColors.primary],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  PortfolioData.initials,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Name and active tab indicator
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    PortfolioData.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    _navItems[_currentIndex].label,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),

            // Pay / Invoicing Quick Action
            GlassContainer(
              blur: 8,
              opacity: 0.12,
              borderRadius: 14,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              borderColor: AppColors.success.withValues(alpha: 0.4),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentInvoiceScreen(),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.payments_rounded,
                    size: 14,
                    color: AppColors.success,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Pay',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),

            // Quick Contact / Message Action Pill
            GlassContainer(
              blur: 8,
              opacity: 0.12,
              borderRadius: 14,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              borderColor: AppColors.secondary.withValues(alpha: 0.3),
              onTap: () => ContactModal.show(context),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.alternate_email_rounded,
                    size: 14,
                    color: AppColors.secondary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Connect',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
