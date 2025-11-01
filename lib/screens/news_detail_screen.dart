import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peekit_app/models/news_articles.dart';
import 'package:peekit_app/utils/app_colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class NewsDetailScreen extends StatefulWidget {
  const NewsDetailScreen({super.key});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final NewsArticles article = Get.arguments as NewsArticles;
  final RxBool isSaved = false.obs;

  void _shareArticle() {
    if (article.url != null) {
      Share.share(
        '${article.title ?? 'Check out this news!'}\n\n${article.url}',
        subject: article.title,
      );
    }
  }

  void _openInBrowser() async {
    if (article.url != null) {
      final Uri url = Uri.parse(article.url!);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar('Error', "Couldn't open the link",
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          /// 🖼️ Image Header
          SizedBox(
            height: 360,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: article.urlToImage ?? '',
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.image_not_supported,
                    color: Colors.grey, size: 60),
              ),
            ),
          ),

          /// 🔙 Back + Share + Save
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Get.back(),
                  ),
                  Row(
                    children: [
                      _circleButton(icon: Icons.share, onPressed: _shareArticle),
                      const SizedBox(width: 8),
                      Obx(
                        () => _circleButton(
                          icon: isSaved.value
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          onPressed: () {
                            isSaved.toggle();
                            Get.snackbar(
                              isSaved.value ? 'Saved' : 'Removed',
                              isSaved.value
                                  ? 'Article saved to your collection'
                                  : 'Removed from saved articles',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppColors.primary,
                              colorText: Colors.white,
                              margin: const EdgeInsets.all(12),
                              borderRadius: 12,
                              duration: const Duration(seconds: 2),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /// 📄 Article Card Section
          DraggableScrollableSheet(
            initialChildSize: 0.58,
            minChildSize: 0.58,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 Source & time
                      Row(
                        children: [
                          if (article.source?.name != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                article.source!.name!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          const SizedBox(width: 8),
                          Text(
                            timeago.format(DateTime.parse(
                                article.publishedAt ??
                                    DateTime.now().toString())),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // 📰 Title
                      Text(
                        article.title ?? '',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 📝 Description
                      if (article.description != null)
                        Text(
                          article.description!,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            height: 1.6,
                          ),
                        ),
                      const SizedBox(height: 16),

                      // 📚 Content
                      if (article.content != null)
                        Text(
                          article.content!,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            height: 1.6,
                          ),
                        ),
                      const SizedBox(height: 24),

                      // 🔗 Button
                      if (article.url != null)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _openInBrowser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Read Full Article",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
