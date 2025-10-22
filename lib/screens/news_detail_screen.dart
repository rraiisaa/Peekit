import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tribun_app/models/news_articles.dart';
import 'package:tribun_app/utils/app_colors.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsArticles article = Get.arguments as NewsArticles;

  NewsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true, // supaya ga ilang pas di scroll
            flexibleSpace: FlexibleSpaceBar(
              background: article.urlToImage != null
                  ? CachedNetworkImage(
                    imageUrl: article.urlToImage!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.divider,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
            ),
          )
        ],
      ),
    );
}
}