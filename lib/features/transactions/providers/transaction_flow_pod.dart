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

  void initialize({
    required bool isTransfer,
    String? initialRecipient,
    String? initialAmount,
  }) {
    state = state.copyWith(
      isTransfer: isTransfer,
      recipient: initialRecipient ?? '',
      amount: initialAmount ?? '',
    );
  }

  void updateRecipient(String value) {
    state = state.copyWith(recipient: value);
    _simulateLookup();
  }

  void updateAmount(String value) {
    state = state.copyWith(amount: value);
  }

  void updateDescription(String value) {
    state = state.copyWith(description: value);
  }

  void selectBank(String bank) {
    state = state.copyWith(selectedBank: bank);
    _simulateLookup();
  }

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void nextStep() {
    if (state.currentStep < 2) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void prevStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void _simulateLookup() {
    // Basic validation
    if (state.recipient.length >= 10 && (!state.isTransfer || state.selectedBank != null)) {
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

final transactionFlowProvider = NotifierProvider.autoDispose<TransactionFlowPod, TransactionFlowState>(
  TransactionFlowPod.new,
);
