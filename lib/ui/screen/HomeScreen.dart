
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cookfluencer/ui/list/HomeList.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 0, title: Text('')),
      body: Column(
        children: [
          Expanded(
            child: HomeList(), // HomeList를 Expanded로 감싸기
          ),
        ],
      ),
    );
  }
}