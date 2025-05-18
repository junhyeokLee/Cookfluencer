import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/ui/screen/HomeScreen.dart';
import 'package:cookfluencer/ui/screen/PrivacyPolicyPage.dart';
import 'package:cookfluencer/ui/screen/TermsAndConditionsPage.dart';
import 'package:cookfluencer/ui/widget/common/AppbarWidget.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/constant/assets.dart';
import '../../provider/AuthNotifier.dart';
import '../../provider/NotificationProvider.dart';
import '../../repository/FirebaseTokenRepository.dart';

class MyPageScreen extends ConsumerWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final isNotificationEnabled = ref.watch(notificationProvider);

    return Scaffold(
      appBar: AppbarWidget(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('내 정보', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 12),
                    user != null ? _buildUserInfo(user) : _buildGuestUser(ref),
                    const SizedBox(height: 20),
                    _buildSettings(context, ref, isNotificationEnabled, FirebaseTokenRepository()),
                    const SizedBox(height: 20),
                    if (user != null) _buildLogoutButton(ref, context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(firebase_auth.User user) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildUserInfoLoading();
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text("사용자 정보 없음"));
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final kakaoId = userData['kakaoId'] ?? '';

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.recipeColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text("ID: $kakaoId", style: Theme.of(context).textTheme.titleSmall),
        );
      },
    );
  }

  Widget _buildUserInfoLoading() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primarySelectedColor),
      ),
    );
  }

  Widget _buildGuestUser(WidgetRef ref) {
    final isLoggingIn = ref.watch(authProvider).isLoading;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: isLoggingIn ? null : () => ref.read(authProvider.notifier).loginWithKakao(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.kakaoYellow,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isLoggingIn) Image.asset(Assets.kakaoLogo, width: 24, height: 24),
              const SizedBox(width: 8),
              isLoggingIn
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(color: AppColors.recipeColor, strokeWidth: 2),
              )
                  : const Text("카카오톡 로그인", style: TextStyle(color: Colors.black, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(WidgetRef ref, BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return InkWell(
      onTap: isLoading
          ? null
          : () async {
        await ref.read(authProvider.notifier).logout();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
                (_) => false,
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('로그아웃', style: Theme.of(context).textTheme.bodyMedium),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }

  Widget _buildSettings(BuildContext context, WidgetRef ref, bool isNotificationEnabled, FirebaseTokenRepository _tokenRepo) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('알림설정', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('새소식 알림', style: Theme.of(context).textTheme.bodyMedium),
                    Text('신규 레시피와 큐레이션 알림', style: TextStyle(fontSize: 11, color: AppColors.grey)),
                  ],
                ),
                Switch(
                  value: isNotificationEnabled,
                  onChanged: (value) async {
                    await ref.read(notificationProvider.notifier).toggleNotification(value);
                    await _tokenRepo.toggleNotification(value);
                  },
                  activeColor: Colors.white,
                  activeTrackColor: AppColors.primarySelectedColor,
                  inactiveThumbColor: AppColors.backgroundColor,
                  inactiveTrackColor: Colors.grey.shade300,
                  trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('피드백', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                final url = Uri.parse('https://forms.gle/ZpCYw7Tei3QiWkUm9');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('버그신고', style: Theme.of(context).textTheme.bodyMedium),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                final url = Uri.parse('https://forms.gle/VdymB883WEmpWkmq7');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('아이디어 제안', style: Theme.of(context).textTheme.bodyMedium),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildInfoLinks(context),
      ],
    );
  }

  Widget _buildInfoLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('앱 정보', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 12),
        _linkItem(
          context,
          label: '앱 버전 정보',
          trailing: FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(height: 14, width: 14, child: CircularProgressIndicator(strokeWidth: 2));
              }
              if (snapshot.hasError) return const Text("정보 오류");
              return Text(snapshot.data?.version ?? '정보 없음', style: const TextStyle(color: AppColors.grey, fontSize: 12));
            },
          ),
        ),
        const SizedBox(height: 12),
        _linkItem(
          context,
          label: '이용 약관',
          onTap: () =>
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => TermsAndConditionsPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;
                    final tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    final offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 300),
                ),
              ),
        ),
        const SizedBox(height: 12),
        _linkItem(
          context,
          label: '개인정보 처리방침',
          onTap: () =>  Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => PrivacyPolicyPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                final offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _linkItem(BuildContext context, {required String label, Widget? trailing, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}
