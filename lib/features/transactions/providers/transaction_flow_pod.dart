import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionFlowState {
  final int currentStep;
  final String recipient;
  final String amount;
  final String description;
  final String? selectedBank;
  final bool bankMatched;
  final String matchedBankName;
  final String matchedAccountName;
  final bool isTransfer;

  const TransactionFlowState({
    this.currentStep = 0,
    this.recipient = '',
    this.amount = '',
    this.description = '',
    this.selectedBank,
    this.bankMatched = false,
    this.matchedBankName = '',
    this.matchedAccountName = '',
    this.isTransfer = false,
  });

  TransactionFlowState copyWith({
    int? currentStep,
    String? recipient,
    String? amount,
    String? description,
    String? selectedBank,
    bool? bankMatched,
    String? matchedBankName,
    String? matchedAccountName,
    bool? isTransfer,
  }) {
    return TransactionFlowState(
      currentStep: currentStep ?? this.currentStep,
      recipient: recipient ?? this.recipient,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      selectedBank: selectedBank ?? this.selectedBank,
      bankMatched: bankMatched ?? this.bankMatched,
      matchedBankName: matchedBankName ?? this.matchedBankName,
      matchedAccountName: matchedAccountName ?? this.matchedAccountName,
      isTransfer: isTransfer ?? this.isTransfer,
    );
  }
}

class TransactionFlowPod extends Notifier<TransactionFlowState> {
  @override
  TransactionFlowState build() {
    return const TransactionFlowState();
  }

  void initialize({required bool isTransfer, String? initialAmount, String? initialRecipient}) {
    state = state.copyWith(
      isTransfer: isTransfer,
      amount: initialAmount ?? '',
      recipient: initialRecipient ?? '',
    );
  }

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void nextStep() {
    state = state.copyWith(currentStep: state.currentStep + 1);
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void updateRecipient(String recipient) {
    state = state.copyWith(recipient: recipient);
    _simulateLookup();
  }

  void updateAmount(String amount) {
    state = state.copyWith(amount: amount);
  }

  void updateDescription(String description) {
    state = state.copyWith(description: description);
  }

  void selectBank(String bank) {
    state = state.copyWith(selectedBank: bank, bankMatched: false, matchedAccountName: '');
    _simulateLookup();
  }

  void _simulateLookup() {
    if (state.isTransfer && state.recipient.length == 10) {
      // Simulate API call
      Future.delayed(const Duration(milliseconds: 600), () {
        // If state changed while waiting, ignore (simplification for mock)
        state = state.copyWith(
          bankMatched: true,
          matchedBankName: state.selectedBank ?? 'Nomba Bank',
          matchedAccountName: 'Kemi Balogun',
        );
      });
    } else if (state.isTransfer) {
      state = state.copyWith(bankMatched: false, matchedAccountName: '');
    }
  }
}

final transactionFlowProvider = NotifierProvider<TransactionFlowPod, TransactionFlowState>(
  TransactionFlowPod.new,
);
