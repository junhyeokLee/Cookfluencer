import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookfluencer/common/dart/extension/num_extension.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/ui/widget/ChannelItem.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Homelist extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelListAsyncValue = ref.watch(channelListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Channels'),
      ),
      body: channelListAsyncValue.when(
        data: (snapshot) {
          final channels = snapshot.docs;

          return ListView.builder(
            itemCount: channels.length,
            itemBuilder: (context, index) {
              final channelData = channels[index].data() as Map<String, dynamic>;
              final subscriberCount = (channelData['subscriber_count'] ?? 0) as int;

              return ChannelItem(channelData: channelData, subscriberCount: subscriberCount);
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Something went wrong: $error')),
      ),
    );
  }
}