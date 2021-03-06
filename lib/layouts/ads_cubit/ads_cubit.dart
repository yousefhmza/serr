import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:serr_app/layouts/ads_cubit/ads_states.dart';

class AdCubit extends Cubit<AdsStates> {
  Future<InitializationStatus> initialization;

  AdCubit(this.initialization) : super(AdsInitialState());

  BannerAd? bannerAd;

  BannerAdListener _bannerAdListener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );

  BannerAdListener get bannerAdListener => _bannerAdListener;

  String get bannerAdUnitId =>
      Platform.isAndroid ? 'ca-app-pub-3940256099942544/6300978111' : '';

  loadAd() {
    try {
      return initialization.then((value) {
        bannerAd = BannerAd(
          size: AdSize.fullBanner,
          adUnitId: bannerAdUnitId,
          listener: bannerAdListener,
          request: AdRequest(),
        )..load();
        emit(AdBannerLoadedState());
      });
    } catch (e) {
      print(e);
      emit(AdBannerFailureState());
    }
  }
}
