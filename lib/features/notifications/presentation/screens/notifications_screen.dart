// lib/features/notifications/presentation/screens/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../../../core/widgets/viroo_background.dart';
import '../../../../core/services/auth_service.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    return Scaffold(
      backgroundColor: VirooColors.background,
      appBar: AppBar(
        title: const Text(
          '🔔 الإشعارات',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: VirooBackground(
        showOrbs: true,
        themeColor: VirooColors.amberPrimary,
        child: user == null
            ? const Center(
                child: Text(
                  'الرجاء تسجيل الدخول',
                  style: TextStyle(
                    color: Colors.white70,
                    fontFamily: 'Cairo',
                  ),
                ),
              )
            : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('notifications')
                    .where('userId', isEqualTo: user.uid)
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: VirooColors.amberPrimary,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '❌ خطأ: ${snapshot.error}',
                        style: const TextStyle(
                          color: VirooColors.error,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_rounded,
                            color: VirooColors.textSecondary,
                            size: 60,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'لا توجد إشعارات',
                            style: TextStyle(
                              color: VirooColors.textSecondary,
                              fontSize: 18,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'ستظهر الإشعارات هنا عند حدوث أي نشاط',
                            style: TextStyle(
                              color: VirooColors.textTertiary,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final notifications = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final doc = notifications[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final isRead = data['isRead'] ?? false;

                      return _buildNotificationCard(
                        title: data['title'] ?? '',
                        body: data['body'] ?? '',
                        createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
                        isRead: isRead,
                        docId: doc.id,
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String body,
    required DateTime? createdAt,
    required bool isRead,
    required String docId,
  }) {
    return GestureDetector(
      onTap: () async {
        await FirebaseFirestore.instance
            .collection('notifications')
            .doc(docId)
            .update({'isRead': true});
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isRead
                ? VirooColors.glassBorder
                : VirooColors.amberPrimary.withAlpha(76),
            width: isRead ? 1 : 2,
          ),
        ),
        child: GlassContainer(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 12),
          borderRadius: BorderRadius.circular(16),
          backgroundColor: isRead
              ? VirooColors.glassDark
              : VirooColors.amberPrimary.withAlpha(25),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: const BoxDecoration(
                    color: VirooColors.amberPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
              if (!isRead) const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isRead ? Colors.white70 : Colors.white,
                        fontWeight:
                            isRead ? FontWeight.normal : FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      body,
                      style: const TextStyle(
                        color: VirooColors.textSecondary,
                        fontSize: 12,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(createdAt),
                      style: const TextStyle(
                        color: VirooColors.textTertiary,
                        fontSize: 10,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  color: VirooColors.textSecondary,
                  size: 18,
                ),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('notifications')
                      .doc(docId)
                      .delete();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime? date) {
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 30) return '${diff.inDays ~/ 30} شهر';
    if (diff.inDays > 0) return '${diff.inDays} يوم';
    if (diff.inHours > 0) return '${diff.inHours} ساعة';
    if (diff.inMinutes > 0) return '${diff.inMinutes} دقيقة';
    return 'الآن';
  }
}
