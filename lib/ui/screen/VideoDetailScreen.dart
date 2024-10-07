import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/EmptyMessage.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/common/common.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/ui/screen/ChannelDetailScreen.dart';
import 'package:cookfluencer/ui/widget/common/ChannelItemHorizontal.dart';
import 'package:cookfluencer/ui/widget/common/FilterRecipe.dart';
import 'package:cookfluencer/ui/widget/common/LikeVideoButton.dart';
import 'package:cookfluencer/ui/widget/common/VideoItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webviewtube/webviewtube.dart';

class VideoDetailScreen extends HookConsumerWidget {
  final VideoData videoData;

  const VideoDetailScreen({
    Key? key,
    required this.videoData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useRef<WebviewtubeController?>(null);
    // final controller = WebviewtubeController();
    final options = const WebviewtubeOptions(
      showControls: true,
      mute: false,
      aspectRatio: 16 / 9,
      enableCaption: false,
      forceHd: true,
      loop: false,
      interfaceLanguage: 'ko',
    );

    debugPrint("비디오 url: ${videoData.videoUrl}");
    debugPrint("비디오 ID: ${videoData.videoId}");
    debugPrint("비디오DATA ID: ${videoData.id}");

    // channelId로 채널 데이터 가져오기
    final channelAsyncValue = ref.watch(channelByIdProvider(videoData.channelId));

    // 초기 렌더링 상태를 추적하기 위한 변수
    final initialFetch = useState<bool>(true);
    final selectedFilter = useState<FilterOption>(FilterOption.viewCount);
    final pagingController = useState(PagingController<int, QueryDocumentSnapshot>(firstPageKey: 0));

    // 비디오 리스트 데이터 가져오기
    Future<void> fetchVideos(int pageKey) async {
      try {
        final lastDocument = pageKey == 0 ? null : pagingController.value.itemList?.last;

        final searchParams = {
          'channel_id': videoData.channelId,
          'filter': selectedFilter.value,
          'start_after': lastDocument
        };

        await Future.delayed(Duration(milliseconds: 500)); // 500ms 지연

        final newVideos =
            await ref.read(videosByChannelProvider(searchParams).future);

        // 기존 비디오 ID를 Set으로 가져와서 중복 체크
        final existingIds = pagingController.value.itemList?.map((item) => item.id).toSet() ?? {};

        // 새로운 비디오 리스트에서 이미 있는 비디오를 필터링
        final filteredVideos = newVideos
            .where((video) => !existingIds.contains(video.id))
            .toList();

        // 중복 체크 후 비디오가 없으면 lastPage로 설정
        final isLastPage = filteredVideos.isEmpty;
        if (isLastPage) {
          pagingController.value.appendLastPage(filteredVideos);
        } else {
          final nextPageKey = pageKey + filteredVideos.length; // 다음 페이지 키 계산
          pagingController.value.appendPage(filteredVideos, nextPageKey);
        }
      } catch (error) {
        pagingController.value.error = error; // 오류 발생 시 처리
      }
    }

    // 필터 변경 시, PagingController를 새로 생성
    useEffect(() {
      // PagingController의 요청 리스너 제거
      final previousController = pagingController.value;
      previousController.removePageRequestListener((pageKey) {
        fetchVideos(pageKey);
      });

      // 새로운 PagingController 생성
      final newPagingController = PagingController<int, QueryDocumentSnapshot>(
        firstPageKey: 0,
      );

      // 페이지 요청 리스너 추가
      newPagingController.addPageRequestListener((pageKey) {
        fetchVideos(pageKey);
      });

      // PagingController를 새로운 것으로 설정
      pagingController.value = newPagingController;

      // 필터가 변경될 때만 비디오 리스트를 새로 가져오기
      if (!initialFetch.value) {
        fetchVideos(0); // 필터가 변경될 때만 호출
      } else {
        initialFetch.value = false; // 초기 fetch가 끝났음을 표시
      }

      // WebviewtubeController를 초기화
      controller.value = WebviewtubeController();

      // 클린업: 현재 PagingController의 페이지 요청 리스너 제거
      return () {
        previousController.removePageRequestListener((pageKey) {
          fetchVideos(pageKey);
        });
        controller.value?.dispose(); // WebviewtubeController 해제
      };
    }, []);

    return WillPopScope(
      onWillPop: () async {
        controller.value?.dispose(); // 뒤로가기 시 Webview 초기화
        Navigator.of(context).pop();
        return true; // 뒤로가기 허용
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                controller.value?.dispose(); // 뒤로가기 시 Webview 초기화
                Navigator.of(context).pop();
              },
            ),
          ),
          actions: [LikeVideoButton(videoData: videoData, rightMargin: 24)],
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WebviewtubePlayer(
                    videoId: getVideoIdFromUrl(videoData.videoUrl),
                    options: options,
                    controller: controller.value!,
                  ),
                  // WebViewWidget(controller: controller),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 20, bottom: 12),
                    child: Text(
                      videoData.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 0),
                    child: Row(
                      children: [
                        Image.asset(
                          Assets.view,
                          width: 16.w,
                          height: 16.h,
                          color: AppColors.greyDeep,
                        ),
                        SizedBox(width: 4),
                        Text(videoData.viewCount.toViewCountUnit(),
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: AppColors.grey)),
                      ],
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
                  //   child: Text(
                  //     videoData.description,
                  //     style: Theme.of(context).textTheme.bodyMedium,
                  //   ),
                  // ),

                  // Firestore에서 채널 데이터 가져오기
                  channelAsyncValue.when(
                    data: (channelSnapshot) {
                      // 채널 데이터 처리
                      final channel =
                          channelSnapshot.data() as Map<String, dynamic>;
                      final channelData = ChannelData(
                        id: channel['id'] ?? 'Unknown',
                        channelName: channel['channel_name'] ?? 'Unknown',
                        channelDescription: channel['channel_description'] ?? '',
                        channelUrl: channel['channel_url'] ?? '',
                        thumbnailUrl: channel['thumbnail_url'] ?? '',
                        subscriberCount: int.tryParse(
                                channel['subscriber_count'].toString()) ??
                            0,
                        videoCount: channel['video_count'] ?? 0,
                        videos: channel['videos'] ?? [],
                        section: channel['section'] ?? '',
                      );

                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 24, bottom: 24),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.keywordBackground,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ChannelItemHorizontal(
                              channelData: channelData,
                              onChannelItemClick: () {
                                _navigateToChannelDetail(context, channelData);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    loading: () => CircularLoading(), // 로딩 중일 때
                    error: (error, stack) =>
                        ErrorMessage(message: '오류 발생: $error'), // 오류 발생 시
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 12, bottom: 20),
                    child: Text('다음 레시피 영상',
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              sliver: PagedSliverList<int, QueryDocumentSnapshot>(
                pagingController: pagingController.value,
                builderDelegate: PagedChildBuilderDelegate<QueryDocumentSnapshot>(
                  itemBuilder: (context, videoSnapshot, index) {
                    final video = videoSnapshot.data() as Map<String, dynamic>;
                    final videoData = VideoData(
                      id: video['id'] ?? 'Unknown',
                      channelId: video['channel_id'] ?? 'Unknown',
                      channelName: video['channel_name'] ?? 'Unknown',
                      description: video['description'] ?? '',
                      thumbnailUrl: video['thumbnail_url'] ?? '',
                      title: video['title'] ?? 'Unknown',
                      uploadDate: video['upload_date'] ?? '',
                      videoId: video['video_id'] ?? '',
                      videoUrl: video['video_url'] ?? '',
                      viewCount:
                          int.tryParse(video['view_count'].toString()) ?? 0,
                      section: video['section'] ?? '',
                    );
                    return VideoItem(
                      video: videoData,
                      size: 0.2.sw,
                      titleWidth: 0.65.sw,
                      channelWidth: 0.35.sw,
                      onVideoItemClick: () {},
                    );
                  },
                  firstPageProgressIndicatorBuilder: (context) =>
                      Center(child: CircularLoading()),
                  newPageProgressIndicatorBuilder: (context) =>
                      Center(child: CircularLoading()),
                  noItemsFoundIndicatorBuilder: (context) =>
                      EmptyMessage(message: '비디오가 없음'),
                  noMoreItemsIndicatorBuilder: (context) =>
                      EmptyMessage(message: '더 이상 비디오 없음'),
                ),
              ),
            ),
            // 오류 발생 시 메시지 표시
            if (pagingController.value.error != null)
              SliverToBoxAdapter(
                child: ErrorMessage(
                    message: '오류 발생: ${pagingController.value.error}'),
              ),
          ],
        ),
      ),
    );
  }

  void _navigateToChannelDetail(BuildContext context, ChannelData channelData) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ChannelDetailScreen(channelData: channelData),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}

String getVideoIdFromUrl(String url) {
  Uri uri = Uri.parse(url); // URL을 Uri 객체로 변환
  return uri.queryParameters['v'] ?? ''; // 'v' 파라미터에서 videoId를 가져옴
}
