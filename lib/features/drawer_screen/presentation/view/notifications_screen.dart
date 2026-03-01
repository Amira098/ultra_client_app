import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../generated/locale_keys.g.dart';


class NotificationModel {
  final String title;
  final String subtitle;
  final String time;
  final String date;

  NotificationModel({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.date,
  });
}

class NotificationsScreen extends StatelessWidget {
  final List<NotificationModel> notifications = [
    NotificationModel(
      title: LocaleKeys.Authentication_paymentConfirm.tr(),
      subtitle: LocaleKeys.Authentication_loremIpsum.tr(),
      time: LocaleKeys.Authentication_minutesAgo.tr(args: ['15']),
      date: LocaleKeys.Authentication_today.tr(),
    ),
    NotificationModel(
      title: LocaleKeys.Authentication_paymentConfirm.tr(),
      subtitle: LocaleKeys.Authentication_loremIpsum.tr(),
      time: LocaleKeys.Authentication_minutesAgo.tr(args: ['25']),
      date: LocaleKeys.Authentication_today.tr(),
    ),
    NotificationModel(
      title: LocaleKeys.Authentication_paymentConfirm.tr(),
      subtitle: LocaleKeys.Authentication_loremIpsum.tr(),
      time: LocaleKeys.Authentication_minutesAgo.tr(args: ['25']),
      date: LocaleKeys.Authentication_today.tr(),
    ),
    NotificationModel(
      title: LocaleKeys.Authentication_paymentConfirm.tr(),
      subtitle: LocaleKeys.Authentication_loremIpsum.tr(),
      time: LocaleKeys.Authentication_minutesAgo.tr(args: ['15']),
      date: LocaleKeys.Authentication_yesterday.tr(),
    ),
    NotificationModel(
      title: LocaleKeys.Authentication_paymentConfirm.tr(),
      subtitle: LocaleKeys.Authentication_loremIpsum.tr(),
      time: LocaleKeys.Authentication_minutesAgo.tr(args: ['25']),
      date: LocaleKeys.Authentication_yesterday.tr(),
    ),
  ];

  NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.profile_Notification.tr(),
          style: const TextStyle(color: Colors.orange),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: _buildNotificationList(),
        ),
      ),
    );
  }

  List<Widget> _buildNotificationList() {
    List<Widget> notificationWidgets = [];
    String? currentDate;

    for (var notification in notifications) {
      if (notification.date != currentDate) {
        notificationWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              notification.date,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        );
        currentDate = notification.date;
      }

      notificationWidgets.add(_buildNotificationCard(
        title: notification.title,
        subtitle: notification.subtitle,
        time: notification.time,
        isToday: notification.date == LocaleKeys.Authentication_today.tr(),
      ));
    }

    return notificationWidgets;
  }

  Widget _buildNotificationCard({
    required String title,
    required String subtitle,
    required String time,
    required bool isToday,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isToday
            ? AppColors.amber.withOpacity(0.4)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isToday ? Colors.transparent : Colors.grey.withOpacity(0.3),
          width: 1,
        ),

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 5),
          Text(
            time,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
