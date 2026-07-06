import 'package:flutter_riverpod/flutter_riverpod.dart';
void main() {
  final provider = NotifierProvider<MyNotifier, int>(MyNotifier.new);
}
class MyNotifier extends Notifier<int> {
  @override
  int build() => 0;
}
