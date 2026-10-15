import 'package:flutter/material.dart';
import '../../models/portfolio_data.dart';
import '../../theme/app_colors.dart';
import '../../widgets/contact_modal.dart';
import '../../widgets/glass_container.dart';

class ProfileTab extends StatelessWidget {
  final VoidCallback? onExploreProjects;

  const ProfileTab({
    super.key,
    this.onExploreProjects,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Profile Glass Card
          _buildHeroCard(context),
          const SizedBox(height: 16),

          // Quick Contact Grid
          _buildQuickContactRow(context),
          const SizedBox(height: 16),

          // Professional Summary Card
          _buildSummaryCard(),
          const SizedBox(height: 16),

          // Key Metrics Counter
          _buildMetricsGrid(),
          const SizedBox(height: 24),

          // Technical Skills Header
          _buildSectionHeader(
            title: 'Technical Arsenal',
            subtitle: 'Core competencies across AI, Mobile, and Full-Stack',
            icon: Icons.code_rounded,
            iconColor: AppColors.secondary,
          ),
          const SizedBox(height: 14),

          // Skill Categories
          ...PortfolioData.skillCategories.map(
            (category) => _buildSkillCategoryCard(category),
          ),

          // Bottom padding so content is not obscured by the floating nav bar
          const SizedBox(height: 110),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return GlassContainer(
      blur: 16,
      opacity: 0.12,
      borderRadius: 24,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with glowing gradient border
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppColors.secondary, AppColors.primary, AppColors.orbPink],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(3),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF101426),
                  ),
                  child: const Center(
                    child: Text(
                      PortfolioData.initials,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Name, Title, and Location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.success,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Flexible(
                            child: Text(
                              'Open to Opportunities',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.success,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Name
                    const Text(
                      PortfolioData.name,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Title
                    const Text(
                      PortfolioData.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Location
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 13,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            PortfolioData.contact.location,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Action buttons row
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFF6366F1)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => ContactModal.show(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send_rounded, size: 14, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            'Get In Touch',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GlassContainer(
                  blur: 10,
                  opacity: 0.1,
                  borderRadius: 14,
                  padding: EdgeInsets.zero,
                  onTap: onExploreProjects,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 11, horizontal: 8),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.rocket_launch_rounded,
                            size: 14,
                            color: AppColors.secondary,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'View Projects',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickContactRow(BuildContext context) {
    const contact = PortfolioData.contact;

    return Row(
      children: [
        Expanded(
          child: _buildContactPill(
            icon: Icons.email_rounded,
            label: 'Email',
            value: contact.email,
            color: AppColors.secondary,
            onTap: () => ContactModal.show(context),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildContactPill(
            icon: Icons.phone_rounded,
            label: 'Phone',
            value: contact.phone,
            color: AppColors.success,
            onTap: () => ContactModal.show(context),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildContactPill(
            icon: Icons.code_rounded,
            label: 'GitHub',
            value: contact.githubUsername,
            color: AppColors.primary,
            onTap: () => ContactModal.show(context),
          ),
        ),
      ],
    );
  }

  Widget _buildContactPill({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GlassContainer(
      blur: 12,
      opacity: 0.08,
      borderRadius: 16,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 9,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return GlassContainer(
      blur: 14,
      opacity: 0.09,
      borderRadius: 20,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.person_pin_rounded, color: AppColors.secondary, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Professional Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            PortfolioData.professionalSummary,
            style: TextStyle(
              fontSize: 13,
              height: 1.55,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 420;

        if (isNarrow) {
          return Column(
            children: [
              Row(
                children: [
                  _buildMetricItem('4+', 'Internships', Icons.business_center_rounded, AppColors.secondary),
                  const SizedBox(width: 8),
                  _buildMetricItem('4+', 'Flagship Projects', Icons.folder_special_rounded, AppColors.primary),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildMetricItem('8.0', 'HITAM CGPA', Icons.grade_rounded, AppColors.warning),
                  const SizedBox(width: 8),
                  _buildMetricItem('9.2', 'Inter MPC', Icons.verified_rounded, AppColors.success),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            _buildMetricItem('4+', 'Internships', Icons.business_center_rounded, AppColors.secondary),
            const SizedBox(width: 8),
            _buildMetricItem('4+', 'Flagship Projects', Icons.folder_special_rounded, AppColors.primary),
            const SizedBox(width: 8),
            _buildMetricItem('8.0', 'HITAM CGPA', Icons.grade_rounded, AppColors.warning),
            const SizedBox(width: 8),
            _buildMetricItem('9.2', 'Inter MPC', Icons.verified_rounded, AppColors.success),
          ],
        );
      },
    );
  }

  Widget _buildMetricItem(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: GlassContainer(
        blur: 10,
        opacity: 0.08,
        borderRadius: 16,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Column(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkillCategoryCard(SkillCategory category) {
    return GlassContainer(
      blur: 12,
      opacity: 0.08,
      borderRadius: 18,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(category.icon, size: 18, color: category.accentColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  category.categoryName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: category.accentColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: category.skills.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: Text(
                  skill,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
