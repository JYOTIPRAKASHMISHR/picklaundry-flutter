import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get totalItems =>
      _items.fold(
        0,
        (sum, item) => sum + item.quantity,
      );

  double get totalPrice =>
      _items.fold(
        0,
        (sum, item) =>
            sum + (item.price * item.quantity),
      );

  void addToCart(CartItem cartItem) {

    int index = _items.indexWhere(
      (e) => e.itemId == cartItem.itemId,
    );

    if (index >= 0) {

      _items[index].quantity++;

    } else {

      _items.add(cartItem);
    }

    notifyListeners();
  }

  void increaseQuantity(int itemId) {

    int index =
        _items.indexWhere(
      (e) => e.itemId == itemId,
    );

    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(int itemId) {

    int index =
        _items.indexWhere(
      (e) => e.itemId == itemId,
    );

    if (index >= 0) {

      if (_items[index].quantity > 1) {

        _items[index].quantity--;

      } else {

        _items.removeAt(index);
      }

      notifyListeners();
    }
  }
}