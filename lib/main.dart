import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Sandwich Shop App',
      home: OrderScreen(maxQuantity: 5),
    );
  }
}

// Robust, non-null type for selection
enum SandwichType { footlong, sixInch }

extension SandwichTypeLabel on SandwichType {
  String get label => switch (this) {
        SandwichType.footlong => 'Footlong',
        SandwichType.sixInch => 'Six-inch',
      };
}

class OrderScreen extends StatefulWidget {
  final int maxQuantity;
  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0;
  SandwichType _type = SandwichType.footlong; // non-null by design

  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) setState(() => _quantity++);
  }

  void _decreaseQuantity() {
    if (_quantity > 0) setState(() => _quantity--);
  }

  @override
  Widget build(BuildContext context) {
    final canRemove = _quantity > 0;
    final canAdd = _quantity < widget.maxQuantity;

    return Scaffold(
      backgroundColor: const Color(0xFFF9ECF3),
      appBar: AppBar(title: const Text('Sandwich Counter')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OrderItemDisplay(_quantity, _type.label),

              const SizedBox(height: 8),
              Text('Max: ${widget.maxQuantity}',
                  style: Theme.of(context).textTheme.bodySmall),

              const SizedBox(height: 16),

              // Size selector using enum = no nulls
              SegmentedButton<SandwichType>(
                segments: const [
                  ButtonSegment(
                    value: SandwichType.footlong,
                    label: Text('Footlong'),
                  ),
                  ButtonSegment(
                    value: SandwichType.sixInch,
                    label: Text('Six-inch'),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (sel) {
                  // sel is a Set<SandwichType> and will have exactly 1 element
                  setState(() => _type = sel.first);
                },
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StyledButton(
                    text: 'Remove',
                    icon: Icons.remove,
                    onPressed: canRemove ? _decreaseQuantity : null,
                    backgroundColor: Colors.black,
                  ),
                  StyledButton(
                    text: 'Add',
                    icon: Icons.add,
                    onPressed: canAdd ? _increaseQuantity : null,
                    backgroundColor: Colors.pink,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;

  const OrderItemDisplay(this.quantity, this.itemType, {super.key});

  @override
  Widget build(BuildContext context) {
    // Build the emoji string safely
    final emoji = List.filled(quantity, '🥪').join();
    return Text(
      '$quantity $itemType sandwich(es): $emoji',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// Reusable styled button
class StyledButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onPressed; // null => disabled
  final Color backgroundColor;

  const StyledButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        disabledBackgroundColor: Colors.grey.shade300,
        disabledForegroundColor: Colors.grey.shade600,
      ),
    );
  }
}
