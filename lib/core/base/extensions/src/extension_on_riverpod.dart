import 'package:flutter_riverpod/flutter_riverpod.dart';

extension ExtOnAsyncValue on AsyncValue<List> {
  bool isEmpty() => this is! AsyncLoading && value != null && value!.isEmpty;
  bool isLoading() => this is AsyncLoading;
}
