class WebItem {
  final String id;
  final String title;
  final String subtitle;
  final String image;

  WebItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  factory WebItem.fromJson(Map<String, dynamic> json) {
    return WebItem(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      image: json['image'],
    );
  }
}
