// lib/repository/portfolio_repository_impl.dart
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
        appStoreUrl: 'https://github.com/IsaamMJ/NewsXWeather-Flutter',
        playStoreUrl: 'https://github.com/IsaamMJ/NewsXWeather-Flutter',
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
    downloads: 'N/A',
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
        technologies: ["Wix", "CSS3"],
        themeColor: Colors.blue,
        completionYear: "2021",
      ),
      WebsiteData(
        title: "Maintenance Portal",
        subtitle: "Cross-platform Flutter App for Managing Work Orders",
        description: "A responsive and secure Flutter web app designed for maintenance operations like managing work orders and viewing system notifications. Integrates with a Node.js backend and uses JWT-based authentication. Built with clean architecture and GetX state management.",
        imageAsset: "assets/mp.png",
        websiteUrl: "https://github.com/IsaamMJ/P4Flutter",
        category: "ERP",
        technologies: ["Flutter", "Node.js", "JWT", "GetX", "Lottie", "GoogleFonts"],
        themeColor: Colors.purple,
        completionYear: "2025",
      ),
      WebsiteData(
        title: "Zenith Bliss",
        subtitle: "Smart Recruiting Software",
        description: "Zenith Bliss is an intelligent recruiting platform developed to streamline and simplify the hiring process. Built using HTML, CSS, Bootstrap, and Firebase, it integrates advanced AI capabilities powered by Gemini 1.5 to assist in screening candidates, managing applications, and automating decision workflows. Deployed on Vercel, the system offers a seamless and responsive user experience for both recruiters and applicants.",
        imageAsset: "assets/zenith_bliss.png",
        websiteUrl: "https://zenith-bliss.vercel.app/",
        category: "HRMS",
        technologies: ["HTML", "CSS", "Bootstrap", "Firebase", "Vercel", "Gemini 1.5"],
        themeColor: Colors.pink,
        completionYear: "2023",
      ),

    ];
  }
}