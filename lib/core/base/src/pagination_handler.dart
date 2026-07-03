// import 'dart:async';

// import 'package:flutter/foundation.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

// abstract mixin class PaginationHandler<ItemType> {
//   late final PagingController<int, ItemType> pagingController = PagingController(
//     getNextPageKey: getNextPageKey,
//     fetchPage: fetchPage,
//   );

//   FutureOr<List<ItemType>> fetchPage(int? page);

//   int? getNextPageKey(PagingState<int, ItemType> state) => state.lastPageIsEmpty ? null : state.nextIntPageKey;

//   void refresh() {
//     pagingController.refresh();
//     if (!pagingController.isLoading) pagingController.fetchNextPage();
//   }

//   @mustCallSuper
//   void dispose() => pagingController.dispose();
// }
