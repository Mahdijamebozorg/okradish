/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsPngGen {
  const $AssetsPngGen();

  /// File path: assets/png/Background.png
  AssetGenImage get background =>
      const AssetGenImage('assets/png/Background.png');

  /// File path: assets/png/BeforeAdding.png
  AssetGenImage get beforeAdding =>
      const AssetGenImage('assets/png/BeforeAdding.png');

  /// File path: assets/png/Splash.png
  AssetGenImage get splash => const AssetGenImage('assets/png/Splash.png');

  /// File path: assets/png/icon.png
  AssetGenImage get icon => const AssetGenImage('assets/png/icon.png');

  /// File path: assets/png/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/png/logo.png');

  /// File path: assets/png/plus.png
  AssetGenImage get plus => const AssetGenImage('assets/png/plus.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [background, beforeAdding, splash, icon, logo, plus];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/file-text.svg
  String get fileText => 'assets/svg/file-text.svg';

  /// File path: assets/svg/user.svg
  String get user => 'assets/svg/user.svg';

  /// List of all assets
  List<String> get values => [fileText, user];
}

class $AssetsVideoGen {
  const $AssetsVideoGen();

  /// File path: assets/video/back.mp4
  String get back => 'assets/video/back.mp4';

  /// List of all assets
  List<String> get values => [back];
}

class Assets {
  Assets._();

  static const $AssetsPngGen png = $AssetsPngGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
  static const $AssetsVideoGen video = $AssetsVideoGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
