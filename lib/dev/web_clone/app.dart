import 'package:flutter/material.dart';

import 'pages/dashboard_page.dart';
import 'pages/investment_page.dart';
import 'pages/landing_page.dart';
import 'theme/saabi_theme.dart';
import 'widgets/saabi_widgets.dart';

enum SaabiPage { landing, dashboard, investment }

class SaabiApp extends StatelessWidget {
  const SaabiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, theme: SaabiTheme.dark(), home: const SaabiShell());
  }
}

class SaabiShell extends StatefulWidget {
  const SaabiShell({super.key});

  @override
  State<SaabiShell> createState() => _SaabiShellState();
}

class _SaabiShellState extends State<SaabiShell> {
  SaabiPage _currentPage = SaabiPage.landing;
  bool _showLoginModal = false;
  bool _loginComplete = false;
  SaabiPage? _pendingPage;
  bool _showFloatingWhatsApp = false;

  void _navigateTo(SaabiPage page) {
    if (page == SaabiPage.dashboard && !_loginComplete) {
      setState(() {
        _pendingPage = page;
        _showLoginModal = true;
      });
      return;
    }

    setState(() {
      _currentPage = page;
    });
  }

  void _onLoginSuccess() {
    setState(() {
      _showLoginModal = false;
      _loginComplete = true;
      if (_pendingPage != null) {
        _currentPage = _pendingPage!;
      }
      _pendingPage = null;
    });
  }

  void _onScroll(ScrollNotification notification) {
    if (notification.metrics.axis == Axis.vertical) {
      final visible = notification.metrics.pixels > 500;
      if (visible != _showFloatingWhatsApp) {
        setState(() {
          _showFloatingWhatsApp = visible;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = switch (_currentPage) {
      SaabiPage.landing => LandingPage(onNavigate: _navigateTo),
      SaabiPage.dashboard => DashboardPage(userSignedIn: _loginComplete),
      SaabiPage.investment => InvestmentPage(),
    };

    return Scaffold(
      backgroundColor: SaabiTheme.darkBg,
      body: Stack(
        children: [
          const _GlowBackdrop(),
          CustomScrollView(
            slivers: [
              PinnedHeaderSliver(
                child: SaabiNavbar(activePage: _currentPage, onNavigate: _navigateTo),
              ),
              SliverToBoxAdapter(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    _onScroll(notification);
                    return false;
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: KeyedSubtree(key: ValueKey(_currentPage), child: body),
                  ),
                ),
              ),
              if (_currentPage == SaabiPage.landing) SliverToBoxAdapter(child: const HeroFooter()),
            ],
          ),
          if (_showFloatingWhatsApp) const FloatingWhatsAppButton(),
          if (_showLoginModal)
            LoginModal(
              onClose: () {
                setState(() {
                  _showLoginModal = false;
                  _pendingPage = null;
                });
              },
              onSuccess: _onLoginSuccess,
            ),
        ],
      ),
    );
  }
}

class _GlowBackdrop extends StatelessWidget {
  const _GlowBackdrop();

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: Stack(
        children: [
          DecorativeGlow(size: 500, color: Color(0x1AE45D00), alignment: Alignment.topLeft),
          DecorativeGlow(size: 500, color: Color(0x0DE45D00), alignment: Alignment.bottomRight),
        ],
      ),
    );
  }
}
