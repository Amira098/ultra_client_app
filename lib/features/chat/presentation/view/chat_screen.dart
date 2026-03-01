import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_values.dart';
import '../../../../core/utils/app_shared_preference.dart';
import '../../../../core/utils/custom_text.dart';
import '../../../../core/utils/utils/custom_icon_button.dart';
import '../../../../generated/locale_keys.g.dart';

class ChatScreen extends StatefulWidget {
  final String rideId;

  const ChatScreen({super.key, required this.rideId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String currentUserId = '';
  String senderType = 'client';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final userJson = SharedPreferencesUtils.getData(key: AppValues.user);

    if (userJson != null && userJson is String && userJson.isNotEmpty) {
      try {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        setState(() {
          currentUserId = userMap['id']?.toString() ?? '';
          senderType = userMap['type']?.toString() ?? 'client';
        });
      } catch (e) {
        debugPrint('Error decoding user data: $e');
      }
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final messageData = {
      'message': text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
      'senderId': currentUserId,
      'senderType': senderType,
    };

    try {
      await FirebaseFirestore.instance
          .collection('rides')
          .doc(widget.rideId)
          .collection('chat')
          .add(messageData);

      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(LocaleKeys.Authentication_errorSendingMessage
                  .tr(args: ['$e']))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: CustomText(
          LocaleKeys.ultra_Chat.tr(),
          style: const TextStyle(
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
              stream: FirebaseFirestore.instance
                  .collection('rides')
                  .doc(widget.rideId)
                  .collection('chat')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
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
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final text = msg['message'] ?? '';
                    final senderId = msg['senderId']?.toString() ?? 'Unknown';
                    final timestamp =
                        (msg['timestamp'] as Timestamp?)?.toDate() ??
                            DateTime.now();
                    final timeString =
                        "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}";

                    final isSender = senderId == currentUserId;

                    return Column(
                      crossAxisAlignment: isSender
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BubbleNormal(
                            text: text,
                            isSender: isSender,
                            color: isSender
                                ? AppColors.amber.withOpacity(0.3)
                                : Colors.grey.shade200,
                            textStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: isSender ? 0 : 12,
                            right: isSender ? 12 : 0,
                          ),
                          child: Text(
                            timeString,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
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
            onSend: (message) {
              _sendMessage(message);
            },
            actions: const [],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
