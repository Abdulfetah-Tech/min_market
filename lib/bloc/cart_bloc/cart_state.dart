part of 'cart_bloc.dart';

abstract class CartState {}

final class CartInitial extends CartState {}

final class CartLoaded extends CartState {
  final List<CartItem> items;

  CartLoaded(this.items);

  int get count {
    int itemCount = 0;

    for (var item in items) {
      itemCount += item.quantity;
    }

    return itemCount;
  }

  double get total {
    double sum = 0;
    for (var item in items) {
      sum += item.total;
    }
    return sum;
  }
}
