import 'dart:io';

import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/EmptyMessage.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/common/common.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/data/recipeData.dart';
import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/provider/VideoProvider.dart';
import 'package:cookfluencer/ui/screen/ChannelDetailScreen.dart';
import 'package:cookfluencer/ui/widget/common/AiRoundButton.dart';
import 'package:cookfluencer/ui/widget/common/ChannelItemHorizontal.dart';
import 'package:cookfluencer/ui/widget/common/FilterRecipe.dart';
import 'package:cookfluencer/ui/widget/common/LikeVideoButton.dart';
import 'package:cookfluencer/ui/widget/common/MultilineText.dart';
import 'package:cookfluencer/ui/widget/common/VideoItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/util/DateUtil.dart';

final loadingProvider = StateProvider<bool>((ref) => true);

class VideoDetailScreen extends HookConsumerWidget {
  final VideoData videoData;

  const VideoDetailScreen({
    Key? key,
    required this.videoData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showRecipeDatas = useState(false); // 레시피 데이터 표시 여부
    // final isAiButtonPressed = useState(false); // 버튼 상태
    ValueNotifier<bool> isAiButtonPressed = ValueNotifier(false);
    final isLoading = ref.watch(loadingProvider); // 로딩 상태 구독
    // 로딩 상태를 추적하기 위한 useState
    final isLoadingState = useState(true);
    // 화면 진입 시 3초간 로딩 처리
    useEffect(() {
      Future.delayed(const Duration(seconds: 1), () {
        isLoadingState.value = false; // 3초 뒤 로딩 상태를 false로 변경
      });
      return null;
    }, []);

    final fadeAnimationController =
    useAnimationController(duration: const Duration(milliseconds: 500));
    final slideAnimationController = useAnimationController(
        duration: const Duration(milliseconds: 500)); // 슬라이드 애니메이션 컨트롤러

    // Opacity 애니메이션을 위한 Tween
    final opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: fadeAnimationController,
        curve: Curves.easeIn, // 부드러운 애니메이션을 위한 곡선
      ),
    );
    // Slide 애니메이션을 위한 Tween
    final slideAnimation =
    Tween<Offset>(begin: Offset(0, 0.2), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: slideAnimationController,
        curve: Curves.easeInOut, // 부드러운 애니메이션을 위한 곡선
      ),
    );

    String embedUrl = videoData.videoUrl.replaceAll('watch?v=', 'embed/');
    InAppWebViewController? webViewController;

    // channelId로 채널 데이터 가져오기
    final channelAsyncValue =
    ref.watch(channelByIdProvider(videoData.channelId));

    // 초기 렌더링 상태를 추적하기 위한 변수
    final initialFetch = useState<bool>(true);
    final selectedFilter = useState<FilterOption>(FilterOption.latest);

    final pagingController =
    useState(PagingController<int, Map<String, dynamic>>(
      firstPageKey: 0,
    ));
    // 비디오 리스트 데이터 가져오기
    Future<void> fetchVideos(int pageKey) async {
      try {
        final lastDocument = pageKey == 0
            ? null
            : pagingController.value.itemList?.last['document_snapshot'];

        final searchParams = {
          'channel_id': videoData.channelId,
          'filter': selectedFilter.value,
          'start_after': lastDocument
        };

        await Future.delayed(Duration(milliseconds: 500)); // 500ms 지연

        final newVideos =
        await ref.read(videosByChannelProvider(searchParams).future);

        // 중복 체크
        final existingIds =
            pagingController.value.itemList?.map((item) => item).toSet() ?? {};
        final filteredVideos = newVideos
            .where((video) => !existingIds.contains(video['id']))
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
      final previousController = pagingController.value;
      previousController.removePageRequestListener((pageKey) {
        fetchVideos(pageKey);
      });

      // 페이지 요청 리스너 추가
      previousController.addPageRequestListener((pageKey) {
        fetchVideos(pageKey);
      });

      // 필터가 변경될 때만 비디오 리스트를 새로 가져오기
      if (!initialFetch.value) {
        fetchVideos(0); // 필터가 변경될 때만 호출
      } else {
        initialFetch.value = false; // 초기 fetch가 끝났음을 표시
      }

      return () {
        previousController.removePageRequestListener((pageKey) {
          fetchVideos(pageKey);
        });
      };
    }, []);

    // 로딩 중인 경우
    if (isLoadingState.value) {
      return Scaffold(
        body: Center(
          child: CircularLoading(), // 로딩 화면
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
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
                Container(
                  width: 1.sw,
                  height: 0.5.sh,
                  // 웹뷰 높이 설정
                  child: Stack(
                    children: [
                      InAppWebView(
                        initialSettings: InAppWebViewSettings(
                          mediaPlaybackRequiresUserGesture: true,
                          allowsInlineMediaPlayback: true,
                          useOnLoadResource: true,
                          javaScriptEnabled: true,
                          cacheEnabled: true,
                          clearCache: false,
                          hardwareAcceleration: true,  // ✅ 하드웨어 가속 활성화
                          transparentBackground: false, // ✅ 투명 배경 비활성화
                          disableContextMenu: true,    // ✅ 불필요한 컨텍스트 메뉴 제거
                          preferredContentMode: UserPreferredContentMode.MOBILE,
                        ),
                        initialUrlRequest: URLRequest(
                          url: WebUri(embedUrl), // WebUri로 변환
                        ),
                        onWebViewCreated: (
                            InAppWebViewController controller) {
                          webViewController = controller; // webViewController를 저장
                          webViewController?.addJavaScriptHandler(
                            handlerName: 'ErrorDetected',
                            callback: (error) {
                              debugPrint("Detected 에러발생 = ${error}");
                              var watchUrl = error;
                              // ytp-embed-error가 발생한 경우
                              webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(watchUrl.toString())));
                            },
                          );
                        },
                        onLoadStart: (controller, url) {
                          ref.read(loadingProvider.notifier).state = true;
                        },
                        onLoadStop: (controller, url) async {
                          ref.read(loadingProvider.notifier).state = true;
                          await webViewController?.evaluateJavascript(
                              source: _getJavaScriptCode(videoData,Platform.isIOS));
                          ref.read(loadingProvider.notifier).state = false;
                        },

                        onLoadError: (controller, url, code, message) async {
                          debugPrint("유튜브 에러 체크하기 - onLoadError: $message");
                          // ytp-embed-error가 발생한 경우
                          // 에러 발생 시 watch URL 형식으로 HTML 콘텐츠 생성
                          String watchUrl = videoData.videoUrl.replaceAll('embed/', 'watch?v=');
                          await webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(watchUrl.toString())));
                        },
                      ),
                      if (isLoading) // 로딩 상태에 따라 로딩 인디케이터 표시
                        Center(
                          child: CircularLoading(), // 로딩 인디케이터
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 20, bottom: 12),
                  child: Text(
                    videoData.title,
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 0),
                  child:
                  Row(
                    children: [
                      Image.asset(Assets.youtube,
                          width: 20.w, height: 20.h),
                      // 별 아이콘AppColors.grey
                      SizedBox(width: 4),
                      // 간격
                      Text(
                        videoData.channelName.length > 20
                            ? '${videoData.channelName.substring(0, 20)}...'
                            : videoData.channelName,
                        maxLines: 1, // 한 줄로 제한
                        overflow: TextOverflow.ellipsis, // 길어질 경우 생략
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                            color: AppColors.greyDeep,
                            fontSize: 12.sp
                        ),
                      ),

                      Container(
                          padding: EdgeInsets.only(left: 6,right: 6),
                          child: Text(
                            '·',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.greyDeep,
                            ),
                          )
                      ),
                      Text(
                        formatMonthDayDate(videoData.uploadDate), // 조회수를 한국어 형식으로 변환
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                            color: AppColors.greyDeep,
                            fontSize: 12.sp
                        ),
                      ),

                      Container(
                          padding: EdgeInsets.only(left: 6,right: 6),
                          child: Text(
                            '·',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.greyDeep,
                            ),
                          )
                      ),
                      // 간격
                      Text(
                        videoData.viewCount.toViewCountUnit(), // 조회수를 한국어 형식으로 변환
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                            color: AppColors.greyDeep,
                            fontSize: 12.sp
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 24),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: isAiButtonPressed,
                    builder: (context, value, child) {
                      if (value) {
                        return FutureBuilder(
                          future: _fetchData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              // 애니메이션을 위한 ValueNotifier
                              ValueNotifier<int> dotCount =
                              ValueNotifier<int>(1);
                              // 애니메이션 시작 함수
                              void startDotAnimation() {
                                Timer.periodic(Duration(milliseconds: 400),
                                        (timer) {
                                      // 점 개수를 0, 1, 2, 3 순서로 변경
                                      dotCount.value = (dotCount.value % 3) +
                                          1; // 1, 2, 3 순으로 순환
                                    });
                              }

                              startDotAnimation(); // 애니메이션 시작
                              return Center(
                                child: ValueListenableBuilder<int>(
                                  valueListenable: dotCount,
                                  builder: (context, value, child) {
                                    return Airoundbutton(
                                      // 레시피가 null이 아니고 빈 객체가 아닌지 확인
                                      isEnabled: true,
                                      text: '생성 중 ${'.' * value}',
                                      onTap: () {},
                                    );
                                  },
                                ),
                              );
                              // return Center(child: CircularProgressIndicator(color: AppColors.backgroundColor));
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              fadeAnimationController
                                  .forward(); // 페이드 애니메이션 시작
                              slideAnimationController
                                  .forward(); // 슬라이드 애니메이션 시작
                              return SlideTransition(
                                position: slideAnimation,
                                child: FadeTransition(
                                  opacity: opacityAnimation,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            Assets.creat,
                                            width: 20.w,
                                            height: 20.h,
                                          ),
                                          SizedBox(width: 8),
                                          Text('AI 레시피',
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .titleSmall),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                      buildMultilineText(
                                          context,
                                          '${videoData.recipe?.description}',
                                          Theme
                                              .of(context)
                                              .textTheme
                                              .bodyLarge),
                                      SizedBox(height: 12),
                                      Line(color: AppColors.greyBackground),
                                      SizedBox(height: 12),
                                      if (videoData
                                          .recipe!.ingredients.isNotEmpty)
                                        _buildIngredients(context,
                                            videoData.recipe!.ingredients),
                                      if (videoData
                                          .recipe!.equipment.isNotEmpty)
                                        _buildEquipments(context,
                                            videoData.recipe!.equipment),
                                      if (videoData.recipe!.level != 0)
                                        _buildLevel(
                                            context, videoData.recipe!.level),
                                      if (videoData
                                          .recipe!.cookingTime.isNotEmpty)
                                        _buildCookingTime(context,
                                            videoData.recipe!.cookingTime),
                                      if (videoData
                                          .recipe!.cookingMethods.isNotEmpty)
                                        _buildCookingMethods(context,
                                            videoData.recipe!.cookingMethods),
                                      if (videoData
                                          .recipe!.tip_knowhow.isNotEmpty)
                                        _buildTipKnowhow(context,
                                            videoData.recipe!.tip_knowhow),
                                      if (videoData
                                          .recipe!.finishing.isNotEmpty)
                                        _buildFinishing(context,
                                            videoData.recipe!.finishing),
                                      SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          Image.asset(
                                            Assets.createCookflText,
                                            height: 10.h,
                                          ),
                                          SizedBox(width: 8),
                                          Image.asset(
                                            Assets.creat,
                                            width: 20.w,
                                            height: 20.h,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Center(
                                  child: CircularProgressIndicator(
                                      color: AppColors.black));
                            }
                          },
                        );
                      } else {
                        return _buildAiroundbutton(isAiButtonPressed);
                      }
                    },
                  ),
                ),
                // Firestore에서 채널 데이터 가져오기
                channelAsyncValue.when(
                  data: (channelSnapshot) {
                    // 채널 데이터 처리
                    final channel =
                    channelSnapshot.data() as Map<String, dynamic>;
                    final channelData = ChannelData(
                      id: channel['id'] ?? 'Unknown',
                      channelName: channel['channel_name'] ?? 'Unknown',
                      channelDescription:
                      channel['channel_description'] ?? '',
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
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            sliver: PagedSliverList<int, Map<String, dynamic>>(
              pagingController: pagingController.value,
              builderDelegate:
              PagedChildBuilderDelegate<Map<String, dynamic>>(
                itemBuilder: (context, video, index) {
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
                    recipe: video['recipe'] != null
                        ? RecipeData(
                      video_id: video['recipe']['video_id'] ?? '',
                      description: video['recipe']['description'] ?? '',
                      cookingTime:
                      video['recipe']['cooking_time'] ?? '',
                      level: video['recipe']['level'] ?? 0,
                      tip_knowhow: video['recipe']['tip_knowhow'] ?? '',
                      finishing: video['recipe']['finishing'] ?? '',
                      ingredients: video['recipe']['ingredients'] ?? [],
                      equipment: video['recipe']['equipment'] ?? [],
                      cookingMethods:
                      video['recipe']['cooking_methods'] ?? [],
                    )
                        : RecipeData(),
                    // 레시피가 없으면 기본 RecipeData 객체 생성
                    section: video['section'] ?? '',
                  );
                  return VideoItem(
                    key: ValueKey(videoData.id),
                    // 고유한 ID를 사용해 ValueKey 설정
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
      )
      ,
    );
  }

  Column _buildIngredients(BuildContext context, List<Ingredient>
  ingredients) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('재료', style: Theme
            .of(context)
            .textTheme
            .titleSmall),
        SizedBox(height: 8),
        ...ingredients.map((ingredient) =>
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0), // 재료 항목 간의 간격 추가
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      ingredient.name,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyLarge,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      ingredient.volume,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyLarge,
                    ),
                  ),
                ],
              ),
            )),
        SizedBox(height: 12),
        Line(color: AppColors.greyBackground),
        SizedBox(height: 12),
      ],
    );
  }

  Column _buildEquipments(BuildContext context, List<Equipment>
  equipments) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('조리 도구', style: Theme
            .of(context)
            .textTheme
            .titleSmall),
        SizedBox(height: 8),
        ...equipments.map((equipment) =>
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0), // 재료 항목 간의 간격 추가
              child: Column(
                children: [
                  Text(
                    equipment.name,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge,
                  ),
                ],
              ),
            )),
        SizedBox(height: 12),
        Line(color: AppColors.greyBackground),
        SizedBox(height: 12),
      ],
    );
  }

  Column _buildLevel(BuildContext context, int level) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('난이도', style: Theme
            .of(context)
            .textTheme
            .titleSmall),
        SizedBox(height: 8),
        if (level == 1)
          Text('쉬움', style: Theme
              .of(context)
              .textTheme
              .bodyLarge),
        if (level == 2)
          Text('보통', style: Theme
              .of(context)
              .textTheme
              .bodyLarge),
        if (level == 3)
          Text('어려움', style: Theme
              .of(context)
              .textTheme
              .bodyLarge),
        SizedBox(height: 12),
        Line(color: AppColors.greyBackground),
        SizedBox(height: 12),
      ],
    );
  }

  Column _buildCookingTime(BuildContext context, String cookingTime) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('조리 시간', style: Theme
            .of(context)
            .textTheme
            .titleSmall),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                '총 소요 시간',
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge,
              ),
            ),
            Expanded(
              child: Text(
                cookingTime,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Line(color: AppColors.greyBackground),
        SizedBox(height: 12),
      ],
    );
  }

  Column _buildCookingMethods(BuildContext context,
      List<CookingMethod> cookingMethods) {
    // 수정 가능한 리스트로 복사한 후 정렬
    List<CookingMethod> sortedCookingMethods = List.from(cookingMethods);
    sortedCookingMethods.sort((a, b) => a.step.compareTo(b.step));

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('조리 방법', style: Theme
            .of(context)
            .textTheme
            .titleSmall),
        ...sortedCookingMethods.map((cookingMethod) =>
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // 조리 방법이 왼쪽 정렬되도록 설정
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${cookingMethod.step}. ${cookingMethod.title}',
                        // step 번호와 제목 출력
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.greyDeep),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Image.asset(
                            Assets.time,
                            width: 16.w,
                            height: 16.h,
                          ),
                          SizedBox(width: 4),
                          Text(
                            cookingMethod.time,
                            style: Theme
                                .of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: AppColors.greyDeep),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                buildMultilineText(context, cookingMethod.description,
                    Theme
                        .of(context)
                        .textTheme
                        .bodyLarge),
              ],
            )),
        SizedBox(height: 12),
        Line(color: AppColors.greyBackground),
        SizedBox(height: 12),
      ],
    );
  }

  Column _buildTipKnowhow(BuildContext context, String tipKnowhow) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('팁과 노하우', style: Theme
            .of(context)
            .textTheme
            .titleSmall),
        SizedBox(height: 8),
        buildMultilineText(
            context, tipKnowhow, Theme
            .of(context)
            .textTheme
            .bodyLarge),
        SizedBox(height: 12),
        Line(color: AppColors.greyBackground),
        SizedBox(height: 12),
      ],
    );
  }

  Column _buildFinishing(BuildContext context, String finishing) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('서빙 및 마무리', style: Theme
            .of(context)
            .textTheme
            .titleSmall),
        SizedBox(height: 8),
        buildMultilineText(
            context, finishing, Theme
            .of(context)
            .textTheme
            .bodyLarge),
        // SizedBox(height: 12),
        // Line(color: AppColors.greyBackground),
        // SizedBox(height: 12),
      ],
    );
  }

  Center _buildAiroundbutton(ValueNotifier<bool> isAiButtonPressed) {
    return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Airoundbutton(
              isEnabled: videoData.recipe != null &&
                  (videoData.recipe!.video_id.isNotEmpty ||
                      videoData.recipe!.description.isNotEmpty),
              // 레시피가 null이 아니고 빈 객체가 아닌지 확인
              text: videoData.recipe != null &&
                  (videoData.recipe!.video_id.isNotEmpty ||
                      videoData.recipe!.description.isNotEmpty)
                  ? 'AI 레시피 생성'
                  : '업데이트 예정',
              onTap: () async {
                isAiButtonPressed.value = true; // 버튼 클릭 시 상태 변경
                // CircularProgressIndicator(color: AppColors.black);
                // await Future.delayed(Duration(seconds: 2));
              },
            ),
          ],
        ));
  }

  void _navigateToChannelDetail(BuildContext context,
      ChannelData channelData) {
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

  // 예시: 비동기로 데이터를 가져오는 함수 (실제 구현에 맞게 변경해야 함)
  Future<void> _fetchData() async {
    await Future.delayed(Duration(seconds: 2)); // 2초 대기
    // 여기에 데이터 로드 로직 추가 (예: API 호출)
  }
}

String getVideoIdFromUrl(String url) {
  Uri uri = Uri.parse(url); // URL을 Uri 객체로 변환
  return uri.queryParameters['v'] ?? ''; // 'v' 파라미터에서 videoId를 가져옴
}
// HTML 콘텐츠 생성
// 에러 발생 시 HTML 콘텐츠 생성
String _generateHtmlContent(String videoUrl) {
  // HTML 콘텐츠 구성
  String htmlContent = """
    <!DOCTYPE html>
    <html>
    <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <style>
        body, html {
          margin: 0;
          padding: 0;
          width: 100%;
          height: 100%;
          overflow: hidden;
        }
        #player {
          width: 100vw; /* 전체 화면 너비 */
          height: 100vh; /* 전체 화면 높이 */
        }
      </style>
    </head>
    <body>
    <text>비디오 로드 중...</text>
      <iframe id="player" width="100%" height="100%"
        src="$videoUrl"
        frameborder="0" allowfullscreen allow="autoplay; encrypted-media"></iframe>
    </body>
    </html>
    """;

  debugPrint("Generated HTML Content: $htmlContent"); // HTML 내용을 로그에 출력
  return htmlContent;
}


// JavaScript 코드를 반환하는 함수
String _getJavaScriptCode(videoData, bool isIOS) {
  return """
  var errorContent = document.querySelector('.ytp-error');
    if (errorContent) {
    errorContent.style.display = 'none'; // 요소 숨기기
    console.log('ytp-error-content가 숨겨졌습니다.');
    }

     var moviePlayerElement = document.getElementById('movie_player');
    if (moviePlayerElement) {
        if (moviePlayerElement.classList.contains('ytp-embed-error')) {
              console.log('비디오 로드 오류 발생: ytp-embed-error 클래스가 포함되어 있습니다.');
           var watchUrl = '${videoData.videoUrl.replaceAll('embed/', 'watch?v=')}';
                    ${isIOS ?
            "window.flutter_inappwebview.callHandler('ErrorDetected', '${videoData.videoUrl.replaceAll('embed/', 'watch?v=')}');" :
            "window.location.href = watchUrl;"
            }
            // 반복 중지
            clearInterval(errorCheckInterval);
        } else {
            window.flutter_inappwebview.callHandler('Flutter', '비디오가 성공적으로 로드되었습니다.');
            // 성공 시 반복 중지
            clearInterval(errorCheckInterval);
        }
    }
        
    // 일시정지 오버레이 숨기기 및 투명도 조정
    var backdrop = document.querySelector('.ytp-pause-overlay-backdrop');
    if (backdrop) {
        backdrop.style.display = 'block'; // 요소를 보이게 설정
        backdrop.style.opacity = '0'; // 투명하게 설정
        backdrop.style.pointerEvents = 'none'; // 클릭 이벤트 비활성화
        console.log('ytp-pause-backdrop가 숨겨졌습니다. 투명하게 처리되었습니다.');
    }

      var pauseOverlay = document.querySelector('.ytp-pause-overlay-container');
      if (pauseOverlay) {
          pauseOverlay.style.display = 'none'; // 일시정지 오버레이 숨기기
          console.log('ytp-pause-overlay가 숨겨졌습니다.');
      }
      
      // 500ms 간격으로 오류 확인
    var errorCheckInterval = setInterval(checkForErrorAndReload, 500);
    
    // 오류 검사를 위한 반복 함수
    function checkForErrorAndReload() {    
    // 에러 컨텐츠 숨기기
        var errorContent = document.querySelector('.ytp-error');
        if (errorContent) {
        errorContent.style.display = 'none'; // 요소 숨기기
        }
        var moviePlayerElement = document.getElementById('movie_player');

        if (moviePlayerElement) {
            if (moviePlayerElement.classList.contains('ytp-embed-error')) {

             var watchUrl = '${videoData.videoUrl.replaceAll('embed/', 'watch?v=')}';
                  ${isIOS ?
                  "window.flutter_inappwebview.callHandler('ErrorDetected', '${videoData.videoUrl.replaceAll('embed/', 'watch?v=')}');" :
                  "window.location.href = watchUrl;"
                  }
                  
            } else {
                console.log('비디오가 성공적으로 로드되었습니다.');
                window.flutter_inappwebview.callHandler('Flutter', '비디오가 성공적으로 로드되었습니다.');
                // 성공 시 반복 중지
                clearInterval(errorCheckInterval);
            }
        }
    }
        
    // 터치 이벤트를 설정하는 함수
    function setupTouchEvent() {
        const playerElement = document.getElementById('player');
        let startX;

        playerElement.addEventListener('touchstart', function(event) {
            startX = event.touches[0].clientX;
        });

        playerElement.addEventListener('touchmove', function(event) {
            if (startX) {
                const endX = event.touches[0].clientX;
                const diffX = endX - startX;

                if (player) {
                    player.getCurrentTime().then(function(currentTime) {
                        const duration = player.getDuration();
                        const newTime = currentTime + (diffX / 200);

                        player.seekTo(Math.min(Math.max(newTime, 0), duration), true);
                    });
                }
            }
        });

        playerElement.addEventListener('touchend', function() {
            startX = null;
        });
    }

    // 10초 앞으로 이동
    function seekForward() {
        if (player) {
            player.getCurrentTime().then(function(time) {
                player.seekTo(time + 10, true);
            });
        }
    }

    // 10초 뒤로 이동
    function seekBackward() {
        if (player) {
            player.getCurrentTime().then(function(time) {
                player.seekTo(time - 10, true);
            });
        }
    }
  """;
}

