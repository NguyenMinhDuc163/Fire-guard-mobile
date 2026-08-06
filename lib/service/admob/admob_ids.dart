import 'dart:io';

import 'package:flutter/foundation.dart';

class AdMobIds {
  AdMobIds._();

  static const String _androidAppOpenAdUnitId =
      'ca-app-pub-4649011658078977/8195077952';
  static const String _androidBannerAdUnitId =
      'ca-app-pub-4649011658078977/4272410741';
  static const String _androidInterstitialAdUnitId =
      'ca-app-pub-4649011658078977/6655031507';
  static const String _androidNativeAdUnitId =
      'ca-app-pub-4649011658078977/5341949839';
  static const String _iosAppOpenAdUnitId =
      'ca-app-pub-4649011658078977/1441967343';
  static const String _iosBannerAdUnitId =
      'ca-app-pub-4649011658078977/1336477405';
  static const String _iosInterstitialAdUnitId =
      'ca-app-pub-4649011658078977/9975063489';
  static const String _iosNativeAdUnitId =
      'ca-app-pub-4649011658078977/1183212972';

  static String get appOpenAdUnitId {
    if (Platform.isAndroid) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/9257395921'
          : _androidAppOpenAdUnitId;
    }
    if (Platform.isIOS) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/5575463023'
          : _iosAppOpenAdUnitId;
    }
    return '';
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/6300978111'
          : _androidBannerAdUnitId;
    }
    if (Platform.isIOS) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/2934735716'
          : _iosBannerAdUnitId;
    }
    return '';
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/1033173712'
          : _androidInterstitialAdUnitId;
    }
    if (Platform.isIOS) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/4411468910'
          : _iosInterstitialAdUnitId;
    }
    return '';
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/2247696110'
          : _androidNativeAdUnitId;
    }
    if (Platform.isIOS) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/3986624511'
          : _iosNativeAdUnitId;
    }
    return '';
  }
}
