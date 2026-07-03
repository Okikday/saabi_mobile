import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:go_router/go_router.dart';

/// Multi-step form to create a new savings circle.
class CreateRoundView extends StatefulWidget {
  const CreateRoundView({super.key});

  @override
  State<CreateRoundView> createState() => _CreateRoundViewState();
}

class _CreateRoundViewState extends State<CreateRoundView> {
  int _step = 0;
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String _frequency = 'Weekly';
  int _memberCount = 5;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _next() => setState(() => _step = (_step + 1).clamp(0, 2));
  void _prev() {
    if (_step > 0) {
      setState(() => _step--);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: FHeader.nested(
        title: const Text('Create Circle'),
        prefixes: [FHeaderAction.back(onPress: _prev)],
      ),
      child: Column(
        children: [
          // Progress indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: List.generate(3, (i) {
                final active = i <= _step;
                return Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 4,
                    margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                    decoration: BoxDecoration(
                      color: active ? context.theme.colors.primary : context.theme.colors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: KeyedSubtree(
                  key: ValueKey(_step),
                  child: switch (_step) {
                    0 => _StepCircleInfo(nameController: _nameController),
                    1 => _StepContribution(
                        amountController: _amountController,
                        frequency: _frequency,
                        onFrequencyChanged: (v) => setState(() => _frequency = v),
                        memberCount: _memberCount,
                        onMemberCountChanged: (v) => setState(() => _memberCount = v),
                      ),
                    _ => _StepReview(
                        name: _nameController.text.isEmpty ? 'My Circle' : _nameController.text,
                        amount: _amountController.text.isEmpty ? '0' : _amountController.text,
                        frequency: _frequency,
                        memberCount: _memberCount,
                      ),
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            child: SizedBox(
              width: double.infinity,
              child: FButton(
                onPress: _step < 2 ? _next : () => context.pop(),
                child: Text(_step < 2 ? 'Continue' : 'Create Circle'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCircleInfo extends StatelessWidget {
  const _StepCircleInfo({required this.nameController});
  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name your circle', style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: context.theme.colors.foreground, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text('Give your savings circle a memorable name.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: context.theme.colors.mutedForeground)),
        const SizedBox(height: 32),
        FTextField(
          control: FTextFieldControl.managed(
            initial: TextEditingValue(text: nameController.text),
            onChange: (v) => nameController.text = v.text,
          ),
          label: const Text('Circle Name'),
          hint: 'e.g. Market Traders Fund',
        ),
        const SizedBox(height: 24),
        Text('Popular names', style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: context.theme.colors.mutedForeground, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['Market Women Ajo', 'NextGen Savers', 'Family Fund', 'Hustle Circle']
              .map((name) => GestureDetector(
                    onTap: () => nameController.text = name,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: context.theme.colors.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: context.theme.colors.border),
                      ),
                      child: Text(name, style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: context.theme.colors.foreground)),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _StepContribution extends StatelessWidget {
  const _StepContribution({
    required this.amountController,
    required this.frequency,
    required this.onFrequencyChanged,
    required this.memberCount,
    required this.onMemberCountChanged,
  });

  final TextEditingController amountController;
  final String frequency;
  final ValueChanged<String> onFrequencyChanged;
  final int memberCount;
  final ValueChanged<int> onMemberCountChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Set contribution', style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: context.theme.colors.foreground, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text('How much will each member contribute per cycle?', style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: context.theme.colors.mutedForeground)),
        const SizedBox(height: 32),
        FTextField(
          control: FTextFieldControl.managed(
            initial: TextEditingValue(text: amountController.text),
            onChange: (v) => amountController.text = v.text,
          ),
          label: const Text('Contribution Amount (₦)'),
          hint: 'e.g. 10,000',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),
        Text('Frequency', style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: context.theme.colors.foreground, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Row(
          children: ['Weekly', 'Bi-Weekly', 'Monthly'].map((f) {
            final selected = frequency == f;
            return Expanded(
              child: GestureDetector(
                onTap: () => onFrequencyChanged(f),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: f != 'Monthly' ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? context.theme.colors.primary : context.theme.colors.card,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: selected ? context.theme.colors.primary : context.theme.colors.border),
                  ),
                  child: Text(f, style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: selected ? context.theme.colors.primaryForeground : context.theme.colors.foreground,
                    fontWeight: FontWeight.w600)),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Text('Number of Members: $memberCount', style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: context.theme.colors.foreground, fontWeight: FontWeight.w600)),
        Material(
          color: Colors.transparent,
          child: Slider(
            value: memberCount.toDouble(),
            min: 2,
            max: 20,
            divisions: 18,
            activeColor: context.theme.colors.primary,
            onChanged: (v) => onMemberCountChanged(v.round()),
          ),
        ),
      ],
    );
  }
}

class _StepReview extends StatelessWidget {
  const _StepReview({required this.name, required this.amount, required this.frequency, required this.memberCount});

  final String name;
  final String amount;
  final String frequency;
  final int memberCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Review your circle', style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: context.theme.colors.foreground, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text('Everything look good? Confirm and create.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: context.theme.colors.mutedForeground)),
        const SizedBox(height: 32),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: context.theme.colors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.theme.colors.border),
          ),
          child: Column(
            children: [
              _ReviewRow(label: 'Circle Name', value: name),
              _ReviewRow(label: 'Contribution', value: '₦$amount $frequency'),
              _ReviewRow(label: 'Members', value: '$memberCount members'),
              _ReviewRow(label: 'Pot Size', value: '₦${(int.tryParse(amount.replaceAll(',', '')) ?? 0) * memberCount}'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.theme.colors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.theme.colors.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded, color: context.theme.colors.primary, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Contributions are automatically collected on each cycle date via Nomba.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.theme.colors.mutedForeground),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: context.theme.colors.mutedForeground)),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: context.theme.colors.foreground, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
