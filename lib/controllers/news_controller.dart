import 'package:get/get.dart';
import 'package:peekit_app/models/news_articles.dart';
import 'package:peekit_app/services/news_services.dart';
import 'package:peekit_app/utils/constants.dart';

class NewsController extends GetxController {
  final NewsServices _newsServices = NewsServices();

  // Observable variables
  final _isLoading = false.obs;
  final _articles = <NewsArticles>[].obs;
  final _hotArticles = <NewsArticles>[].obs; // 🔥 untuk berita hot
  final _selectedCategory = 'general'.obs;
  final _error = ''.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  List<NewsArticles> get articles => _articles;
  List<NewsArticles> get hotArticles => _hotArticles;
  String get selectedCategory => _selectedCategory.value;
  String get error => _error.value;
  List<String> get categories => Constants.categories;

  // =============================================================
  // 🔹 Ambil semua berita utama (top-headlines)
  // =============================================================
  Future<void> fetchTopHeadlines({String? category}) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final response = await _newsServices.getTopHeadlines(
        category: category ?? _selectedCategory.value,
      );

      _articles.value = response.articles;
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load news: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // =============================================================
  // 🔹 Ambil berita "Hot News" — urut dari yang terbaru
  // =============================================================
  Future<void> fetchHotNews() async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final response = await _newsServices.getTopHeadlines(category: 'general');

      final sorted = response.articles
        ..sort((a, b) {
          final bDate = DateTime.tryParse(b.publishedAt?.toString() ?? '') ?? DateTime.now();
          final aDate = DateTime.tryParse(a.publishedAt?.toString() ?? '') ?? DateTime.now();
          return bDate.compareTo(aDate);
        });

      // ambil 5 berita teratas yang paling baru
      _hotArticles.value = sorted.take(5).toList();
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load hot news: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // =============================================================
  // 🔹 Filter berita berdasarkan waktu (kemarin, minggu lalu, bulan lalu)
  // =============================================================
  Future<void> filterByTime(String filterType) async {
    try {
      final now = DateTime.now();
      late DateTime cutoffDate;

      if (filterType == 'Kemarin') {
        cutoffDate = now.subtract(const Duration(days: 1));
      } else if (filterType == '1 Minggu Lalu') {
        cutoffDate = now.subtract(const Duration(days: 7));
      } else if (filterType == '1 Bulan Lalu') {
        cutoffDate = now.subtract(const Duration(days: 30));
      } else {
        // kalau tidak ada filter, tampilkan semua berita
        await fetchTopHeadlines();
        return;
      }

      // filter berita yang tanggal publish-nya setelah batas waktu
      final filtered = _articles.where((article) {
        final date = DateTime.tryParse(article.publishedAt?.toString() ?? '');
        if (date == null) return false;
        return date.isAfter(cutoffDate);
      }).toList();

      _articles.value = filtered;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to filter news: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // =============================================================
  // 🔹 Refresh semua berita
  // =============================================================
  Future<void> refreshNews() async {
    await fetchTopHeadlines();
    await fetchHotNews();
  }

  // =============================================================
  // 🔹 Pilih kategori
  // =============================================================
  void selectCategory(String category) {
    if (_selectedCategory.value != category) {
      _selectedCategory.value = category;
      fetchTopHeadlines(category: category);
      fetchHotNews(); // sekalian update hot news
    }
  }

  // =============================================================
  // 🔹 Fitur Search
  // =============================================================
  Future<void> searchNews(String query) async {
    if (query.isEmpty) return;

    try {
      _isLoading.value = true;
      _error.value = '';

      final response = await _newsServices.searchNews(query: query);
      _articles.value = response.articles;
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to search news: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }
}
