import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:hugeicons_pro/hugeicons.dart';

import 'package:saabi_mobile/features/transactions/ui/widgets/txn_tile.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key, this.initialSearchQuery});

  final String? initialSearchQuery;

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  late final TextEditingController _searchController;
  
  // Mock transactions based on home_tab
  final List<TxnData> _allTxns = [
    const TxnData(
      icon: HugeIconsStroke.arrowUpRight01,
      iconColor: Color(0xFFF44336),
      title: 'Transfer to Jane Doe',
      subtitle: 'Nomba Bank • 0123456789',
      amount: '-₦25,000',
      time: 'Today, 10:42 AM',
      isDebit: true,
    ),
    const TxnData(
      icon: HugeIconsStroke.arrowDown02,
      iconColor: Color(0xFF4CAF50),
      title: 'Received from Mama K',
      subtitle: 'Nomba Bank',
      amount: '+₦50,000',
      time: 'Yesterday, 3:14 PM',
      isDebit: false,
    ),
    const TxnData(
      icon: Icons.phone_android_rounded,
      iconColor: Color(0xFF2196F3),
      title: 'Airtime Purchase',
      subtitle: 'MTN • 0812 345 6789',
      amount: '-₦1,000',
      time: 'Jun 30, 8:00 AM',
      isDebit: true,
    ),
    const TxnData(
      icon: Icons.savings_rounded,
      iconColor: Color(0xFF9C27B0),
      title: 'Circle Contribution',
      subtitle: 'Market Traders Fund',
      amount: '-₦20,000',
      time: 'Jun 29, 9:05 AM',
      isDebit: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialSearchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TxnData> get _filteredTxns {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return _allTxns;

    return _allTxns.where((txn) {
      return txn.title.toLowerCase().contains(query) ||
          txn.subtitle.toLowerCase().contains(query) ||
          txn.amount.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final txns = _filteredTxns;

    return FScaffold(
      header: FHeader.nested(
        title: const Text('Transaction History'),
        prefixes: [FHeaderAction.back(onPress: () => Navigator.of(context).pop())],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ValueListenableBuilder(
              valueListenable: _searchController,
              builder: (context, _, __) {
                return FTextField(
                  control: FTextFieldControl.managed(
                    initial: TextEditingValue(text: _searchController.text),
                    onChange: (value) {
                      _searchController.text = value.text;
                      setState(() {});
                    }
                  ),
                  hint: 'Search transactions...',
                );
              },
            ),
          ),
          Expanded(
            child: txns.isEmpty
                ? Center(
                    child: Text(
                      'No transactions found.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: context.theme.colors.mutedForeground,
                          ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 40, top: 10),
                    itemCount: txns.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 0,
                      thickness: 0.5,
                      indent: 70,
                      color: context.theme.colors.border,
                    ),
                    itemBuilder: (context, index) {
                      return TxnTile(data: txns[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
