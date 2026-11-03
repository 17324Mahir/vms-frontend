import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/auth/auth_service.dart';
import '../../router/app_router.dart';

/// Beautiful, professional, unified public landing page for Stark Group VMS.
///
/// Features:
/// - Light neutral canvas (#F8FAFC) with deep navy brand header (#0F172A).
/// - Responsive navigation header with section scrolling & mobile drawer.
/// - Restrained fade & slide hero entrance respecting reduced-motion settings.
/// - Crisp code-built fictional mock preview matching internal light theme.
/// - 6 core product capabilities with business-oriented language.
/// - 3-step "How It Works" workflow overview.
/// - Interactive tabbed product preview (Registry Table & Registration Form).
/// - System status indicator and closing CTA.
/// - Full accessibility and responsive layout across desktop, tablet, and mobile.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _heroController;
  late final Animation<double> _heroFadeAnimation;
  late final Animation<Offset> _heroSlideAnimation;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _capabilitiesKey = GlobalKey();
  final GlobalKey _howItWorksKey = GlobalKey();
  final GlobalKey _previewKey = GlobalKey();
  final GlobalKey _statusKey = GlobalKey();

  int _previewTabIndex = 0; // 0 = Fleet Table, 1 = Register Form

  @override
  void initState() {
    super.initState();

    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _heroFadeAnimation = CurvedAnimation(
      parent: _heroController,
      curve: Curves.easeOutCubic,
    );

    _heroSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _heroController,
      curve: Curves.easeOutCubic,
    ));

    _heroController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Respect system reduced-motion preferences
    if (MediaQuery.maybeOf(context)?.disableAnimations == true) {
      _heroController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _heroController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _openMobileMenu(bool isAuthenticated) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'STARK GROUP VMS',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                        color: AppTheme.textDark,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppTheme.textMuted, size: 20),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const Divider(color: AppTheme.borderNeutral),
                ListTile(
                  leading: const Icon(Icons.featured_play_list_outlined, color: AppTheme.primaryBlue, size: 20),
                  title: const Text('Capabilities', style: TextStyle(color: AppTheme.textDark, fontSize: 14)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _scrollTo(_capabilitiesKey);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.account_tree_outlined, color: AppTheme.primaryBlue, size: 20),
                  title: const Text('How It Works', style: TextStyle(color: AppTheme.textDark, fontSize: 14)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _scrollTo(_howItWorksKey);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.preview_outlined, color: AppTheme.primaryBlue, size: 20),
                  title: const Text('Fleet Preview', style: TextStyle(color: AppTheme.textDark, fontSize: 14)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _scrollTo(_previewKey);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cloud_done_outlined, color: AppTheme.statusActiveText, size: 20),
                  title: const Text('System Status', style: TextStyle(color: AppTheme.textDark, fontSize: 14)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _scrollTo(_statusKey);
                  },
                ),
                const SizedBox(height: 12),
                if (isAuthenticated) ...[
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.of(context).pushNamed(AppRouter.vehiclesRoute);
                    },
                    icon: const Icon(Icons.dashboard_rounded, size: 18),
                    label: const Text('Open Fleet Registry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      AuthService.instance.signOut();
                    },
                    icon: const Icon(Icons.logout, size: 18),
                    label: const Text('Sign out'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textDark,
                      side: const BorderSide(color: AppTheme.borderNeutral),
                    ),
                  ),
                ] else ...[
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.of(context).pushNamed(AppRouter.registerRoute);
                    },
                    icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                    label: const Text('Create Account'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.of(context).pushNamed(AppRouter.loginRoute);
                    },
                    icon: const Icon(Icons.login_rounded, size: 18),
                    label: const Text('Sign in'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textDark,
                      side: const BorderSide(color: AppTheme.borderNeutral),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.canvasLight,
      body: ValueListenableBuilder(
        valueListenable: AuthService.instance.sessionNotifier,
        builder: (context, session, _) {
          final isAuthenticated = AuthService.instance.isAuthenticated;

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Sticky Navigation Header (Deep Navy)
              SliverToBoxAdapter(
                child: _buildNavigationBar(context, isAuthenticated),
              ),

              // Hero Section (Light Canvas)
              SliverToBoxAdapter(
                child: _buildHeroSection(context, isAuthenticated),
              ),

              // Product Capabilities Section
              SliverToBoxAdapter(
                key: _capabilitiesKey,
                child: _buildCapabilitiesSection(context),
              ),

              // How It Works Sequence
              SliverToBoxAdapter(
                key: _howItWorksKey,
                child: _buildHowItWorksSection(context),
              ),

              // Interactive Product Preview (Fictional illustration)
              SliverToBoxAdapter(
                key: _previewKey,
                child: _buildProductPreviewSection(context),
              ),

              // Cloud Infrastructure & Status Section
              SliverToBoxAdapter(
                key: _statusKey,
                child: _buildSystemStatusSection(context),
              ),

              // Closing CTA Section
              SliverToBoxAdapter(
                child: _buildClosingCtaSection(context, isAuthenticated),
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
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1150;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? AppTheme.space24 : AppTheme.space16,
        vertical: AppTheme.space12,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.brandNavy,
        border: Border(
          bottom: BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Brand Treatment
              InkWell(
                onTap: () {
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                borderRadius: BorderRadius.circular(6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.directions_car_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: AppTheme.space12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'STARK GROUP',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Vehicle Management System',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Desktop Navigation Links & Actions
              if (isDesktop)
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _navTextButton('Capabilities', () => _scrollTo(_capabilitiesKey)),
                        _navTextButton('How It Works', () => _scrollTo(_howItWorksKey)),
                        _navTextButton('Preview', () => _scrollTo(_previewKey)),
                        _navTextButton('System Status', () => _scrollTo(_statusKey)),
                        const SizedBox(width: 8),
                        if (isAuthenticated) ...[
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pushNamed(AppRouter.vehiclesRoute);
                            },
                            icon: const Icon(Icons.dashboard_rounded, size: 16),
                            label: const Text('Open App'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                          ),
                          const SizedBox(width: AppTheme.space8),
                          OutlinedButton.icon(
                            onPressed: () {
                              AuthService.instance.signOut();
                            },
                            icon: const Icon(Icons.logout, size: 14),
                            label: const Text('Sign out', style: TextStyle(fontSize: 12)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFCBD5E1),
                              side: const BorderSide(color: Color(0xFF334155)),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                          ),
                        ] else ...[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(AppRouter.loginRoute);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFFE2E8F0),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            ),
                            child: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          ),
                          const SizedBox(width: AppTheme.space8),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(AppRouter.registerRoute);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              elevation: 0,
                            ),
                            child: const Text('Register Account', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          ),
                        ],
                      ],
                    ),
                  ),
                )
              else
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () => _openMobileMenu(isAuthenticated),
                  tooltip: 'Open navigation menu',
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navTextButton(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFCBD5E1),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
        child: Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isAuthenticated) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1024;

    return Container(
      color: AppTheme.canvasLight,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? AppTheme.space32 : AppTheme.space20,
        vertical: isDesktop ? 56 : 36,
      ),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: FadeTransition(
          opacity: _heroFadeAnimation,
          child: SlideTransition(
            position: _heroSlideAnimation,
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left: Headline & Actions
                      Expanded(
                        flex: 6,
                        child: _buildHeroLeftContent(context, isAuthenticated),
                      ),
                      const SizedBox(width: 48),
                      // Right: Mock Fleet Dashboard Preview Card
                      Expanded(
                        flex: 5,
                        child: _buildHeroMockPreviewCard(),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      _buildHeroLeftContent(context, isAuthenticated),
                      const SizedBox(height: 36),
                      _buildHeroMockPreviewCard(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroLeftContent(BuildContext context, bool isAuthenticated) {
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 600;

    return Column(
      crossAxisAlignment: isSmall ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Status Pill Tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.surfaceWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.borderNeutral),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.statusActiveText,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  isSmall ? 'Stark Fleet Portal' : 'Stark Industries Fleet Enterprise Portal',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.space20),

        // Main Headline
        Text(
          'Centralized Fleet Operations &\nVehicle Management System',
          textAlign: isSmall ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            fontSize: isSmall ? 28 : 38,
            fontWeight: FontWeight.w800,
            color: AppTheme.textDark,
            letterSpacing: -0.7,
            height: 1.18,
          ),
        ),
        const SizedBox(height: AppTheme.space16),

        // Supporting description
        Text(
          'Track vehicle records across Stark Group subsidiaries. Enforces duplicate vehicle number validation, provides complete lifecycle CRUD, and protects operational data with verified account authentication.',
          textAlign: isSmall ? TextAlign.center : TextAlign.left,
          style: const TextStyle(
            fontSize: 15,
            height: 1.55,
            color: AppTheme.textMuted,
          ),
        ),
        const SizedBox(height: 28),

        // CTAs
        Wrap(
          spacing: 12,
          runSpacing: 10,
          alignment: isSmall ? WrapAlignment.center : WrapAlignment.start,
          children: [
            if (isAuthenticated)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRouter.vehiclesRoute);
                },
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: const Text('Access Fleet Registry', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  elevation: 0,
                ),
              )
            else ...[
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRouter.registerRoute);
                },
                icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
                label: const Text('Create Account', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  elevation: 0,
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRouter.loginRoute);
                },
                icon: const Icon(Icons.login_rounded, size: 18),
                label: const Text('Sign in to Account', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.textDark,
                  side: const BorderSide(color: AppTheme.borderNeutral, width: 1.2),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 24),

        // Functional Capability Chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: isSmall ? WrapAlignment.center : WrapAlignment.start,
          children: const [
            _HeroPill(label: 'Real-Time Registry'),
            _HeroPill(label: 'Duplicate Validation'),
            _HeroPill(label: 'Verified Authentication'),
          ],
        ),
      ],
    );
  }

  /// Visual code-built preview of fleet registry using purely fictional data.
  /// Strictly does NOT fetch real production data.
  Widget _buildHeroMockPreviewCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderNeutral),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppTheme.space20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview Card Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF59E0B),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Flexible(
                      child: Text(
                        'Fleet Registry Preview',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.canvasLight,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppTheme.borderNeutral),
                ),
                child: const Text(
                  'Fictional Mock Data',
                  style: TextStyle(fontSize: 10, color: AppTheme.textMuted),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.space16),

          // KPI Mini Cards Row
          Row(
            children: [
              _buildMockKpiChip('Total Fleet', '24', AppTheme.primaryBlue),
              const SizedBox(width: 8),
              _buildMockKpiChip('Active', '21', AppTheme.statusActiveText),
              const SizedBox(width: 8),
              _buildMockKpiChip('Maintenance', '3', AppTheme.statusMaintenanceText),
            ],
          ),
          const SizedBox(height: AppTheme.space16),

          // Sample Vehicle Rows
          _buildMockVehicleRow(
            vin: 'STK-0042',
            model: 'Audi R8 V10 Plus',
            company: 'Stark Industries',
            status: 'ACTIVE',
            statusBg: AppTheme.statusActiveBg,
            statusColor: AppTheme.statusActiveText,
            statusBorder: AppTheme.statusActiveBorder,
          ),
          const SizedBox(height: 8),
          _buildMockVehicleRow(
            vin: 'STK-0108',
            model: 'Tesla Model S Plaid',
            company: 'Stark Logistics',
            status: 'ACTIVE',
            statusBg: AppTheme.statusActiveBg,
            statusColor: AppTheme.statusActiveText,
            statusBorder: AppTheme.statusActiveBorder,
          ),
          const SizedBox(height: 8),
          _buildMockVehicleRow(
            vin: 'STK-0720',
            model: 'Oshkosh M-ATV',
            company: 'Stark Defense',
            status: 'MAINTENANCE',
            statusBg: AppTheme.statusMaintenanceBg,
            statusColor: AppTheme.statusMaintenanceText,
            statusBorder: AppTheme.statusMaintenanceBorder,
          ),
        ],
      ),
    );
  }

  Widget _buildMockKpiChip(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: AppTheme.canvasLight,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppTheme.borderNeutral),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMockVehicleRow({
    required String vin,
    required String model,
    required String company,
    required String status,
    required Color statusBg,
    required Color statusColor,
    required Color statusBorder,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.canvasLight,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.borderNeutral),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceWhite,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppTheme.borderNeutral),
                  ),
                  child: Text(
                    vin,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        model,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                      ),
                      Text(
                        company,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 10, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusBorder),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapabilitiesSection(BuildContext context) {
    final capabilities = [
      _Capability(
        icon: Icons.directions_car_filled_outlined,
        title: 'Central Vehicle Registry',
        description: 'Normalized tracking of vehicle numbers, subsidiary divisions, body types, manufacturer brands, and models in a central database.',
      ),
      _Capability(
        icon: Icons.sync_alt_rounded,
        title: 'Full Lifecycle CRUD',
        description: 'Register, inspect, update, and decommission fleet vehicles with confirmation dialogs, cancel safety, and live cloud persistence.',
      ),
      _Capability(
        icon: Icons.security_outlined,
        title: 'Duplicate Number Validation',
        description: 'Case-insensitive duplicate checking. Rejects duplicates with inline alerts while safely preserving entered form inputs.',
      ),
      _Capability(
        icon: Icons.visibility_outlined,
        title: 'Operational Status Visibility',
        description: 'Clear classification across ACTIVE, INACTIVE, and MAINTENANCE states with color-coded badges and KPI overview metrics.',
      ),
      _Capability(
        icon: Icons.search_rounded,
        title: 'Instant Multi-Filter Search',
        description: 'Responsive client-side query matching across vehicle numbers, models, and subsidiaries with live total count recalculation.',
      ),
      _Capability(
        icon: Icons.lock_outline_rounded,
        title: 'Secure Account Access',
        description: 'Verified session authentication. Internal vehicle management routes require sign-in; unauthenticated requests redirect to Login.',
      ),
    ];

    return Container(
      color: AppTheme.canvasLight,
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.space32, vertical: 48),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
          children: [
            const Text(
              'CORE CAPABILITIES',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Comprehensive Fleet Oversight',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Reliable fleet operations powered by verified frontend and backend services.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 32),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 720;
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: capabilities.map((c) {
                    return SizedBox(
                      width: isWide ? (constraints.maxWidth - 16) / 2 : constraints.maxWidth,
                      child: Container(
                        padding: const EdgeInsets.all(AppTheme.space20),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceWhite,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.borderNeutral),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryBlueSubtle,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(c.icon, color: AppTheme.primaryBlue, size: 22),
                            ),
                            const SizedBox(width: AppTheme.space16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c.title,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    c.description,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.textMuted,
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

  Widget _buildHowItWorksSection(BuildContext context) {
    final steps = [
      _WorkflowStep(
        number: '01',
        title: 'Create Your Account',
        description: 'Register with your work email and password. Credentials undergo secure validation and database hashing.',
      ),
      _WorkflowStep(
        number: '02',
        title: 'Sign In Securely',
        description: 'Authenticate with your verified credentials to establish a secure, protected session.',
      ),
      _WorkflowStep(
        number: '03',
        title: 'Manage Fleet Assets',
        description: 'Access the Fleet Registry to register, inspect, search, update, and manage subsidiary vehicles with live persistence.',
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.space32, vertical: 48),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceWhite,
        border: Border.symmetric(
          horizontal: BorderSide(color: AppTheme.borderNeutral, width: 1),
        ),
      ),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
          children: [
            const Text(
              'HOW IT WORKS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Simple, Structured Three-Step Workflow',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 32),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 800;
                return isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: steps.map((s) => Expanded(child: _buildStepCard(s))).toList(),
                      )
                    : Column(
                        children: steps.map((s) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildStepCard(s),
                        )).toList(),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(_WorkflowStep s) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(AppTheme.space20),
      decoration: BoxDecoration(
        color: AppTheme.canvasLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderNeutral),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.number,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            s.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            s.description,
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textMuted,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductPreviewSection(BuildContext context) {
    return Container(
      color: AppTheme.canvasLight,
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.space32, vertical: 48),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Column(
          children: [
            const Text(
              'APPLICATION PREVIEW',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Inspect the Internal Experience',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Preview the UI layouts available to authenticated personnel. All data below is illustrative.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 24),

            // Tab Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('Fleet Table View'),
                  selected: _previewTabIndex == 0,
                  onSelected: (selected) {
                    if (selected) setState(() => _previewTabIndex = 0);
                  },
                  selectedColor: AppTheme.primaryBlue,
                  backgroundColor: AppTheme.surfaceWhite,
                  side: const BorderSide(color: AppTheme.borderNeutral),
                  labelStyle: TextStyle(
                    color: _previewTabIndex == 0 ? Colors.white : AppTheme.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text('Vehicle Registration Form'),
                  selected: _previewTabIndex == 1,
                  onSelected: (selected) {
                    if (selected) setState(() => _previewTabIndex = 1);
                  },
                  selectedColor: AppTheme.primaryBlue,
                  backgroundColor: AppTheme.surfaceWhite,
                  side: const BorderSide(color: AppTheme.borderNeutral),
                  labelStyle: TextStyle(
                    color: _previewTabIndex == 1 ? Colors.white : AppTheme.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Preview Card Container (Pure White)
            Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.borderNeutral),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 12,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(AppTheme.space20),
              child: _previewTabIndex == 0
                  ? _buildTablePreviewContent()
                  : _buildFormPreviewContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTablePreviewContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Fleet Registry (12 Vehicles)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textDark),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.canvasLight,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppTheme.borderNeutral),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search, size: 14, color: AppTheme.textMuted),
                  SizedBox(width: 6),
                  Text('Filter by company / number...', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Divider(color: AppTheme.borderNeutral),
        const SizedBox(height: 6),
        _buildMockVehicleRow(
          vin: 'STK-0001',
          model: 'Audi R8 V10 Coupe',
          company: 'Stark Industries',
          status: 'ACTIVE',
          statusBg: AppTheme.statusActiveBg,
          statusColor: AppTheme.statusActiveText,
          statusBorder: AppTheme.statusActiveBorder,
        ),
        const SizedBox(height: 8),
        _buildMockVehicleRow(
          vin: 'STK-0002',
          model: 'Mercedes-Benz Sprinter Cargo',
          company: 'Stark Logistics',
          status: 'ACTIVE',
          statusBg: AppTheme.statusActiveBg,
          statusColor: AppTheme.statusActiveText,
          statusBorder: AppTheme.statusActiveBorder,
        ),
        const SizedBox(height: 8),
        _buildMockVehicleRow(
          vin: 'STK-0003',
          model: 'Ford F-150 Lightning EV',
          company: 'Stark Energy',
          status: 'MAINTENANCE',
          statusBg: AppTheme.statusMaintenanceBg,
          statusColor: AppTheme.statusMaintenanceText,
          statusBorder: AppTheme.statusMaintenanceBorder,
        ),
      ],
    );
  }

  Widget _buildFormPreviewContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Register New Vehicle Form Layout',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textDark),
        ),
        const SizedBox(height: 4),
        const Text(
          'Fields: Vehicle Number (Unique), Subsidiary Company, Vehicle Type, Manufacturer Brand, Model, and Status.',
          style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: _mockFormInput('Vehicle Number', 'e.g. STK-0042')),
            const SizedBox(width: 12),
            Expanded(child: _mockFormInput('Subsidiary Company', 'Stark Industries')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _mockFormInput('Body Type', 'Sedan')),
            const SizedBox(width: 12),
            Expanded(child: _mockFormInput('Model', 'Audi R8')),
          ],
        ),
      ],
    );
  }

  Widget _mockFormInput(String label, String placeholder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: AppTheme.canvasLight,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppTheme.borderNeutral),
          ),
          child: Text(
            placeholder,
            style: const TextStyle(fontSize: 12, color: AppTheme.textDisabled),
          ),
        ),
      ],
    );
  }

  Widget _buildSystemStatusSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.space32, vertical: 24),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.space16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceWhite,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderNeutral),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppTheme.statusActiveText,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Operational Fleet System — Verified Live',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textDark),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Frontend: Netlify Production Edge  •  Backend: Cloud API & PostgreSQL',
                            style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRouter.loginRoute);
                },
                icon: const Icon(Icons.arrow_forward_rounded, size: 14, color: AppTheme.primaryBlue),
                label: const Text('Sign in →', style: TextStyle(color: AppTheme.primaryBlue, fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClosingCtaSection(BuildContext context, bool isAuthenticated) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.space32, vertical: 24),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppTheme.brandNavy,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Text(
                'Ready to Manage Stark Group Fleet Operations?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Create a corporate account today or authenticate with existing credentials to access the verified fleet registry.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color(0xFFCBD5E1)),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  if (isAuthenticated)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRouter.vehiclesRoute);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        elevation: 0,
                      ),
                      child: const Text('Open Fleet Registry', style: TextStyle(fontWeight: FontWeight.w600)),
                    )
                  else ...[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRouter.registerRoute);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        elevation: 0,
                      ),
                      child: const Text('Create Account', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRouter.loginRoute);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFF475569)),
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      child: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ],
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
        color: AppTheme.brandNavy,
        border: Border(
          top: BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Stark Group VMS',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                '  •  Central Fleet Management System',
                style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Production Deployment: Flutter Web & Spring Boot REST API',
            style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  final String label;

  const _HeroPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppTheme.borderNeutral),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline, size: 13, color: AppTheme.primaryBlue),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Capability {
  final IconData icon;
  final String title;
  final String description;

  const _Capability({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _WorkflowStep {
  final String number;
  final String title;
  final String description;

  const _WorkflowStep({
    required this.number,
    required this.title,
    required this.description,
  });
}
