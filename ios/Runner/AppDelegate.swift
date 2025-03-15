import Flutter
import UIKit
import KakaoSDKCommon
import KakaoSDKAuth

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // ✅ Kakao SDK 초기화 (YOUR_APP_KEY를 카카오 네이티브 앱 키로 변경)
    KakaoSDK.initSDK(appKey: "87ab621c8be7408e618e3f12007ec9ae")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // ✅ 카카오 로그인 URL 핸들링 (카카오톡 또는 Safari에서 앱으로 돌아올 때 호출됨)
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    if AuthApi.isKakaoTalkLoginUrl(url) {
      return AuthController.handleOpenUrl(url: url)
    }
    return super.application(app, open: url, options: options)
  }
}
