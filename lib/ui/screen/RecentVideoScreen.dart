import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../common/constant/app_colors.dart';
import '../../data/videoData.dart';
import '../../provider/VideoProvider.dart';
import '../widget/common/VideoItem.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentVideoScreen extends HookConsumerWidget {
  const RecentVideoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagingController = useState(
      PagingController<String?, VideoData>(firstPageKey: null),
    );

    // 🔄 Firestore 데이터 페이지별 로딩
    Future<void> fetchPage(String? lastUploadDate) async {
      try {
        final videos = await ref.read(paginatedRecentVideosProvider(lastUploadDate).future);

        final isLastPage = videos.length < 10;

        if (isLastPage) {
          pagingController.value.appendLastPage(videos);
        } else {
          pagingController.value.appendPage(videos, videos.last.uploadDate);
        }
      } catch (error) {
        pagingController.value.error = error;
      }
    }

    useEffect(() {
      pagingController.value.addPageRequestListener(fetchPage);
      return () => pagingController.value.removePageRequestListener(fetchPage);
    }, []);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop(); // 뒤로 가기
            },
          ),
        ),
        title: Text(
          '새로운 레시피',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: PagedListView<String?, VideoData>(
        pagingController: pagingController.value,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        builderDelegate: PagedChildBuilderDelegate<VideoData>(
          itemBuilder: (context, video, index) {
            return VideoItem(
              key: ValueKey(video.id),
              video: video,
              size: 0.22.sw,
              titleWidth: 0.6.sw,
              channelWidth: 0.35.sw,
              onVideoItemClick: () {
                // 비디오 클릭 시 상세 페이지 이동
              },
              showChannelName: true,
            );
          },
          firstPageProgressIndicatorBuilder: (_) =>
          const Center(child: CircularProgressIndicator(color: AppColors.backgroundColor)),

          newPageProgressIndicatorBuilder: (_) =>
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Center(child: CircularProgressIndicator(color: AppColors.backgroundColor,)),
          ),

          noItemsFoundIndicatorBuilder: (_) =>
          const Center(child: Text("데이터가 없습니다.")),

          firstPageErrorIndicatorBuilder: (_) =>
          const Center(child: Text("데이터 로딩 실패. 다시 시도해주세요.")),
        ),
      ),
    );
  }
}