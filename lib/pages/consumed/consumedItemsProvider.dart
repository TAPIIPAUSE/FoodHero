import 'package:flutter/material.dart';
import 'package:foodhero/widgets/consumed/consumed_list_item.dart';


class ConsumedItemsProvider with ChangeNotifier {
  List<ConsumedListItem> _consumedItems = [];

  List<ConsumedListItem> get consumedItems => _consumedItems;

  void addConsumedItem(ConsumedListItem item) {
    _consumedItems.add(item);
    notifyListeners();
  }
}