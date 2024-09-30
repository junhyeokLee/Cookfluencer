import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/ui/widget/common/ChannelItemHorizontal.dart';
import 'package:flutter/material.dart';

class ResultSearchChannel extends StatelessWidget {
  const ResultSearchChannel({Key? key ,
    required this.channelData,
  }) : super(key: key);

  final ChannelData channelData; // 채널 데이터를 받는 파라미터


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.only(left: 16, top: 24),
          child: Text('인플루언서',
              style: Theme.of(context).textTheme.labelLarge),
        ),
        ChannelItemHorizontal(channelData: channelData),
      ],
    );
  }
}
