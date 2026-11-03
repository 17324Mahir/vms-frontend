import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/auth/auth_service.dart';
import '../../router/app_router.dart';

/// Public landing page for the Stark Group Vehicle Management System (VMS).
///
/// Serves as the primary public entry point at `/`, presenting system features,
/// live operational status, and clear pathways to Register or Sign In.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: ValueListenableBuilder(
        valueListenable: AuthService.instance.sessionNotifier,
        builder: (context, session, _) {
          final isAuthenticated = AuthService.instance.isAuthenticated;

          return CustomScrollView(
            slivers: [
              // Top Navigation Bar
              SliverToBoxAdapter(
                child: _buildNavigationBar(context, isAuthenticated),
              ),

              // Hero Section
              SliverToBoxAdapter(
                child: _buildHeroSection(context, isAuthenticated),
              ),

              // Feature Highlights Grid
              SliverToBoxAdapter(
                child: _buildFeaturesSection(context),
              ),

              // Live Operational Metrics / Infrastructure
              SliverToBoxAdapter(
                child: _buildSystemStatusSection(context),
              ),

              // Footer
              SliverToBoxAdapter(
                child: _buildFooter(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNavigationBar(BuildContext context, bool isAuthenticated) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.space32, vertical: AppTheme.space20),
      decoration: const BoxDecoration(
        color: Color(0xFF0B1329),
        border: Border(
          bottom: BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo & Branding
          InkWell(
            onTap: () => Navigator.of(context).pushReplacementNamed(AppRouter.homeRoute),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.directions_car_rounded, color: Colors.white, size: 22),
                ),
                const SizedBox(width: AppTheme.space12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'STARK GROUP',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Vehicle Management System',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Navigation Actions
          Row(
            children: [
              if (isAuthenticated) ...[
                Text(
                  'Signed in as ${AuthService.instance.currentEmail}',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(width: AppTheme.space16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRouter.vehiclesRoute);
                  },
                  icon: const Icon(Icons.table_chart_rounded, size: 16),
                  label: const Text('Open Fleet Registry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(width: AppTheme.space12),
                OutlinedButton.icon(
                  onPressed: () {
                    AuthService.instance.signOut();
                  },
                  icon: const Icon(Icons.logout, size: 16),
                  label: const Text('Sign out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE2E8F0),
                    side: const BorderSide(color: Color(0xFF334155)),
                  ),
                ),
              ] else ...[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRouter.loginRoute);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFE2E8F0),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: AppTheme.space8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRouter.registerRoute);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Register Account', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isAuthenticated) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.space32, vertical: 64),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 960),
        child: Column(
          children: [
            // Pill tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.verified_user_rounded, color: Color(0xFF60A5FA), size: 14),
                  SizedBox(width: 8),
                  Text(
                    'Stark Industries Fleet Enterprise Portal',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF93C5FD),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.space24),

            // Main Heading
            const Text(
              'Stark Group Vehicle Management System',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.8,
                height: 1.15,
              ),
            ),
            const SizedBox(height: AppTheme.space16),

            // Subtitle
            const Text(
              'Centralized vehicle lifecycle tracking, subsidiary fleet registry, real-time CRUD operations, and duplicate prevention powered by Flutter Web, Spring Boot 3, and managed PostgreSQL.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.55,
                color: Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 36),

            // Primary Call to Action buttons
            Wrap(
              spacing: 16,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                if (isAuthenticated)
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRouter.vehiclesRoute);
                    },
                    icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                    label: const Text('Access Fleet Registry', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 4,
                    ),
                  )
                else ...[
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRouter.loginRoute);
                    },
                    icon: const Icon(Icons.login_rounded, size: 18),
                    label: const Text('Sign in to Account', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 4,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRouter.registerRoute);
                    },
                    icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                    label: const Text('Register New Account', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF475569), width: 1.5),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    final features = [
      _FeatureItem(
        icon: Icons.shield_outlined,
        title: 'Stateless JWT Authentication',
        description: 'Zero-trust in-memory session protection with route guards, automated 401 handling, and cross-origin security.',
      ),
      _FeatureItem(
        icon: Icons.table_view_rounded,
        title: 'Fleet Registry & Search',
        description: 'Browse, filter, and inspect registered fleet vehicles across Stark subsidiaries with instant client-side search.',
      ),
      _FeatureItem(
        icon: Icons.edit_note_rounded,
        title: 'Complete Lifecycle CRUD',
        description: 'Register, edit, and decommission fleet vehicles with live PostgreSQL persistence, validation, and cancel safety.',
      ),
      _FeatureItem(
        icon: Icons.security_update_warning_rounded,
        title: 'Duplicate Number Validation',
        description: 'Case-insensitive, whitespace-normalized duplicate detection returns HTTP 409 Conflict while preserving form data.',
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.space32, vertical: 32),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1080),
        child: Column(
          children: [
            const Text(
              'Engineered for Enterprise Reliability',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Core architectural features of the Stark Group VMS assignment implementation.',
              style: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 32),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                return Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: features.map((f) {
                    return SizedBox(
                      width: isWide ? (constraints.maxWidth - 20) / 2 : constraints.maxWidth,
                      child: Container(
                        padding: const EdgeInsets.all(AppTheme.space24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2563EB).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(f.icon, color: const Color(0xFF60A5FA), size: 24),
                            ),
                            const SizedBox(width: AppTheme.space16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    f.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    f.description,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF94A3B8),
                                      height: 1.45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemStatusSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.space32, vertical: 32),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.space20),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFF10B981),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Live Production Environment',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        'Frontend: Netlify Edge CDN  •  Backend: Render Managed Cloud (PostgreSQL 16)',
                        style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRouter.loginRoute);
                },
                child: const Text('Go to Login →', style: TextStyle(color: Color(0xFF60A5FA), fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.space32, vertical: AppTheme.space24),
      decoration: const BoxDecoration(
        color: Color(0xFF0B1329),
        border: Border(
          top: BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
      ),
      alignment: Alignment.center,
      child: const Text(
        '© 2026 Stark Group Vehicle Management System. All rights reserved.',
        style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
      ),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}
