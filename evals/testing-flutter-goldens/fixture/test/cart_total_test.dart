import 'package:flutter_test/flutter_test.dart';
import 'package:shop/cart.dart';

void main() {
  test('total sums line items', () {
    final cart = Cart([LineItem(price: 250, quantity: 2), LineItem(price: 100, quantity: 1)]);
    expect(cart.totalCents, 600);
  });
}
