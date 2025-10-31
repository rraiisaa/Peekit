class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  final String? newsUrl;
  bool isRead;
  bool isSelected; 

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    this.newsUrl,
    this.isRead = false,
    this.isSelected = false, 
  });
}
