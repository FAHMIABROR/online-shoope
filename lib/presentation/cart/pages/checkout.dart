import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_shop/common/bloc/button/button_state_cubit.dart';
import 'package:online_shop/common/helper/cart/cart.dart';
import 'package:online_shop/domain/order/entities/product_ordered.dart';
import 'package:online_shop/presentation/cart/pages/paymentMethodPage.dart';

import '../../../common/bloc/button/button_state.dart';

class CheckOutPage extends StatelessWidget {
  final List<ProductOrderedEntity> products;

  CheckOutPage({required this.products, super.key});

  final TextEditingController _addressCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Checkout',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF000000), // Black background
      body: BlocProvider(
        create: (context) => ButtonStateCubit(),
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) {
            if (state is ButtonFailureState) {
              var snackbar = SnackBar(
                content: Text(state.errorMessage),
                behavior: SnackBarBehavior.floating,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAddressSection(),
                _buildSummaryAndButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Address Input Section
  Widget _buildAddressSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C), // Dark gray card background
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Shipping Address',
            style: TextStyle(
              color: Colors.white, // White text
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _addressCon,
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Enter your address',
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF2C2C2C), // Input field dark gray
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: Colors.white), // Input text white
          ),
        ],
      ),
    );
  }

  /// Summary and Button Section
  Widget _buildSummaryAndButton(BuildContext context) {
    return Column(
      children: [
        _buildOrderSummary(),
        const SizedBox(height: 20),
        _buildGradientButton(
          context: context,
          label: 'Continue to Payment',
          icon: Icons.arrow_forward_ios,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentMethodPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Order Summary Section
  Widget _buildOrderSummary() {
    final totalPrice = CartHelper.calculateCartSubtotal(products);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C), // Dark gray card background
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total',
            style: TextStyle(
              color: Colors.white, // White text
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            '\$$totalPrice',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFFFFD700),
            ),
          ),
        ],
      ),
    );
  }

  /// Gradient Button Component
  Widget _buildGradientButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF007AFF), Color(0xFF1E90FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              icon,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
