import 'dart:io';

import 'package:fire_guard/service/admob/admob_ids.dart';
import 'package:fire_guard/service/admob/admob_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget({super.key});

  @override
  State<NativeAdWidget> createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
  static double get _templateHeight => Platform.isIOS ? 101 : 90;

  NativeAd? _nativeAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  Future<void> _loadAd() async {
    final canLoad = await AdMobService.instance.adsReady;
    if (!canLoad || !mounted) return;

    final ad = NativeAd(
      adUnitId: AdMobIds.nativeAdUnitId,
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _nativeAd = ad as NativeAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('AdMob Native load failed: $error');
          ad.dispose();
        },
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
        mainBackgroundColor: Colors.white,
        cornerRadius: 10,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: Colors.orange,
          size: 14,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black87,
          size: 15,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: Colors.black54,
          size: 13,
        ),
      ),
    );
    _nativeAd = ad;
    try {
      await ad.load();
    } catch (error) {
      debugPrint('AdMob Native load failed: $error');
      await ad.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ad = _nativeAd;
    if (!_isLoaded || ad == null) return const SizedBox.shrink();

    return Semantics(
      label: 'Quảng cáo',
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: _templateHeight,
          width: double.infinity,
          child: AdWidget(ad: ad),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }
}
