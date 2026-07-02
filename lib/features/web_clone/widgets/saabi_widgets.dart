import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app.dart';
import '../theme/saabi_theme.dart';

class SaabiNavbar extends StatefulWidget {
  const SaabiNavbar({super.key, required this.onNavigate, required this.activePage});

  final void Function(SaabiPage page) onNavigate;
  final SaabiPage activePage;

  @override
  State<SaabiNavbar> createState() => _SaabiNavbarState();
}

class _SaabiNavbarState extends State<SaabiNavbar> {
  bool _isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: SaabiTheme.cardBg.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 30, offset: const Offset(0, 18)),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => widget.onNavigate(SaabiPage.landing),
                  child: Text(
                    'SAABI',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: SaabiTheme.accent,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      letterSpacing: -1.5,
                    ),
                  ),
                ),
                const Spacer(),
                if (MediaQuery.of(context).size.width >= 700)
                  _DesktopNav(activePage: widget.activePage, onNavigate: widget.onNavigate)
                else
                  IconButton(
                    onPressed: () => setState(() => _isMenuOpen = !_isMenuOpen),
                    icon: Icon(_isMenuOpen ? Icons.close : Icons.menu),
                  ),
              ],
            ),
          ),
          if (_isMenuOpen && MediaQuery.of(context).size.width < 700)
            Positioned(
              left: 0,
              right: 0,
              top: 70,
              child: Container(
                decoration: BoxDecoration(
                  color: SaabiTheme.cardBg.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _NavEntry(
                      label: 'Home',
                      isActive: widget.activePage == SaabiPage.landing,
                      onTap: () {
                        widget.onNavigate(SaabiPage.landing);
                        setState(() => _isMenuOpen = false);
                      },
                    ),
                    const SizedBox(height: 12),
                    _NavEntry(
                      label: 'Investment',
                      isActive: widget.activePage == SaabiPage.investment,
                      onTap: () {
                        widget.onNavigate(SaabiPage.investment);
                        setState(() => _isMenuOpen = false);
                      },
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: SaabiTheme.accent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        widget.onNavigate(SaabiPage.dashboard);
                        setState(() => _isMenuOpen = false);
                      },
                      child: const Text('Launch App'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DesktopNav extends StatelessWidget {
  const _DesktopNav({required this.activePage, required this.onNavigate});

  final SaabiPage activePage;
  final void Function(SaabiPage page) onNavigate;

  @override
  Widget build(BuildContext context) {
    TextStyle itemStyle(bool active) => Theme.of(context).textTheme.labelLarge!.copyWith(
      color: active ? SaabiTheme.accent : Colors.white.withValues(alpha: 0.45),
      fontWeight: FontWeight.w800,
      letterSpacing: 1.4,
    );

    return Row(
      children: [
        TextButton.icon(
          onPressed: () => onNavigate(SaabiPage.landing),
          icon: const Icon(Icons.account_balance_wallet_outlined, size: 16),
          label: Text('Home', style: itemStyle(activePage == SaabiPage.landing)),
        ),
        const SizedBox(width: 12),
        TextButton.icon(
          onPressed: () => onNavigate(SaabiPage.investment),
          icon: const Icon(Icons.trending_up, size: 16),
          label: Text('Investment', style: itemStyle(activePage == SaabiPage.investment)),
        ),
        const SizedBox(width: 20),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            shape: const StadiumBorder(),
          ),
          onPressed: () => onNavigate(SaabiPage.dashboard),
          child: const Text('DASHBOARD', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.1)),
        ),
      ],
    );
  }
}

class _NavEntry extends StatelessWidget {
  const _NavEntry({required this.label, required this.isActive, required this.onTap});

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: isActive ? SaabiTheme.accent : Colors.white70,
        side: BorderSide(
          color: isActive ? SaabiTheme.accent.withValues(alpha: 0.35) : Colors.white.withValues(alpha: 0.08),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}

class HeroFooter extends StatelessWidget {
  const HeroFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 64),
      decoration: BoxDecoration(
        color: SaabiTheme.darkBg,
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: Column(
        children: [
          Text(
            'SAABI',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: SaabiTheme.accent.withValues(alpha: 0.3),
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              letterSpacing: -4,
              fontSize: 96,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Designing the experiences that build nations.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white.withValues(alpha: 0.7)),
          ),
          const SizedBox(height: 10),
          Text(
            'Empowering Nigeria\'s informal economy through distributed payments and AI-driven service discovery.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.3)),
          ),
          const SizedBox(height: 40),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              _FooterLink(title: 'Payments'),
              _FooterLink(title: 'Discovery'),
              _FooterLink(title: 'Analytics'),
              _FooterLink(title: 'Verification'),
            ],
          ),
          const SizedBox(height: 28),
          Text(
            'SAABI  © $year  SQUAD • LAGOS',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.18),
              fontWeight: FontWeight.w800,
              letterSpacing: 2.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white.withValues(alpha: 0.32)),
    );
  }
}

class FloatingWhatsAppButton extends StatelessWidget {
  const FloatingWhatsAppButton({super.key});

  Future<void> _openWhatsApp() async {
    final uri = Uri.parse('https://wa.me/2348086609436');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 24,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(color: SaabiTheme.accent, borderRadius: BorderRadius.circular(999)),
            child: Text(
              'Chat with SAABI',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.6),
            ),
          ),
          InkWell(
            onTap: _openWhatsApp,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: SaabiTheme.accent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: SaabiTheme.accent.withValues(alpha: 0.45), blurRadius: 28, spreadRadius: 2),
                ],
              ),
              child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginModal extends StatefulWidget {
  const LoginModal({super.key, required this.onClose, required this.onSuccess});

  final VoidCallback onClose;
  final VoidCallback onSuccess;

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  final TextEditingController _emailController = TextEditingController();
  bool _magicLinkSent = false;
  bool _loading = false;
  String? _errorText;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleOAuthLogin() async {
    setState(() {
      _loading = true;
      _errorText = null;
    });
    await Future<void>.delayed(const Duration(milliseconds: 700));
    widget.onSuccess();
    setState(() {
      _loading = false;
    });
  }

  Future<void> _handleEmailLogin() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _errorText = 'Enter an email address.');
      return;
    }

    setState(() {
      _loading = true;
      _errorText = null;
    });

    await Future<void>.delayed(const Duration(milliseconds: 500));
    widget.onSuccess();

    setState(() {
      _magicLinkSent = true;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.black.withValues(alpha: 0.82),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0A0A),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.6), blurRadius: 40, offset: const Offset(0, 24)),
                ],
              ),
              child: _magicLinkSent ? _buildSuccess(context) : _buildForm(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccess(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(onPressed: widget.onClose, icon: const Icon(Icons.close)),
        ),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green.withValues(alpha: 0.18),
            border: Border.all(color: Colors.green.withValues(alpha: 0.28)),
          ),
          child: const Icon(Icons.mail_outline, color: Colors.green, size: 40),
        ),
        const SizedBox(height: 18),
        Text(
          'Check Your Email',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        Text(
          'We\'ve sent a magic login link to\n${_emailController.text.trim()}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.6)),
        ),
        const SizedBox(height: 22),
        FilledButton(
          onPressed: widget.onClose,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: const Text('Close Window'),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(onPressed: widget.onClose, icon: const Icon(Icons.close)),
        ),
        Text(
          'SAABI',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: SaabiTheme.accent,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Welcome to SAABI',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        Text(
          'Login to access your personalized Dashboard',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.5)),
        ),
        if (_errorText != null) ...[
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
            ),
            child: Text(
              _errorText!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _loading ? null : _handleOAuthLogin,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF24292E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            icon: const Icon(Icons.code),
            label: const Text('Continue with GitHub'),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.1))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Or continue with email',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white.withValues(alpha: 0.35)),
              ),
            ),
            Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.1))),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'name@example.com',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
            prefixIcon: const Icon(Icons.mail_outline),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: SaabiTheme.accent),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _loading ? null : _handleEmailLogin,
            style: FilledButton.styleFrom(
              backgroundColor: SaabiTheme.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('Send Magic Link'), SizedBox(width: 8), Icon(Icons.arrow_forward, size: 18)],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'By continuing, you agree to SAABI\'s Terms of Service and Privacy Policy. Secure authentication provided by Supabase.',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: Colors.white.withValues(alpha: 0.4), height: 1.4),
        ),
      ],
    );
  }
}

class DecorativeGlow extends StatelessWidget {
  const DecorativeGlow({super.key, required this.size, required this.color, required this.alignment});

  final double size;
  final Color color;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [BoxShadow(color: color, blurRadius: size / 3)],
        ),
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  const SectionCard({super.key, required this.child, this.padding, this.radius = 32, this.margin, this.maxHeight});

  final Widget child;
  final EdgeInsets? padding;
  final double radius;
  final EdgeInsets? margin;
  final double? maxHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(24),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width < 600 ? double.infinity : 600,
        maxHeight: (maxHeight == 0 ? null : 420) ?? double.infinity,
      ),
      decoration: BoxDecoration(
        color: SaabiTheme.cardBg.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 24, offset: const Offset(0, 14))],
      ),
      child: child,
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    required this.highlight,
    required this.subtitle,
    this.center = false,
  });

  final String title;
  final String highlight;
  final String subtitle;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final titleWidget = RichText(
      textAlign: center ? TextAlign.center : TextAlign.start,
      text: TextSpan(
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, height: 1.0),
        children: [
          TextSpan(text: title),
          TextSpan(
            text: highlight,
            style: const TextStyle(
              color: SaabiTheme.accent,
              shadows: [Shadow(color: Color(0x66E45D00), blurRadius: 24)],
            ),
          ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        titleWidget,
        const SizedBox(height: 14),
        Text(
          subtitle,
          textAlign: center ? TextAlign.center : TextAlign.start,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.white.withValues(alpha: 0.4), height: 1.5),
        ),
      ],
    );
  }
}

class ImageSectionCard extends StatelessWidget {
  const ImageSectionCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
  });

  final String imagePath;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      radius: 36,
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: Stack(
          children: [
            Positioned.fill(child: Image.asset(imagePath, fit: BoxFit.cover)),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.9),
                      Colors.black.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: SaabiTheme.accent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                      ),
                      child: Icon(icon, color: SaabiTheme.accent),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      subtitle.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: SaabiTheme.accent,
                        letterSpacing: 2.4,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.7), height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneMockCard extends StatelessWidget {
  const PhoneMockCard({super.key, required this.messages, required this.statusLabel});

  final List<ChatBubbleData> messages;
  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      radius: 28,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(color: SaabiTheme.accent, shape: BoxShape.circle),
                child: const Center(
                  child: Text('S', style: TextStyle(fontWeight: FontWeight.w900)),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SAABI Bot', style: TextStyle(fontWeight: FontWeight.w800)),
                    SizedBox(height: 2),
                    Text(
                      'Online',
                      style: TextStyle(
                        color: SaabiTheme.accent,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...messages.map(
            (message) => Padding(
              padding: EdgeInsets.only(left: message.isUser ? 44 : 0, right: message.isUser ? 0 : 44, bottom: 10),
              child: Align(
                alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? SaabiTheme.accent.withValues(alpha: 0.18)
                        : Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(message.isUser ? 18 : 4),
                      bottomRight: Radius.circular(message.isUser ? 4 : 18),
                    ),
                    border: Border.all(
                      color: message.isUser
                          ? SaabiTheme.accent.withValues(alpha: 0.18)
                          : Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    message.text,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: message.isUser ? Colors.white : Colors.white.withValues(alpha: 0.65),
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Text('Type...', style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 10)),
                const Spacer(),
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: SaabiTheme.accent,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Icon(Icons.send, size: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              statusLabel,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.25),
                letterSpacing: 4.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubbleData {
  const ChatBubbleData(this.text, {required this.isUser});
  final String text;
  final bool isUser;
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.value,
    required this.label,
    required this.detail,
    required this.emphasis,
    this.icon,
  });

  final String value;
  final String label;
  final String detail;
  final bool emphasis;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      radius: 28,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: emphasis ? SaabiTheme.accent : Colors.white.withValues(alpha: 0.7)),
            const SizedBox(height: 18),
          ],
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: emphasis ? SaabiTheme.accent : Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(
            detail,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.4)),
          ),
        ],
      ),
    );
  }
}

class ProgressBarRow extends StatelessWidget {
  const ProgressBarRow({super.key, required this.label, required this.value, required this.color});

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.7)),
              ),
            ),
            Text(
              '${(value * 100).round()}%',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

class RoiRing extends StatelessWidget {
  const RoiRing({super.key, required this.percent, required this.centerLabel, required this.centerValue});

  final double percent;
  final String centerLabel;
  final String centerValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: 170,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(size: const Size(170, 170), painter: _RoiRingPainter(percent)),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                centerLabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.8,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                centerValue,
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, color: SaabiTheme.accent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoiRingPainter extends CustomPainter {
  _RoiRingPainter(this.percent);

  final double percent;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = 14.0;
    final rect = Rect.fromLTWH(stroke / 2, stroke / 2, size.width - stroke, size.height - stroke);
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = Colors.white.withValues(alpha: 0.06);
    final fgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(colors: [SaabiTheme.accent, Color(0xFFFFB15A)]).createShader(rect);
    canvas.drawArc(rect, math.pi * 1.25, math.pi * 1.5, false, bgPaint);
    canvas.drawArc(rect, math.pi * 1.25, math.pi * 1.5 * percent, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant _RoiRingPainter oldDelegate) => oldDelegate.percent != percent;
}
