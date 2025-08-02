// lib/repository/portfolio_repository.dart
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../models/app_data.dart';
import '../models/website_data.dart';

class PortfolioRepository {
  static final PortfolioRepository _instance = PortfolioRepository._internal();
  factory PortfolioRepository() => _instance;
  PortfolioRepository._internal();

  List<AppData> getApps() {
    return [
      AppData(
        id: 'skyfeed_001',
        name: 'SkyFeed',
        subtitle: 'Personalized News & Weather Forecasts',
        description:
        'Experience the perfect blend of real-time weather data and curated news content. Our AI-powered platform delivers personalized insights that matter to you, when you need them most.',
        imagePath: 'assets/skyfeed.png',
        rating: 5,
        downloads: 'N/A',
        price: 0.0,
        features: [
          'Real-time Updates',
          'AI Predictions',
          'Personalized',
          'Weather Alerts'
        ],
        categories: [
          'News',
          'Weather',
          'Productivity',
          'Lifestyle'
        ],
        appStoreUrl: 'https://apps.apple.com/app/skyfeed',
        playStoreUrl: 'https://play.google.com/store/apps/details?id=com.skyfeed.app',
      ),
      AppData(
        id: 'calculator_002',
        name: 'MyCalc',
        subtitle: 'A Basic Calculator App using GETX',
        description:
        'A lightweight, responsive calculator built with Flutter using GetX, MVVM, and Clean Architecture. Supports light/dark mode, fast state management, and clean code structure for easy scalability.',
        imagePath: 'assets/CalcApp.png', // Replace with your actual screenshot or logo
        rating: 5.0,
        downloads: 'N/A',
        price: 0.0,
        features: [
          'Dark & Light Mode Support',
          'Reactive State Management with GetX',
          'Clean Architecture (MVVM)',
          'Simple and Intuitive UI',
          'Fast Performance',
        ],
        categories: [
          'Utilities',
          'Productivity',
          'Tools',
          'Education',
        ],
        appStoreUrl: 'https://github.com/IsaamMJ/calculator_clean_getx_themed',
        playStoreUrl: 'https://github.com/IsaamMJ/calculator_clean_getx_themed',
      ),
    AppData(
    id: 'Ecom-MVP',
    name: 'E-Mart',
    subtitle: 'Your Smart Online Shopping Companion',
    description:
    'E-Mart is a modern Flutter-based e-commerce app built with GetX and Clean Architecture. Browse products, manage your cart, and experience seamless checkouts—all in real-time with persistent state and a clean codebase.',
    imagePath: 'assets/emart.png',
    rating: 4.5,
    downloads: '75K',
    price: 0.0,
    features: [
    'Live Product API Integration',
    'Add to Cart & Checkout',
    'Real-time Order Summary',
    'Persistent Navigation State',
    'Clean Architecture with GetX',
    ],
    categories: [
    'Shopping',
    'E-commerce',
    'Technology',
    'Flutter Apps',
    ],
    appStoreUrl: 'https://github.com/IsaamMJ/EcomApp-Flutter-E-commerce-App-with-GetX-Clean-Architecture',
    playStoreUrl: 'https://github.com/IsaamMJ/EcomApp-Flutter-E-commerce-App-with-GetX-Clean-Architecture',
    )
    ];
  }

  List<AppData> getFeaturedApps() => getApps().where((app) => app.rating >= 4.5).toList();
  List<AppData> getFreeApps() => getApps().where((app) => app.price == 0.0).toList();
  List<AppData> getPaidApps() => getApps().where((app) => app.price > 0.0).toList();

  AppData? getAppById(String id) {
    try {
      return getApps().firstWhere((app) => app.id == id);
    } catch (_) {
      return null;
    }
  }

  List<AppData> getAppsByCategory(String category) => getApps()
      .where((app) => app.categories.any((cat) => cat.toLowerCase().contains(category.toLowerCase())))
      .toList();

  List<AppData> searchApps(String query) {
    final q = query.toLowerCase();
    return getApps().where((app) =>
    app.name.toLowerCase().contains(q) ||
        app.subtitle.toLowerCase().contains(q) ||
        app.description.toLowerCase().contains(q) ||
        app.features.any((f) => f.toLowerCase().contains(q)) ||
        app.categories.any((c) => c.toLowerCase().contains(q))
    ).toList();
  }

  bool addApp(AppData app) => true;
  bool updateApp(AppData app) => true;
  bool deleteApp(String id) => true;

  List<AppData> getAppsByRating({bool descending = true}) {
    final apps = List<AppData>.from(getApps());
    apps.sort((a, b) => descending ? b.rating.compareTo(a.rating) : a.rating.compareTo(b.rating));
    return apps;
  }

  List<AppData> getAppsByPopularity({bool descending = true}) {
    final apps = List<AppData>.from(getApps());
    apps.sort((a, b) => descending
        ? _parseDownloads(b.downloads).compareTo(_parseDownloads(a.downloads))
        : _parseDownloads(a.downloads).compareTo(_parseDownloads(b.downloads)));
    return apps;
  }

  int _parseDownloads(String downloads) {
    final cleaned = downloads.replaceAll(RegExp(r'[^\d.]'), '');
    final number = double.tryParse(cleaned) ?? 0;
    if (downloads.toUpperCase().contains('K')) return (number * 1000).toInt();
    if (downloads.toUpperCase().contains('M')) return (number * 1000000).toInt();
    return number.toInt();
  }

  List<String> getAllCategories() {
    final Set<String> all = {};
    for (final app in getApps()) {
      all.addAll(app.categories);
    }
    return all.toList()..sort();
  }

  List<String> getAllFeatures() {
    final Set<String> all = {};
    for (final app in getApps()) {
      all.addAll(app.features);
    }
    return all.toList()..sort();
  }

  List<WebsiteData> getWebsites() {
    return [
      WebsiteData(
        title: "Pearl School",
        subtitle: "Educational Platform",
        description:
        "Designed and developed a dynamic and interactive website for a school using the Wix platform. Features include event management, contact forms, and an intuitive admin panel for seamless content updates.",
        imageAsset: "assets/pearl.png",
        websiteUrl: "https://www.pearlmatricschool.com/",
        category: "Education",
        technologies: ["Wix", "JavaScript", "CSS3"],
        themeColor: Colors.blue,
        completionYear: "2024",
      ),
      WebsiteData(
        title: "Portfolio Landing",
        subtitle: "Personal Branding",
        description:
        "A creative and responsive landing page for personal branding. Built with modern animations, clean layout, smooth scrolling, and optimized for all devices with stunning visual effects.",
        imageAsset: "assets/landing.png",
        websiteUrl: "https://portfolio.example.com",
        category: "Portfolio",
        technologies: ["React", "Framer Motion", "Tailwind"],
        themeColor: Colors.purple,
        completionYear: "2024",
      ),
      WebsiteData(
        title: "E-Commerce Store",
        subtitle: "Online Shopping Platform",
        description:
        "Full-featured e-commerce platform with payment integration, inventory management, and customer analytics. Built for scalability and performance with modern UI/UX principles.",
        imageAsset: "assets/ecommerce.png",
        websiteUrl: "https://store.example.com",
        category: "E-Commerce",
        technologies: ["Next.js", "Stripe", "MongoDB"],
        themeColor: Colors.green,
        completionYear: "2024",
      ),
    ];
  }
}