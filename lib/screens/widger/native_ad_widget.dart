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
        margin: const EdgeInsets.only(bottom: 16),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Text(
                'Quảng cáo',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: 110,
              width: double.infinity,
              child: AdWidget(ad: ad),
            ),
          ],
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
