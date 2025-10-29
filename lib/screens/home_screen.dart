import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peekit_app/controllers/news_controller.dart';
import 'package:peekit_app/routes/app_pages.dart';
import 'package:peekit_app/utils/app_colors.dart';
import 'package:peekit_app/widgets/category_chip.dart';
import 'package:peekit_app/widgets/loading_shimmer.dart';
import 'package:peekit_app/widgets/news_card.dart';
import 'package:peekit_app/components/bottom_navbar.dart';

class HomeScreen extends GetView<NewsController> {
  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(viewportFraction: 0.9);
    final RxInt currentPage = 0.obs;

    return Scaffold(
      backgroundColor: const Color(0xfff9f9f9),
      bottomNavigationBar: BottomNavBar(currentIndex: 0, onTap: (index) {}),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search bar + filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Search bar
                  Expanded(
                    flex: 7,
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'Search News',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Filter icon
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune_rounded, color: Colors.grey),
                      onPressed: () => _showFilterBottomSheet(context),
                    ),
                  ),
                ],
              ),
            ),

            // 🔥 Hot News
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                'Hot News',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            // 📰 Hot News Carousel
            SizedBox(
              height: 200,
              child: Obx(() {
                if (controller.isLoading) return LoadingShimmer();

                // ✅ hindari null
                final trending = controller.hotArticles ?? [];
                if (trending.isEmpty) {
                  return const Center(
                    child: Text(
                      "No hot news available 📰",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: trending.length,
                        onPageChanged: (index) => currentPage.value = index,
                        itemBuilder: (context, index) {
                          final article = trending[index];
                          return GestureDetector(
                            onTap: () => Get.toNamed(
                              Routes.NEWS_DETAIL,
                              arguments: article,
                            ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    article.urlToImage ??
                                        'https://via.placeholder.com/400x200?text=No+Image',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      AppColors.primary,
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                padding: const EdgeInsets.all(12),
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  article.title ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // 🔵 Radio Indicator
                    const SizedBox(height: 8),
                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          trending.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: currentPage.value == index ? 10 : 8,
                            height: currentPage.value == index ? 10 : 8,
                            decoration: BoxDecoration(
                              color: currentPage.value == index
                                  ? AppColors.primary
                                  : AppColors.textAdded,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                );
              }),
            ),

            const SizedBox(height: 10),

            // 🧭 Category chips
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  return Obx(
                    () => CategoryChip(
                      label: category.capitalize ?? category,
                      isSelected: controller.selectedCategory == category,
                      onTap: () => controller.selectCategory(category),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // 📰 News List
            Expanded(
              child: Obx(() {
                if (controller.isLoading) return LoadingShimmer();
                if (controller.error.isNotEmpty) return _buildErrorWidget();
                if (controller.articles.isEmpty) return _buildEmptyWidget();

                return RefreshIndicator(
                  onRefresh: controller.refreshNews,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: controller.articles.length,
                    itemBuilder: (context, index) {
                      final article = controller.articles[index];
                      return NewsCard(
                        article: article,
                        onTap: () =>
                            Get.toNamed(Routes.NEWS_DETAIL, arguments: article),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ⚠️ Empty & Error Widgets
  Widget _buildEmptyWidget() => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.newspaper, size: 64, color: Colors.grey),
        SizedBox(height: 16),
        Text(
          'No News available',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Text('Please try again later', style: TextStyle(color: Colors.grey)),
      ],
    ),
  );

  Widget _buildErrorWidget() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
        const SizedBox(height: 16),
        const Text(
          'Something went wrong',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Please check your internet connection',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: Get.find<NewsController>().refreshNews,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text('Retry'),
        ),
      ],
    ),
  );

  // 📅 Filter bottom sheet
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final filters = [
          'Kemarin',
          '1 Minggu Lalu',
          '1 Bulan Lalu',
          '3 Bulan Lalu',
        ];
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Berita Berdasarkan Waktu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              ...filters.map(
                (filter) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(filter, style: const TextStyle(fontSize: 16)),
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.find<NewsController>().filterByTime(filter);

                    Get.snackbar(
                      'Filter diterapkan',
                      'Menampilkan berita dari $filter',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.primary, // 🎨 ubah jadi warna utama
                      colorText: Colors.white, // 🩶 teks putih biar kontras
                      margin: const EdgeInsets.all(12),
                      borderRadius: 12,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
