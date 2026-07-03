import 'package:flutter/material.dart';

import '../theme/saabi_theme.dart';
import '../widgets/saabi_widgets.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.userSignedIn});

  final bool userSignedIn;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
      physics: const ClampingScrollPhysics(),
      children: [
        Text(
          userSignedIn ? 'Welcome back, SAABI user' : 'Dashboard preview',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(
          'A mobile-first clone of the analytics and workflow shell from the web app.',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white.withOpacity(0.45)),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _ActionChip(label: 'Search Workers', icon: Icons.search),
            _ActionChip(label: 'Register Provider', icon: Icons.person_add_alt_1),
            _ActionChip(label: 'Send Money', icon: Icons.send),
            _ActionChip(label: 'Virtual Account', icon: Icons.account_balance),
          ],
        ),
        const SizedBox(height: 20),
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: MediaQuery.of(context).size.width > 700 ? 4 : 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          shrinkWrap: true,
          childAspectRatio: 1.25,
          children: const [
            MetricCard(value: '₦142,500', label: 'Total Transactions', detail: '+12.5% from last month', emphasis: true, icon: Icons.account_balance_wallet_outlined),
            MetricCard(value: '24', label: 'WhatsApp Chats', detail: '+5.2% from last month', emphasis: false, icon: Icons.chat_bubble_outline),
            MetricCard(value: '12', label: 'Service Searches', detail: '-2.1% from last month', emphasis: false, icon: Icons.search),
            MetricCard(value: '3', label: 'Active Requests', detail: '+1 from last week', emphasis: false, icon: Icons.bolt),
          ],
        ),
        const SizedBox(height: 20),
        SectionCard(
          radius: 32,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Monthly Activity', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 18),
              const _SimpleBarChart(values: [0.44, 0.52, 0.38, 0.66, 0.59, 0.92]),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          radius: 32,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Credibility Score', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 20),
              const Center(child: RoiRing(percent: 0.85, centerLabel: 'SCORE', centerValue: '85%')),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          radius: 32,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('LGA Heatmap', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: const [
                  _HeatChip('Ikeja', 0.90),
                  _HeatChip('Yaba', 0.75),
                  _HeatChip('Lekki', 0.85),
                  _HeatChip('Surulere', 0.60),
                  _HeatChip('Oshodi', 0.45),
                  _HeatChip('Ajah', 0.40),
                  _HeatChip('Victoria Island', 0.95),
                  _HeatChip('Ikorodu', 0.30),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          radius: 32,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('WhatsApp History', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              const _HistoryTile(title: 'Sent ₦5,000 to Baba Tolu', subtitle: 'Today, 10:45 AM', status: 'Completed', accent: SaabiTheme.accent),
              const _HistoryTile(title: 'Found 3 Electricians in Ikeja', subtitle: 'Yesterday, 2:15 PM', status: 'Resolved', accent: Colors.blueAccent),
              const _HistoryTile(title: 'Received ₦15,000 from Client Opay', subtitle: 'Yesterday, 9:00 AM', status: 'Completed', accent: Colors.green),
              const _HistoryTile(title: 'Failed transfer to Quick Fix', subtitle: 'May 10, 4:20 PM', status: 'Failed', accent: Colors.redAccent),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          radius: 32,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Service Discovery', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 16),
              _DiscoveryTile(name: 'Baba Tolu', category: 'Plumbing', rate: '₦5,000/hr', lga: 'Ikeja', rating: '5.0'),
              const SizedBox(height: 12),
              _DiscoveryTile(name: 'Quick Fix Electric', category: 'Electrical', rate: '₦4,000/hr', lga: 'Yaba', rating: '4.8'),
              const SizedBox(height: 12),
              _DiscoveryTile(name: 'Mama Nkechi', category: 'Food Delivery', rate: '₦2,500/meal', lga: 'Lekki', rating: '4.9'),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: Colors.white.withOpacity(0.05),
      side: BorderSide(color: Colors.white.withOpacity(0.08)),
      avatar: Icon(icon, size: 18, color: SaabiTheme.accent),
      label: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }
}

class _SimpleBarChart extends StatelessWidget {
  const _SimpleBarChart({required this.values});

  final List<double> values;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final value in values)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 160 * value,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(colors: [SaabiTheme.accent, Color(0xFFFFB15A)], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(height: 4, width: 12, decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(999))),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HeatChip extends StatelessWidget {
  const _HeatChip(this.label, this.value);

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: SaabiTheme.accent.withOpacity(0.1 + value * 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: SaabiTheme.accent.withOpacity(0.1 + value * 0.18)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.title, required this.subtitle, required this.status, required this.accent});

  final String title;
  final String subtitle;
  final String status;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: accent.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
        child: Icon(Icons.circle, color: accent, size: 16),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.4))),
      trailing: Text(status, style: TextStyle(color: accent, fontWeight: FontWeight.w900, fontSize: 11)),
    );
  }
}

class _DiscoveryTile extends StatelessWidget {
  const _DiscoveryTile({required this.name, required this.category, required this.rate, required this.lga, required this.rating});

  final String name;
  final String category;
  final String rate;
  final String lga;
  final String rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: SaabiTheme.accent.withOpacity(0.12), borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.person, color: SaabiTheme.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('$category • $lga', style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(rate, style: const TextStyle(fontWeight: FontWeight.w900, color: SaabiTheme.accent)),
              const SizedBox(height: 4),
              Text('★ $rating', style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
