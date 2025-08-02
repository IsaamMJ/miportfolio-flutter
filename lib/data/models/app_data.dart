class AppData {
  final String id;
  final String name;
  final String subtitle;
  final String description;
  final String? imagePath;
  final double rating;
  final String downloads;
  final double price;
  final List<String> features;
  final List<String> categories;
  final String? appStoreUrl;
  final String? playStoreUrl;

  AppData({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.description,
    this.imagePath,
    required this.rating,
    required this.downloads,
    required this.price,
    this.features = const [],
    this.categories = const [],
    this.appStoreUrl,
    this.playStoreUrl,
  });

  factory AppData.fromJson(Map<String, dynamic> json) {
    return AppData(
      id: json['id'] as String,
      name: json['name'] as String,
      subtitle: json['subtitle'] as String,
      description: json['description'] as String,
      imagePath: json['imagePath'] as String?,
      rating: (json['rating'] as num).toDouble(),
      downloads: json['downloads'] as String,
      price: (json['price'] as num).toDouble(),
      features: List<String>.from(json['features'] ?? []),
      categories: List<String>.from(json['categories'] ?? []),
      appStoreUrl: json['appStoreUrl'] as String?,
      playStoreUrl: json['playStoreUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subtitle': subtitle,
      'description': description,
      'imagePath': imagePath,
      'rating': rating,
      'downloads': downloads,
      'price': price,
      'features': features,
      'categories': categories,
      'appStoreUrl': appStoreUrl,
      'playStoreUrl': playStoreUrl,
    };
  }

  AppData copyWith({
    String? id,
    String? name,
    String? subtitle,
    String? description,
    String? imagePath,
    double? rating,
    String? downloads,
    double? price,
    List<String>? features,
    List<String>? categories,
    String? appStoreUrl,
    String? playStoreUrl,
  }) {
    return AppData(
      id: id ?? this.id,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      rating: rating ?? this.rating,
      downloads: downloads ?? this.downloads,
      price: price ?? this.price,
      features: features ?? this.features,
      categories: categories ?? this.categories,
      appStoreUrl: appStoreUrl ?? this.appStoreUrl,
      playStoreUrl: playStoreUrl ?? this.playStoreUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppData &&
        other.id == id &&
        other.name == name &&
        other.subtitle == subtitle &&
        other.description == description &&
        other.imagePath == imagePath &&
        other.rating == rating &&
        other.downloads == downloads &&
        other.price == price;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    subtitle.hashCode ^
    description.hashCode ^
    imagePath.hashCode ^
    rating.hashCode ^
    downloads.hashCode ^
    price.hashCode;
  }

  @override
  String toString() {
    return 'AppData(id: $id, name: $name, subtitle: $subtitle, rating: $rating)';
  }
}