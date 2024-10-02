import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/ui/screen/VideoDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:cookfluencer/common/dart/extension/num_extension.dart';
import 'package:cookfluencer/common/util/ScreenUtil.dart';
import 'package:cookfluencer/ui/widget/common/CustomVideoImage.dart';
import 'package:cookfluencer/ui/widget/common/LikeVideoButton.dart'; // LikeVideoButton 추가
import 'package:go_router/go_router.dart';

class VideoItem extends StatelessWidget {
  final VideoData video; // 비디오 데이터
  final double size; // 썸네일 사이즈
  final double titleWidth; // 비디오 제목 너비
  final double channelWidth; // 채널 이름 너비
  final VoidCallback onVideoItemClick;
  final bool showLikeButton; // 비디오 클릭 시 호출할 콜백 추가

  const VideoItem({
    Key? key,
    required this.video,
    required this.size, // 썸네일 사이즈 추가
    required this.titleWidth, // 제목 너비 추가
    required this.channelWidth, // 채널 이름 너비 추가
    required this.onVideoItemClick, // 콜백 전달
    this.showLikeButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => VideoDetailScreen(videoData: video),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0); // 시작 위치
              const end = Offset.zero; // 끝 위치
              const curve = Curves.easeInOut; // 애니메이션 곡선
              final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve)); // 트윈 설정
              final offsetAnimation = animation.drive(tween); // 애니메이션 드라이버

              return SlideTransition(
                position: offsetAnimation, // 슬라이드 전환 애니메이션
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 300), // 애니메이션 지속 시간
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Container(
              width: size, // 전달받은 사이즈 사용
              height: size, // 1:1 비율 유지
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8), // 라운드 처리
                child: Hero(
                  tag: 'video_${video.id}',
                  child: CustomVideoImage(
                    imageUrl: video.thumbnailUrl, // 썸네일 이미지
                    size: size,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12), // 간격
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // 타이틀과 버튼 사이에 공간 배분
                    children: [
                      Container(
                        width: titleWidth, // 전달받은 제목 너비 사용
                        child: Text(
                          video.title, // 비디오 제목
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ),
                      showLikeButton
                          ? LikeVideoButton(videoData: video,rightMargin: 0,)
                          : Container(),
                    ],
                  ),
                  SizedBox(height: 6), // 간격
                  Row(
                    children: [
                      Image.asset(Assets.view,
                          width: 14,
                          height: 14,
                          color: AppColors.grey), // 조회수 아이콘
                      SizedBox(width: 4), // 간격
                      Text(
                        video.viewCount.toViewCountUnit(), // 조회수 표시
                        style: TextStyle(
                            color: AppColors.grey, fontSize: 12),
                      ),
                      SizedBox(width: 16),
                      Image.asset(Assets.youtube,width: 20,height: 20), // 유튜브 아이콘
                      SizedBox(width: 4), // 간격
                      Container(
                        width: channelWidth, // 전달받은 채널 이름 너비 사용
                        child: Text(
                          video.channelName, // 채널 이름
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: AppColors.grey, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}