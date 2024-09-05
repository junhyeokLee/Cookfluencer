import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final searchResult = ref.watch(searchChannelProvider(_searchQuery));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search Channels...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value.trim();
            });
          },
        ),
      ),
      body: searchResult.when(
        data: (channels) {
          if (channels.isEmpty) {
            return Center(child: Text('No channels found.'));
          }
          return ListView.builder(
            itemCount: channels.length,
            itemBuilder: (context, index) {
              final channelData = channels[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(channelData['channel_name'] ?? 'Unknown'),
                subtitle: Text('Subscribers: ${channelData['subscriber_count'] ?? 0}'),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Something went wrong: $error')),
      ),
    );
  }
}