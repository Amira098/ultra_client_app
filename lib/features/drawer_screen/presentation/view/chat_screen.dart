import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/utils/custom_icon_button.dart';
import '../../../../generated/locale_keys.g.dart';


class ChatScreen extends StatefulWidget {
  final String rideId;         // ID الرحلة الحالي
  final String currentUserId;  // معرف المستخدم الحالي
  final String senderType;     // client أو driver

  const ChatScreen({
    super.key,
    required this.rideId,
    required this.currentUserId,
    required this.senderType,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final messageData = {
      'message': text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
      'senderId': widget.currentUserId,
      'senderType': widget.senderType, // "client" or "driver"
    };

    try {
      await FirebaseFirestore.instance
          .collection('rides')
          .doc(widget.rideId)
          .collection('chat')
          .add(messageData);
    } catch (e) {
      print("❌ Error while sending message: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesRef = FirebaseFirestore.instance
        .collection('rides')
        .doc(widget.rideId)
        .collection('chat')
        .orderBy('timestamp', descending: true);

    return SafeArea(

      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          title: CustomText(
          LocaleKeys.ultra_Chat.tr(),
            style: TextStyle(
              color: AppColors.amber,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: CustomIconButton(
              btnColor: AppColors.transparent,
              onTap: () => Navigator.pop(context),
              icon: Icons.arrow_back_ios,
              iconColor: AppColors.amber,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: messagesRef.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(LocaleKeys.Authentication_chatError
                            .tr(args: ['${snapshot.error}'])));
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data!.docs;

                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final text = msg['message'] ?? '';
                      final senderId = msg['senderId'] ?? '';
                      final timestamp = (msg['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
                      final timeString = "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}";

                      final isSender = senderId == widget.currentUserId;

                      return Column(
                        crossAxisAlignment: isSender
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: BubbleNormal(
                              delivered: true,
                              seen: true,
                              sent: true,
                              text: "$text\n$timeString",
                              isSender: isSender,
                              color: isSender
                                  ? AppColors.peach
                                  : AppColors.grey100,
                              textStyle: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            MessageBar(
              onSend: _sendMessage,
              actions: [],
            ),
          ],
        ),
      ),
    );
  }
}
