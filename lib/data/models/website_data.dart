// lib/models/website_data.dart
import 'package:flutter/material.dart';

class WebsiteData {
  final String title;
  final String subtitle;
  final String description;
  final String imageAsset;
  final String websiteUrl;
  final String category;
  final List<String> technologies;
  final Color themeColor;
  final String completionYear;

  WebsiteData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageAsset,
    required this.websiteUrl,
    required this.category,
    required this.technologies,
    required this.themeColor,
    required this.completionYear,
  });

  // Optional: Add methods for data manipulation
  WebsiteData copyWith({
    String? title,
    String? subtitle,
    String? description,
    String? imageAsset,
    String? websiteUrl,
    String? category,
    List<String>? technologies,
    Color? themeColor,
    String? completionYear,
  }) {
    return WebsiteData(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      imageAsset: imageAsset ?? this.imageAsset,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      category: category ?? this.category,
      technologies: technologies ?? this.technologies,
      themeColor: themeColor ?? this.themeColor,
      completionYear: completionYear ?? this.completionYear,
    );
  }

  // Optional: Convert to/from JSON if needed for persistence
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'imageAsset': imageAsset,
      'websiteUrl': websiteUrl,
      'category': category,
      'technologies': technologies,
      'themeColor': themeColor.value,
      'completionYear': completionYear,
    };
  }

  factory WebsiteData.fromJson(Map<String, dynamic> json) {
    return WebsiteData(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      imageAsset: json['imageAsset'] ?? '',
      websiteUrl: json['websiteUrl'] ?? '',
      category: json['category'] ?? '',
      technologies: List<String>.from(json['technologies'] ?? []),
      themeColor: Color(json['themeColor'] ?? Colors.blue.value),
      completionYear: json['completionYear'] ?? '',
    );
  }

  @override
  String toString() {
    return 'WebsiteData(title: $title, category: $category, completionYear: $completionYear)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WebsiteData &&
        other.title == title &&
        other.websiteUrl == websiteUrl;
  }

  @override
  int get hashCode {
    return title.hashCode ^ websiteUrl.hashCode;
  }
}