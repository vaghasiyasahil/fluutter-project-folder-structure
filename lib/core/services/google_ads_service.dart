import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';

import '../../export.dart';

class GoogleAdsService {
  static GoogleAdsService get to => Get.find();

  final Logger _logger = Logger();

  // Test Ad Unit IDs (replace with real ones in production)
  static const String _androidBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _iosBannerAdUnitId =
      'ca-app-pub-3940256099942544/2934735716';

  static const String _androidInterstitialAdUnitId = "ca-app-pub-3940256099942544/1033173712";
  static const String _iosInterstitialAdUnitId = "ca-app-pub-3940256099942544/4411468910";

  
  static const String _androidRewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917';
  static const String _iosRewardedAdUnitId =
      'ca-app-pub-3940256099942544/1712485313';

  // Current ads
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  // Ad loading states
  final RxBool _isBannerAdLoaded = false.obs;
  final RxBool _isInterstitialAdLoaded = false.obs;
  final RxBool _isRewardedAdLoaded = false.obs;

  // Getters for ad states
  bool get isBannerAdLoaded => _isBannerAdLoaded.value;
  bool get isInterstitialAdLoaded => _isInterstitialAdLoaded.value;
  bool get isRewardedAdLoaded => _isRewardedAdLoaded.value;

  BannerAd? get bannerAd => _bannerAd;

  Future<void> onInit() async {
    await MobileAds.instance.initialize();
    await _initializeAds();
  }

  Future<void> _initializeAds() async {
    // Load ads
    loadBannerAd();
    loadInterstitialAd();
    loadRewardedAd();
  }

  // Banner Ad Methods
  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: _getBannerAdUnitId(),
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          _isBannerAdLoaded.value = true;
          _logger.i('Banner ad loaded successfully');
        },
        onAdFailedToLoad: (ad, error) {
          _logger.e('Banner ad failed to load: $error');
          ad.dispose();
          _isBannerAdLoaded.value = false;
        },
        onAdOpened: (_) => _logger.i('Banner ad opened'),
        onAdClosed: (_) => _logger.i('Banner ad closed'),
      ),
    );
    _bannerAd?.load();
  }

  void disposeBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _isBannerAdLoaded.value = false;
  }

  // Interstitial Ad Methods
  void loadInterstitialAd() {
    if(_getInterstitialAdUnitId()==null){
      return;
    }
    InterstitialAd.load(
      adUnitId: _getInterstitialAdUnitId()??'',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoaded.value = true;
          _logger.i('Interstitial ad loaded successfully');

          _interstitialAd?.fullScreenContentCallback =
            FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialAdLoaded.value = false;
              loadInterstitialAd(); // Load next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              _logger.e('Interstitial ad failed to show: $error');
              ad.dispose();
              _interstitialAd = null;
              _isInterstitialAdLoaded.value = false;
              loadInterstitialAd(); // Load next ad
            },
          );
        },
        onAdFailedToLoad: (error) {
          _logger.e('Interstitial ad failed to load: $error');
          _isInterstitialAdLoaded.value = false;
        },
      ),
    );
  }

  void showInterstitialAd({VoidCallback? onAdClosed}) {
    if (_interstitialAd != null && _isInterstitialAdLoaded.value) {
      _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialAdLoaded.value = false;
          loadInterstitialAd();
          onAdClosed?.call();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          _logger.e('Interstitial ad failed to show: $error');
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialAdLoaded.value = false;
          loadInterstitialAd(); // Load next ad
          onAdClosed?.call();
        },
      );
      _interstitialAd?.show();
    } else {
      _logger.w('Interstitial ad is not ready');
      onAdClosed?.call();
    }
  }

  // Rewarded Ad Methods
  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: _getRewardedAdUnitId(),
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedAdLoaded.value = true;
          _logger.i('Rewarded ad loaded successfully');
        },
        onAdFailedToLoad: (error) {
          _logger.e('Rewarded ad failed to load: $error');
          _isRewardedAdLoaded.value = false;
        },
      ),
    );
  }

  void showRewardedAd({
    required OnUserEarnedRewardCallback onUserEarnedReward,
    VoidCallback? onAdClosed,
  }) {
    if (_rewardedAd != null && _isRewardedAdLoaded.value) {
      _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _rewardedAd = null;
          _isRewardedAdLoaded.value = false;
          loadRewardedAd(); // Load next ad
          onAdClosed?.call();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          _logger.e('Rewarded ad failed to show: $error');
          ad.dispose();
          _rewardedAd = null;
          _isRewardedAdLoaded.value = false;
          loadRewardedAd(); // Load next ad
          onAdClosed?.call();
        },
      );

      _rewardedAd?.show(onUserEarnedReward: onUserEarnedReward);
    } else {
      _logger.w('Rewarded ad is not ready');
      onAdClosed?.call();
    }
  }

  // Helper methods to get platform-specific ad unit IDs
  String _getBannerAdUnitId() {
    return Platform.isAndroid ? _androidBannerAdUnitId : _iosBannerAdUnitId;
  }

  String? _getInterstitialAdUnitId() {
    return Platform.isAndroid
        ? _androidInterstitialAdUnitId
        : _iosInterstitialAdUnitId;
  }

  String _getRewardedAdUnitId() {
    return Platform.isAndroid ? _androidRewardedAdUnitId : _iosRewardedAdUnitId;
  }

  void onClose() {
    disposeBannerAd();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}
