import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookfluencer/common/common.dart';
import 'package:flutter/material.dart';

class ChannelItem extends StatelessWidget {
  const ChannelItem({
    super.key,
    required this.channelData,
    required this.subscriberCount,
  });

  final Map<String, dynamic> channelData;
  final int subscriberCount;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30, // 원형 썸네일 크기 조정
        backgroundColor: Colors.grey[200], // 로딩 중일 때 표시될 배경색
        backgroundImage: CachedNetworkImageProvider(
          channelData['thumbnail_url'] ?? '', // 썸네일 URL
        ),
      ),
      title: Text(
        channelData['channel_name'] ?? 'Unknown',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        '구독수: ${subscriberCount.toKoreanUnit()}', // 구독자 수 포맷팅
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      onTap: () {
        // 채널 클릭 시 동작 추가 (예: 상세 페이지로 이동)
      },
    );
  }
}