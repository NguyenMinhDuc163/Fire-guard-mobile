import 'dart:async';

import 'package:fire_guard/service/admob/admob_ids.dart';
import 'package:fire_guard/utils/core/helpers/local_storage_helper.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdManager with WidgetsBindingObserver {
  AppOpenAdManager({
    required this.canShowFullScreenAd,
    required this.onFullScreenAdOpening,
    required this.onFullScreenAdShown,
    required this.onFullScreenAdClosed,
  });

  static const int minimumLaunchCount = 2;
  static const Duration minimumInterval = Duration(hours: 4);
  static const Duration _maximumAdAge = Duration(hours: 4);
  static const String _launchCountKey = 'admobLaunchCount';
  static const String _lastShownAtKey = 'admobAppOpenLastShownAt';

  final bool Function() canShowFullScreenAd;
  final VoidCallback onFullScreenAdOpening;
  final VoidCallback onFullScreenAdShown;
  final VoidCallback onFullScreenAdClosed;

  AppOpenAd? _appOpenAd;
  DateTime? _loadedAt;
  bool _isLoading = false;
  bool _isShowing = false;
  bool _isStarted = false;
  bool _suppressNextAppOpenAd = false;
  bool _wasIntroCompletedBeforeLaunch = false;
  int _launchCount = 0;

  void recordLaunch() {
    _wasIntroCompletedBeforeLaunch =
        LocalStorageHelper.getValue('ignoreIntroScreen') == true;
    _launchCount =
        (LocalStorageHelper.getValue(_launchCountKey) as int? ?? 0) + 1;
    LocalStorageHelper.setValue(_launchCountKey, _launchCount);
  }

  void start() {
    if (_isStarted) return;
    _isStarted = true;
    WidgetsBinding.instance.addObserver(this);
    loadAd();
  }

  void suppressNextAppOpenAd() {
    _suppressNextAppOpenAd = true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;

    if (_suppressNextAppOpenAd) {
      _suppressNextAppOpenAd = false;
      return;
    }

    showAdIfAvailable();
  }

  void loadAd() {
    if (!_isStarted || _isLoading || _appOpenAd != null) return;

    _isLoading = true;
    unawaited(
      AppOpenAd.load(
        adUnitId: AdMobIds.appOpenAdUnitId,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            _isLoading = false;
            if (!_isStarted) {
              ad.dispose();
              return;
            }
            _appOpenAd = ad;
            _loadedAt = DateTime.now();
            showAdIfAvailable();
          },
          onAdFailedToLoad: (error) {
            _isLoading = false;
            debugPrint('AdMob App Open load failed: $error');
          },
        ),
      ).catchError((Object error) {
        _isLoading = false;
        debugPrint('AdMob App Open load failed: $error');
      }),
    );
  }

  void showAdIfAvailable() {
    if (!_isStarted) return;

    if (!_isEligibleToShow()) {
      if (_appOpenAd == null) loadAd();
      return;
    }

    final ad = _appOpenAd!;
    _appOpenAd = null;
    _isShowing = true;
    onFullScreenAdOpening();

    var isFinished = false;

    void finishAd() {
      if (isFinished) return;
      isFinished = true;
      ad.dispose();
      _finishShowing();
    }

    ad.fullScreenContentCallback = FullScreenContentCallback<AppOpenAd>(
      onAdShowedFullScreenContent: (_) {
        onFullScreenAdShown();
        LocalStorageHelper.setValue(
          _lastShownAtKey,
          DateTime.now().millisecondsSinceEpoch,
        );
      },
      onAdDismissedFullScreenContent: (_) => finishAd(),
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('AdMob App Open show failed: $error');
        finishAd();
      },
    );
    try {
      unawaited(
        ad.show().catchError((Object error) {
          debugPrint('AdMob App Open show failed: $error');
          finishAd();
        }),
      );
    } catch (error) {
      debugPrint('AdMob App Open show failed: $error');
      finishAd();
    }
  }

  bool _isEligibleToShow() {
    if (!_wasIntroCompletedBeforeLaunch ||
        _launchCount < minimumLaunchCount ||
        _suppressNextAppOpenAd ||
        _isShowing ||
        !canShowFullScreenAd() ||
        _appOpenAd == null ||
        WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
      return false;
    }

    final loadedAt = _loadedAt;
    if (loadedAt == null ||
        DateTime.now().difference(loadedAt) > _maximumAdAge) {
      _appOpenAd?.dispose();
      _appOpenAd = null;
      _loadedAt = null;
      loadAd();
      return false;
    }

    final lastShownMilliseconds =
        LocalStorageHelper.getValue(_lastShownAtKey) as int?;
    if (lastShownMilliseconds == null) return true;

    final lastShown =
        DateTime.fromMillisecondsSinceEpoch(lastShownMilliseconds);
    return DateTime.now().difference(lastShown) >= minimumInterval;
  }

  void _finishShowing() {
    if (!_isShowing) return;
    _isShowing = false;
    onFullScreenAdClosed();
    loadAd();
  }

  void dispose() {
    if (_isStarted) {
      WidgetsBinding.instance.removeObserver(this);
      _isStarted = false;
    }
    _appOpenAd?.dispose();
    _appOpenAd = null;
    _loadedAt = null;
  }
}
