// lib/features/share/presentation/widgets/social_buttons.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:share_plus/share_plus.dart';

class SocialButtons extends StatelessWidget {
  final String shareText;
  final String shareLink;

  const SocialButtons({
    super.key,
    required this.shareText,
    required this.shareLink,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _socialButton(
          icon: Icons.facebook_rounded,
          color: const Color(0xFF1877F2),
          label: 'فيسبوك',
          onTap: () => _shareToFacebook(),
        ),
        _socialButton(
          icon: Icons.camera_alt_rounded,
          color: const Color(0xFFE4405F),
          label: 'انستجرام',
          onTap: () => _shareToInstagram(),
        ),
        _socialButton(
          icon: Icons.chat_rounded,
          color: const Color(0xFF25D366),
          label: 'واتساب',
          onTap: () => _shareToWhatsApp(),
        ),
        _socialButton(
          icon: Icons.alternate_email_rounded,
          color: const Color(0xFF1DA1F2),
          label: 'تويتر',
          onTap: () => _shareToTwitter(),
        ),
      ],
    );
  }

  Widget _socialButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withAlpha(38),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withAlpha(76)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(
                  color: VirooColors.textSecondary,
                  fontSize: 10,
                  fontFamily: 'Cairo')),
        ],
      ),
    );
  }

  Future<void> _shareToWhatsApp() async {
    final url = Uri.parse(
        'https://wa.me/?text=${Uri.encodeComponent('$shareText\n$shareLink')}');
    if (await canLaunchUrl(url))
      await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> _shareToFacebook() async {
    final url = Uri.parse(
        'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(shareLink)}');
    if (await canLaunchUrl(url))
      await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> _shareToTwitter() async {
    final url = Uri.parse(
        'https://twitter.com/intent/tweet?text=${Uri.encodeComponent('$shareText\n$shareLink')}');
    if (await canLaunchUrl(url))
      await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> _shareToInstagram() async {
    await Share.share('$shareText\n$shareLink', subject: 'VirooMall');
  }
}
