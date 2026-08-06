import 'dart:async';
import 'dart:io';

import 'package:fire_guard/service/admob/admob_ids.dart';
import 'package:fire_guard/service/admob/app_open_ad_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  AdMobService._() {
    _appOpenAdManager = AppOpenAdManager(
      canShowFullScreenAd: _canShowAppOpenAd,
      onFullScreenAdOpening: _markFullScreenAdOpening,
      onFullScreenAdShown: _markFullScreenAdShown,
      onFullScreenAdClosed: _markFullScreenAdClosed,
    );
  }

  static final AdMobService instance = AdMobService._();

  static const int contentThreshold = 2;
  static const Duration minimumInterval = Duration(seconds: 90);
  static const int maximumPerSession = 3;

  late final AppOpenAdManager _appOpenAdManager;
  Future<bool>? _initialization;
  InterstitialAd? _interstitialAd;
  bool _isLoadingInterstitial = false;
  bool _isFullScreenAdShowing = false;
  int _completedContentCount = 0;
  int _interstitialsShownThisSession = 0;
  DateTime? _lastFullScreenAdShownAt;

  Future<bool> get adsReady => _initialization ?? Future.value(false);

  Future<bool> initialize() {
    final existingInitialization = _initialization;
    if (existingInitialization != null) return existingInitialization;

    _appOpenAdManager.recordLaunch();
    final initialization = _initializeAds();
    _initialization = initialization;
    return initialization;
  }

  Future<bool> _initializeAds() async {
    if (!Platform.isAndroid && !Platform.isIOS) return false;

    try {
      final canRequestAds = await _requestConsent();
      if (!canRequestAds) return false;

      await MobileAds.instance.initialize();
      _loadInterstitial();
      _appOpenAdManager.start();
      return true;
    } catch (error, stackTrace) {
      debugPrint('AdMob initialization failed: $error\n$stackTrace');
      return false;
    }
  }

  Future<bool> _requestConsent() {
    final completer = Completer<bool>();

    Future<bool> canRequestAdsSafely() async {
      try {
        return await ConsentInformation.instance.canRequestAds();
      } catch (error) {
        debugPrint('AdMob consent status check failed: $error');
        return false;
      }
    }

    Future<void> finishConsentFlow() async {
      try {
        await ConsentForm.loadAndShowConsentFormIfRequired((formError) {
          if (formError != null) {
            debugPrint('AdMob consent form failed: $formError');
          }
        });
        final canRequestAds = await canRequestAdsSafely();
        if (!completer.isCompleted) completer.complete(canRequestAds);
      } catch (error) {
        debugPrint('AdMob consent flow failed: $error');
        final canRequestAds = await canRequestAdsSafely();
        if (!completer.isCompleted) completer.complete(canRequestAds);
      }
    }

    try {
      ConsentInformation.instance.requestConsentInfoUpdate(
        ConsentRequestParameters(),
        () => unawaited(finishConsentFlow()),
        (formError) async {
          debugPrint('AdMob consent update failed: $formError');
          final canRequestAds = await canRequestAdsSafely();
          if (!completer.isCompleted) completer.complete(canRequestAds);
        },
      );
    } catch (error) {
      debugPrint('AdMob consent update failed: $error');
      unawaited(
        canRequestAdsSafely().then((canRequestAds) {
          if (!completer.isCompleted) completer.complete(canRequestAds);
        }),
      );
    }

    return completer.future;
  }

  void recordContentCompleted() {
    _completedContentCount++;
    if (_completedContentCount < contentThreshold) return;

    if (_tryShowInterstitial()) {
      _completedContentCount = 0;
    }
  }

  bool _tryShowInterstitial() {
    final ad = _interstitialAd;
    if (ad == null ||
        _isFullScreenAdShowing ||
        _interstitialsShownThisSession >= maximumPerSession ||
        !_hasMinimumIntervalElapsed()) {
      return false;
    }

    _interstitialAd = null;
    _markFullScreenAdOpening();

    var isFinished = false;

    void finishAd() {
      if (isFinished) return;
      isFinished = true;
      ad.dispose();
      _markFullScreenAdClosed();
      _loadInterstitial();
    }

    ad.fullScreenContentCallback = FullScreenContentCallback<InterstitialAd>(
      onAdShowedFullScreenContent: (_) {
        _interstitialsShownThisSession++;
        _markFullScreenAdShown();
      },
      onAdDismissedFullScreenContent: (ad) {
        finishAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('AdMob Interstitial show failed: $error');
        finishAd();
      },
    );
    try {
      unawaited(
        ad.show().catchError((Object error) {
          debugPrint('AdMob Interstitial show failed: $error');
          finishAd();
        }),
      );
    } catch (error) {
      debugPrint('AdMob Interstitial show failed: $error');
      finishAd();
    }
    return true;
  }

  void _loadInterstitial() {
    if (_isLoadingInterstitial || _interstitialAd != null) return;

    _isLoadingInterstitial = true;
    unawaited(
      InterstitialAd.load(
        adUnitId: AdMobIds.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _isLoadingInterstitial = false;
            _interstitialAd = ad;
          },
          onAdFailedToLoad: (error) {
            _isLoadingInterstitial = false;
            debugPrint('AdMob Interstitial load failed: $error');
          },
        ),
      ).catchError((Object error) {
        _isLoadingInterstitial = false;
        debugPrint('AdMob Interstitial load failed: $error');
      }),
    );
  }

  bool _canShowAppOpenAd() {
    return !_isFullScreenAdShowing && _hasMinimumIntervalElapsed();
  }

  bool _hasMinimumIntervalElapsed() {
    final lastShownAt = _lastFullScreenAdShownAt;
    return lastShownAt == null ||
        DateTime.now().difference(lastShownAt) >= minimumInterval;
  }

  void _markFullScreenAdOpening() {
    _isFullScreenAdShowing = true;
  }

  void _markFullScreenAdShown() {
    _lastFullScreenAdShownAt = DateTime.now();
  }

  void _markFullScreenAdClosed() {
    _isFullScreenAdShowing = false;
  }

  void suppressNextAppOpenAd() {
    _appOpenAdManager.suppressNextAppOpenAd();
  }

  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _appOpenAdManager.dispose();
  }
}
