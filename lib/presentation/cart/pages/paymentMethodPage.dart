import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_shop/presentation/cart/bloc/OrderCubit.dart';
import 'package:online_shop/presentation/cart/bloc/PaymentMethodCubit.dart';
import 'package:online_shop/presentation/cart/pages/order_placed.dart';

class PaymentMethodPage extends StatelessWidget {
  final List<String> paymentMethods = [
    'Credit Card',
    'Bank Transfer',
    'Digital Wallet',
    'Cash on Delivery'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Choose Payment Method',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) => OrderCubit(),
        child: BlocProvider(
          create: (context) => PaymentMethodCubit(),
          child: PaymentMethodView(paymentMethods: paymentMethods),
        ),
      ),
    );
  }
}

class PaymentMethodView extends StatelessWidget {
  final List<String> paymentMethods;

  const PaymentMethodView({Key? key, required this.paymentMethods})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double totalAmount = 150000;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: paymentMethods.length,
            itemBuilder: (context, index) {
              final method = paymentMethods[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: BlocBuilder<PaymentMethodCubit, String>(
                  builder: (context, selectedMethod) {
                    final isSelected = method == selectedMethod;

                    return GestureDetector(
                      onTap: () {
                        context
                            .read<PaymentMethodCubit>()
                            .selectPaymentMethod(method);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.deepPurple.withOpacity(0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Colors.deepPurple
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: Colors.deepPurple.withOpacity(0.2),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: isSelected
                                  ? Colors.deepPurple
                                  : Colors.grey.shade400,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              method,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? Colors.deepPurple
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        // Detail Total Pembayaran
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 6,
                spreadRadius: 2,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Column(
            children: [
              // Total Pembayaran
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Payment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    'Rp ${totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Tombol Lanjutkan
              BlocBuilder<PaymentMethodCubit, String>(
                builder: (context, selectedMethod) {
                  return ElevatedButton(
                    onPressed: selectedMethod.isEmpty
                        ? null
                        : () {
                            context
                                .read<OrderCubit>()
                                .updatePaymentMethod(selectedMethod);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return OrderPlacedPage();
                            }));
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      disabledBackgroundColor: Colors.grey.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 32,
                      ),
                    ),
                    child: const Text(
                      'Continue Payment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
