
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/custom_button.dart';
import '../../../../core/utils/utils/customTextField.dart';
import '../../../../generated/locale_keys.g.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(LocaleKeys.Authentication_payment.tr(),
              style: const TextStyle(
                  color: Colors.orange, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/png/car.png",
                      width: 80,
                      height: 60,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(LocaleKeys.Authentication_allNewRush.tr(),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.orange, size: 16),
                            const SizedBox(width: 4),
                            Text(
                                '4.9 (${LocaleKeys.Authentication_reviews.tr(args: ['531'])})',
                                style: const TextStyle(color: Colors.grey)),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(LocaleKeys.Authentication_charge.tr(),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Text('\$5'),
                ],
              ),
              const SizedBox(height: 8),
              Text(LocaleKeys.Authentication_mustangPerHour.tr(),
                  style: const TextStyle(color: Colors.grey)),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(LocaleKeys.Authentication_total.tr(),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Text('\$5'),
                ],
              ),
              const SizedBox(height: 24),
              Text(LocaleKeys.Authentication_selectPaymentMethod.tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              paymentMethodTile(
                  Icons.credit_card,
                  LocaleKeys.Authentication_visa.tr(),
                  '**** **** **** 8970',
                  LocaleKeys.Authentication_expires.tr(args: ['12/26']),
                  true),
              paymentMethodTile(
                  Icons.email,
                  LocaleKeys.Authentication_paypal.tr(),
                  'mailaddress@mail.com',
                  LocaleKeys.Authentication_expires.tr(args: ['12/26']),
                  false),
              paymentMethodTile(
                  Icons.money,
                  LocaleKeys.Authentication_cash.tr(),
                  '',
                  LocaleKeys.Authentication_expires.tr(args: ['12/26']),
                  false),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 88),
                child: CommonTextFormField(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  controller: TextEditingController(),
                  hint: LocaleKeys.Authentication_usePromoCode.tr(),
                ),
              ),
              const Spacer(),
              CustomButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  text: LocaleKeys.Authentication_confirmRide.tr())
            ],
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget paymentMethodTile(IconData icon, String title, String subtitle, String expiry, bool selected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: selected ? Colors.orange.withOpacity(0.2) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: selected ? Colors.orange : Colors.transparent),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                if (subtitle.isNotEmpty)
                  Text(subtitle, style: const TextStyle(color: Colors.black54)),
                Text(expiry, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
