import 'package:fire_guard/service/admob/admob_ids.dart';
import 'package:fire_guard/service/admob/admob_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isLoadScheduled = false;
  int? _requestedWidth;
  int _loadGeneration = 0;

  Future<void> _loadAd(int width) async {
    final generation = ++_loadGeneration;
    _isLoadScheduled = false;
    _requestedWidth = width;

    final previousAd = _bannerAd;
    _bannerAd = null;
    if (_isLoaded && mounted) {
      setState(() => _isLoaded = false);
    } else {
      _isLoaded = false;
    }
    try {
      await previousAd?.dispose();
    } catch (error) {
      debugPrint('AdMob Banner dispose failed: $error');
    }

    final canLoad = await AdMobService.instance.adsReady;
    if (!canLoad || !mounted || generation != _loadGeneration) return;

    AnchoredAdaptiveBannerAdSize? size;
    try {
      size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        width,
      );
    } catch (error) {
      debugPrint('AdMob Banner size lookup failed: $error');
      return;
    }
    if (size == null || !mounted || generation != _loadGeneration) return;

    final ad = BannerAd(
      adUnitId: AdMobIds.bannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted || generation != _loadGeneration) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('AdMob Banner load failed: $error');
          ad.dispose();
        },
      ),
    );
    _bannerAd = ad;
    try {
      await ad.load();
    } catch (error) {
      debugPrint('AdMob Banner load failed: $error');
      await ad.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AdMobService.instance.adsEnabledListenable,
      builder: (context, adsEnabled, child) {
        if (!adsEnabled) return const SizedBox.shrink();

        return LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth.floor()
                : MediaQuery.sizeOf(context).width.floor();

            if (availableWidth > 0 &&
                availableWidth != _requestedWidth &&
                !_isLoadScheduled) {
              _isLoadScheduled = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) _loadAd(availableWidth);
              });
            }

            final ad = _bannerAd;
            if (!_isLoaded || ad == null) return const SizedBox.shrink();

            return SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: ad.size.height.toDouble(),
                child: Center(
                  child: SizedBox(
                    width: ad.size.width.toDouble(),
                    height: ad.size.height.toDouble(),
                    child: AdWidget(ad: ad),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
