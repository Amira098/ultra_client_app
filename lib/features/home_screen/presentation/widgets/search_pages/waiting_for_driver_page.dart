import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../generated/locale_keys.g.dart';

class WaitingForDriverPage extends StatefulWidget {
  final int tripId;
  final VoidCallback onDriverAccepted;
  final ScrollController controller;

  const WaitingForDriverPage({
    super.key,
    required this.tripId,
    required this.onDriverAccepted,
    required this.controller,
  });

  @override
  State<WaitingForDriverPage> createState() => _WaitingForDriverPageState();
}

class _WaitingForDriverPageState extends State<WaitingForDriverPage> {
  bool _navigated = false;

  void _handleStatus(String? status) {
    if (_navigated) return;

    debugPrint("🔥 CLIENT LISTENING trip status = $status");

    if (status == 'booked' || status == 'driver_arrived') {
      _navigated = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onDriverAccepted();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('trips')
          .doc(widget.tripId.toString())
          .snapshots(),
      builder: (context, snapshot) {
        debugPrint("📡 STREAM STATE = ${snapshot.connectionState}");

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final status = data['status'];
          _handleStatus(status);
        }

        return SingleChildScrollView(
          controller: widget.controller,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                LocaleKeys.Authentication_waitingForDriver.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                LocaleKeys.Authentication_waitingForDriverMessage.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}
