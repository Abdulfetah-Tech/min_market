import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:min_market/data/market_store.dart';
import 'package:min_market/main.dart';
import 'package:min_market/models/product.dart';

void main() {
  testWidgets('MiniMarketApp smoke test renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MiniMarketApp());
    await tester.pump();

    // Verify that the title Mini Market is rendered
    expect(find.text('Mini Market'), findsOneWidget);

    // Verify shopping cart and add buttons are present
    expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  test('Product model serialization and copyWith', () {
    const product = Product(
      id: 'test_1',
      title: 'Test Item',
      price: 29.99,
      category: 'smartphones',
      description: 'A test product',
    );

    expect(product.id, 'test_1');
    expect(product.title, 'Test Item');
    expect(product.price, 29.99);

    final updated = product.copyWith(price: 35.0, title: 'Updated Item');
    expect(updated.id, 'test_1');
    expect(updated.title, 'Updated Item');
    expect(updated.price, 35.0);
    expect(updated.category, 'smartphones');

    final json = product.toJson();
    expect(json['title'], 'Test Item');
    expect(json['price'], 29.99);

    final fromJson = Product.fromJson({
      'id': 123,
      'title': 'JSON Item',
      'price': 49,
      'category': 'audio',
      'description': 'From JSON',
    });
    expect(fromJson.id, '123');
    expect(fromJson.price, 49.0);
  });

  test('MarketStore cart and products operations', () {
    MarketStore.clearCart();
    expect(MarketStore.cartCount, 0);
    expect(MarketStore.cartTotal, 0);

    const testProd = Product(
      id: 'test_cart_p',
      title: 'Cart Item',
      price: 15.5,
      category: 'clothing',
      description: 'Desc',
    );

    MarketStore.addToCart(testProd, 2);
    expect(MarketStore.cartCount, 2);
    expect(MarketStore.cartTotal, 31.0);

    MarketStore.addToCart(testProd, 1);
    expect(MarketStore.cartCount, 3);
    expect(MarketStore.cartTotal, 46.5);

    MarketStore.removeFromCart('test_cart_p');
    expect(MarketStore.cartCount, 0);
    expect(MarketStore.cartTotal, 0);
  });
}
