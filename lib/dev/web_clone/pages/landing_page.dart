import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app.dart';
import '../theme/saabi_theme.dart';
import '../widgets/saabi_widgets.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key, required this.onNavigate});

  final void Function(SaabiPage page) onNavigate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          HeroSection(onExplore: onNavigate),
          const StorySection(),
          const OnboardingSection(),
          const WhatsAppBotSection(),
          const PricingSection(),
          CTASection(onAction: () => onNavigate(SaabiPage.dashboard)),
        ],
      ),
    );
  }
}

class HeroSection extends StatefulWidget {
  const HeroSection({super.key, required this.onExplore});

  final void Function(SaabiPage page) onExplore;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Offset> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 16))..repeat();
    final random = math.Random(9);
    _particles = List.generate(20, (_) => Offset(random.nextDouble(), random.nextDouble()));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF050505), Color(0xFF050505), Color(0xFF050505)],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Stack(
                children: [
                  Center(
                    child: SizedBox(
                      width: size > 700 ? 900 : 640,
                      height: size > 700 ? 900 : 640,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: SaabiTheme.accent.withValues(alpha: 0.16),
                              boxShadow: [BoxShadow(color: SaabiTheme.accent.withValues(alpha: 0.24), blurRadius: 110)],
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return Transform.rotate(angle: _controller.value * math.pi * 2, child: child);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: SaabiTheme.accent.withValues(alpha: 0.2),
                                  width: 1.2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return Transform.rotate(angle: -_controller.value * math.pi * 2, child: child);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(42),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  width: 1.2,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                          ),
                          Image.asset('assets/images/golden_globe_main_asset_img.png', fit: BoxFit.contain),
                        ],
                      ),
                    ),
                  ),
                  ..._particles.asMap().entries.map((entry) {
                    final i = entry.key;
                    final particle = entry.value;
                    final duration = 3 + (i % 4);
                    return Positioned(
                      left: particle.dx * MediaQuery.of(context).size.width,
                      top: particle.dy * 600,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.7, end: 1.2),
                        duration: Duration(seconds: duration),
                        curve: Curves.easeInOut,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, math.sin((_controller.value * math.pi * 2) + i) * 18),
                            child: Transform.scale(scale: value, child: child),
                          );
                        },
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: SaabiTheme.accent.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: SaabiTheme.accent.withValues(alpha: 0.3), blurRadius: 10)],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF050505), Color(0xFF050505), Colors.transparent],
                  stops: [0.0, 0.58, 1.0],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xFF050505), Colors.transparent],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, size > 700 ? 120 : 96, 20, 40),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: SaabiTheme.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: SaabiTheme.accent.withValues(alpha: 0.25)),
                  ),
                  child: Text(
                    'FOR SAABI PEOPLE, BY SAABI PEOPLE',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: SaabiTheme.accent,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 26),
                Text(
                  'THE REAL ENGINE OF COMMERCE',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: size > 700 ? 68 : 38,
                    height: 0.95,
                    letterSpacing: -2,
                  ),
                ),
                const SizedBox(height: 18),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 540),
                  child: Text(
                    'Scale your business with distributed WhatsApp payments and state-wide service discovery. Built for West Africa\'s economic powerhouse.',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.white.withValues(alpha: 0.6), height: 1.6),
                  ),
                ),
                const SizedBox(height: 30),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: SaabiTheme.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () => widget.onExplore(SaabiPage.dashboard),
                      icon: const Icon(Icons.arrow_forward, size: 18),
                      label: const Text(
                        'JOIN TODAY',
                        style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2),
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.16)),
                        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                        shape: const StadiumBorder(),
                      ),
                      onPressed: () => widget.onExplore(SaabiPage.investment),
                      child: const Text(
                        'INVEST NOW',
                        style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 34),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 24,
                  runSpacing: 20,
                  children: const [
                    _HeroStat(value: '40M+', label: 'Informal Traders'),
                    _HeroStat(value: '₦0', label: 'Install Cost'),
                    _HeroStat(value: '24/7', label: 'WhatsApp Bot'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: SaabiTheme.accent, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.42),
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class StorySection extends StatelessWidget {
  const StorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _StoryCardData(
        'Distributed Payments',
        'Formalizing the Informal',
        'A trader in Mushin can now receive payments from around the world via a simple WhatsApp bot. No app install needed.',
        'assets/images/money-tree.jpg',
        Icons.message_outlined,
        true,
      ),
      _StoryCardData(
        'Service Discovery',
        'Find Talent Instantly',
        'Looking for a plumber in Yaba? Our NLP engine matches skills to needs in seconds.',
        'assets/images/busy-street.jpg',
        Icons.search,
        false,
      ),
      _StoryCardData(
        'State Visibility',
        'Aggregate Analytics',
        'Real-time heatmaps for LGA revenue tracking without compromising individual privacy.',
        'assets/images/city-low.jpg',
        Icons.bar_chart,
        false,
      ),
      _StoryCardData(
        'SAABI Wallet',
        'Financial Inclusion',
        'Every trader gets a virtual account linked to their BVN, enabling formal credit scoring.',
        'assets/images/inclusion.jpg',
        Icons.account_balance_wallet_outlined,
        false,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'BRIDGING THE ',
            highlight: 'DIGITAL DIVIDE',
            subtitle:
                'SAABI is not just an app. It is a national utility layer for the 80% of Nigeria that operates in the shadows.',
          ),
          const SizedBox(height: 28),
          ...cards.map(
            (card) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ImageSectionCard(
                imagePath: card.imagePath,
                title: card.title,
                subtitle: card.subtitle,
                description: card.description,
                icon: card.icon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingSection extends StatelessWidget {
  const OnboardingSection({super.key});

  @override
  Widget build(BuildContext context) {
    const steps = [
      _StepData(
        '01',
        'Save Number',
        'Save the SAABI number on your phone or scan the QR code to start.',
        ' +234 800 000 SAABI',
        Icons.smartphone,
      ),
      _StepData(
        '02',
        "Say 'Hello'",
        'Open WhatsApp and send Hello. Our friendly Bot will reply instantly.',
        'Available 24/7',
        Icons.chat_bubble_outline,
      ),
      _StepData(
        '03',
        'Start Trading',
        "Send 'Pay' or 'Find Plumber' to start doing business. It is that easy!",
        'Stress Free',
        Icons.flash_on,
      ),
    ];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
      decoration: BoxDecoration(
        color: const Color(0xFF050505),
        border: Border.symmetric(horizontal: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: Column(
        children: [
          SectionTitle(
            title: 'START IN ',
            highlight: 'SECONDS',
            subtitle: 'No complex apps. No long forms. Just you and your WhatsApp.',
            center: true,
          ),
          const SizedBox(height: 32),
          Column(
            children: [
              for (final step in steps) ...[_OnboardingCard(step: step), const SizedBox(height: 18)],
            ],
          ),
          const SizedBox(height: 8),
          SectionCard(
            radius: 24,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_outline, color: SaabiTheme.accent, size: 18),
                const SizedBox(width: 10),
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Get Started Today ',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: 'And Join The Sabbi People',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingCard extends StatelessWidget {
  const _OnboardingCard({required this.step});

  final _StepData step;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      radius: 30,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: SaabiTheme.accent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: SaabiTheme.accent.withValues(alpha: 0.2)),
                ),
                child: Icon(step.icon, color: SaabiTheme.accent, size: 34),
              ),
              Positioned(
                right: -8,
                top: -8,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: SaabiTheme.accent,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF050505), width: 3),
                  ),
                  child: Center(
                    child: Text(step.id, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(step.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(
            step.description,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.4), height: 1.5),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Text(
              step.detail,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.4),
                fontWeight: FontWeight.w900,
                letterSpacing: 2.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WhatsAppBotSection extends StatelessWidget {
  const WhatsAppBotSection({super.key});

  Future<void> _openWhatsApp() async {
    await launchUrl(Uri.parse('https://wa.me/234800000SAABI'), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: SectionCard(
        radius: 40,
        maxHeight: 0,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: SaabiTheme.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: SaabiTheme.accent.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.auto_awesome, size: 12, color: SaabiTheme.accent),
                  const SizedBox(width: 6),
                  Text(
                    'Pure Simplicity',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: SaabiTheme.accent,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            SectionTitle(
              title: 'YOUR BUSINESS ',
              highlight: 'IN YOUR POCKET',
              subtitle:
                  'Forget complex apps. Just send a text. Check sales, pay suppliers, and find customers directly on WhatsApp.',
              center: true,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: SaabiTheme.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: const StadiumBorder(),
              ),
              onPressed: _openWhatsApp,
              icon: const Icon(Icons.chat_bubble_outline, size: 18),
              label: const Text('CHAT WITH SAABI', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
            ),
            const SizedBox(height: 28),
            Column(children: const [PhoneMockSectionOne(), SizedBox(height: 16), PhoneMockSectionTwo()]),
          ],
        ),
      ),
    );
  }
}

class PhoneMockSectionOne extends StatelessWidget {
  const PhoneMockSectionOne({super.key});

  @override
  Widget build(BuildContext context) {
    return PhoneMockCard(
      statusLabel: 'POWERED BY THE SAABI ENGINE',
      messages: const [
        ChatBubbleData('Welcome! How can I help your business today?', isUser: false),
        ChatBubbleData('Find plumber in Ikeja', isUser: true),
        ChatBubbleData('Found 3 Plumbers\n1. Baba Tolu - 5.0 ★\n2. Quick Fix - 4.8 ★', isUser: false),
      ],
    );
  }
}

class PhoneMockSectionTwo extends StatelessWidget {
  const PhoneMockSectionTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return PhoneMockCard(
      statusLabel: 'ENCRYPTED',
      messages: const [
        ChatBubbleData('"transfer 2k to John Opay 23488XXXXX"', isUser: true),
        ChatBubbleData(
          'Processing Transaction...\nVerifying John Opay (9827***31). Confirming ₦2,000.00 from your Wallet.',
          isUser: false,
        ),
        ChatBubbleData('✓ Payment Successful\nRef: SAABI-992-TX • 2:40 PM', isUser: false),
      ],
    );
  }
}

class PricingSection extends StatelessWidget {
  const PricingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final plans = [
      _PricingCardData('Starter', 'Free', 'Perfect for individual informal traders', [
        'WhatsApp Payment Bot',
        'Basic Service Profile',
        'Standard QR Codes',
        '24/7 Support',
      ], false),
      _PricingCardData('Pro Trader', '₦5k / mo', 'For growing businesses needing scale', [
        'Advanced NLP Matching',
        'Verified Badge',
        'Priority Discovery',
        'Credit Score Building',
        'Inventory Management',
      ], true),
      _PricingCardData('Institutional', 'Custom', 'For IRS and Ministry agencies', [
        'LGA Dashboards',
        'Raw Data Access',
        'Heatmap Analytics',
        'Custom Reporting',
        'Multi-user Access',
      ], false),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: [
          SectionTitle(
            title: 'FUEL YOUR ',
            highlight: 'AMBITION',
            subtitle: 'Choose the tier that fits your journey. From the smallest stall to the largest ministry.',
            center: true,
          ),
          const SizedBox(height: 28),
          Column(
            children: [
              for (final plan in plans) ...[_PricingCard(plan: plan), const SizedBox(height: 16)],
            ],
          ),
        ],
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  const _PricingCard({required this.plan});

  final _PricingCardData plan;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      radius: 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (plan.popular)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: SaabiTheme.accent, borderRadius: BorderRadius.circular(999)),
              child: const Text(
                'Most Popular',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.4),
              ),
            ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: plan.popular ? SaabiTheme.accent.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              plan.popular ? Icons.bolt : Icons.auto_graph,
              color: plan.popular ? SaabiTheme.accent : Colors.white70,
            ),
          ),
          const SizedBox(height: 18),
          Text(plan.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(
            plan.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.4)),
          ),
          const SizedBox(height: 18),
          Text(plan.price, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 18),
          ...plan.features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: SaabiTheme.accent.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: SaabiTheme.accent.withValues(alpha: 0.18)),
                    ),
                    child: const Icon(Icons.check, size: 10, color: SaabiTheme.accent),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      feature,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.6)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: plan.popular ? SaabiTheme.accent : Colors.white.withValues(alpha: 0.06),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                plan.price == 'Custom' ? 'Contact Sales' : 'Get Started',
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CTASection extends StatelessWidget {
  const CTASection({super.key, required this.onAction});

  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 40),
      child: SectionCard(
        radius: 44,
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [SaabiTheme.accent, Color(0xFF7A2E00)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(36),
          ),
          child: Column(
            children: [
              Text(
                'JOIN THE FINANCIAL REVOLUTION',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, color: Colors.white, height: 1.05),
              ),
              const SizedBox(height: 16),
              Text(
                'Don\'t get left behind. Join SAABI Today and Secure your tomorrow.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white.withValues(alpha: 0.75), height: 1.5),
              ),
              const SizedBox(height: 22),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                  shape: const StadiumBorder(),
                ),
                onPressed: onAction,
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: const Text('GET STARTED NOW', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.1)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoryCardData {
  const _StoryCardData(this.title, this.subtitle, this.description, this.imagePath, this.icon, this.large);

  final String title;
  final String subtitle;
  final String description;
  final String imagePath;
  final IconData icon;
  final bool large;
}

class _StepData {
  const _StepData(this.id, this.title, this.description, this.detail, this.icon);

  final String id;
  final String title;
  final String description;
  final String detail;
  final IconData icon;
}

class _PricingCardData {
  const _PricingCardData(this.name, this.price, this.description, this.features, this.popular);

  final String name;
  final String price;
  final String description;
  final List<String> features;
  final bool popular;
}
