import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/ui/screen/PrivacyPolicyPage.dart';
import 'package:cookfluencer/ui/screen/TermsAndConditionsPage.dart';
import 'package:cookfluencer/ui/widget/common/AppbarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MyPageScreen extends ConsumerWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppbarWidget(),
      body: Container(
        margin: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('내 정보', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Q. 로그인은 따로 없나요?',
                      style: Theme.of(context).textTheme.titleSmall),
                  SizedBox(height: 8),
                  Text(
                    'A. 로그인 기능을 준비하고 있어요.\n 개인화 기능이 완성되면 로그인 기능과 함께 제공됩니다.\n 조금만 기다려주세요.',
                    style: Theme.of(context).textTheme.bodyMedium
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('피드백', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 12),
                // 버그신고 텍스트와 아이콘을 나란히 배치
                InkWell(
                  onTap: () async {
                    final Uri _url = Uri.parse('https://forms.gle/ZpCYw7Tei3QiWkUm9');
                    if (await canLaunchUrl(_url)) {
                      await launchUrl(_url);
                    } else {
                      throw 'Could not launch $_url';
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '버그신고',
                      style: Theme.of(context).textTheme.bodyMedium
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16), // 오른쪽 화살표 아이콘
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    final Uri _url = Uri.parse('https://forms.gle/VdymB883WEmpWkmq7');
                    if (await canLaunchUrl(_url)) {
                      await launchUrl(_url);
                    } else {
                      throw 'Could not launch $_url';
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '아이디어 제안',
                          style: Theme.of(context).textTheme.bodyMedium
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16), // 오른쪽 화살표 아이콘
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('앱 정보', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '앱 버전 정보',
                          style: Theme.of(context).textTheme.bodyMedium
                      ),
                      FutureBuilder<PackageInfo>(
                        future: PackageInfo.fromPlatform(), // 앱 버전 정보 가져오기
                        builder: (context, snapshot) {
                          // Future의 상태에 따라 다른 위젯을 반환
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator(); // 로딩 중인 경우
                          } else if (snapshot.hasError) {
                            return Text('버전 정보 오류', style: TextStyle(color: AppColors.grey));
                          } else {
                            final version = snapshot.data?.version ?? '정보 없음';
                            return Text(version, style: TextStyle(fontSize: 12, color: AppColors.grey));
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                          TermsAndConditionsPage(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '이용 약관',
                          style: Theme.of(context).textTheme.bodyMedium
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16), // 오른쪽 화살표 아이콘
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                          PrivacyPolicyPage(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '개인정보 처리방침',
                          style: Theme.of(context).textTheme.bodyMedium
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16), // 오른쪽 화살표 아이콘
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}