// lib/widgets/update_checker.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../common/constant/app_colors.dart';
import '../services/remote_config_service.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../services/update_view_model.dart';

/// Riverpod Provider를 사용하여 UpdateViewModel 인스턴스를 생성
final updateViewModelProvider = ChangeNotifierProvider<UpdateViewModel>((ref) {
  final remoteConfig = FirebaseRemoteConfig.instance;
  final remoteConfigService = RemoteConfigService(remoteConfig: remoteConfig);
  return UpdateViewModel(remoteConfigService: remoteConfigService);
});

/// UpdateChecker 위젯: 앱 최상단에서 강제 업데이트 체크 및 팝업 표시
class UpdateChecker extends ConsumerStatefulWidget {
  final Widget child;
  const UpdateChecker({Key? key, required this.child}) : super(key: key);

  @override
  ConsumerState<UpdateChecker> createState() => _UpdateCheckerState();
}

class _UpdateCheckerState extends ConsumerState<UpdateChecker> {
  @override
  void initState() {
    super.initState();
    // 위젯 빌드 후 강제 업데이트 여부 체크
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(updateViewModelProvider).checkForUpdate();
    });
  }

  @override
  Widget build(BuildContext context) {
    // UpdateViewModel 상태 변화 감지
    ref.listen<UpdateViewModel>(updateViewModelProvider, (previous, next) {
      if (next.forceUpdateRequired) {
        _showForceUpdateDialog(next.updateMessage, next.updateUrl);
      }
    });
    return widget.child;
  }

  /// 디자인 적용된 강제 업데이트 알림 다이얼로그 표시
  void _showForceUpdateDialog(String message, String updateUrl) {
    showDialog(
      context: context,
      barrierDismissible: false, // 바깥 터치로 닫히지 않도록 설정
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        return WillPopScope(
          // 뒤로가기 버튼으로 닫히지 않도록 설정
          onWillPop: () async => false,
          child: AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            backgroundColor: Colors.white,
            content: Container(
              width: screenWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "안정적인 서비스 이용을 위해\n최신 버전 업데이트가 필요합니다.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primarySelectedColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                  onPressed: () async {
                    if (await canLaunch(updateUrl)) {
                      await launch(updateUrl);
                    }
                  },
                  child: const Text(
                    '확인',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


}
