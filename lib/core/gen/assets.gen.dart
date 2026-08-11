// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/Polygon 1.svg
  SvgGenImage get polygon1 => const SvgGenImage('assets/icons/Polygon 1.svg');

  /// File path: assets/icons/arrow_left.png
  AssetGenImage get arrowLeft =>
      const AssetGenImage('assets/icons/arrow_left.png');

  /// File path: assets/icons/arrow_right.png
  AssetGenImage get arrowRight =>
      const AssetGenImage('assets/icons/arrow_right.png');

  /// File path: assets/icons/earth.png
  AssetGenImage get earth => const AssetGenImage('assets/icons/earth.png');

  /// File path: assets/icons/home.png
  AssetGenImage get home => const AssetGenImage('assets/icons/home.png');

  /// File path: assets/icons/roller-paint-brush.png
  AssetGenImage get rollerPaintBrush =>
      const AssetGenImage('assets/icons/roller-paint-brush.png');

  /// File path: assets/icons/search_icon.png
  AssetGenImage get searchIcon =>
      const AssetGenImage('assets/icons/search_icon.png');

  /// List of all assets
  List<dynamic> get values => [
    polygon1,
    arrowLeft,
    arrowRight,
    earth,
    home,
    rollerPaintBrush,
    searchIcon,
  ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/Frame 10.png
  AssetGenImage get frame10 =>
      const AssetGenImage('assets/images/Frame 10.png');

  /// File path: assets/images/Frame 11.png
  AssetGenImage get frame11 =>
      const AssetGenImage('assets/images/Frame 11.png');

  /// File path: assets/images/Frame 12.png
  AssetGenImage get frame12 =>
      const AssetGenImage('assets/images/Frame 12.png');

  /// File path: assets/images/Frame 13.png
  AssetGenImage get frame13 =>
      const AssetGenImage('assets/images/Frame 13.png');

  /// File path: assets/images/Frame 14.png
  AssetGenImage get frame14 =>
      const AssetGenImage('assets/images/Frame 14.png');

  /// File path: assets/images/Frame 15.png
  AssetGenImage get frame15 =>
      const AssetGenImage('assets/images/Frame 15.png');

  /// File path: assets/images/Frame 16.png
  AssetGenImage get frame16 =>
      const AssetGenImage('assets/images/Frame 16.png');

  /// File path: assets/images/busniess.png
  AssetGenImage get busniess =>
      const AssetGenImage('assets/images/busniess.png');

  /// File path: assets/images/dark_logo.png
  AssetGenImage get darkLogo =>
      const AssetGenImage('assets/images/dark_logo.png');

  /// File path: assets/images/entertainment.png
  AssetGenImage get entertainment =>
      const AssetGenImage('assets/images/entertainment.png');

  /// File path: assets/images/general.png
  AssetGenImage get general => const AssetGenImage('assets/images/general.png');

  /// File path: assets/images/helth.png
  AssetGenImage get helth => const AssetGenImage('assets/images/helth.png');

  /// File path: assets/images/main_logo.png
  AssetGenImage get mainLogo =>
      const AssetGenImage('assets/images/main_logo.png');

  /// File path: assets/images/science.png
  AssetGenImage get science => const AssetGenImage('assets/images/science.png');

  /// File path: assets/images/sport.png
  AssetGenImage get sport => const AssetGenImage('assets/images/sport.png');

  /// File path: assets/images/technology.png
  AssetGenImage get technology =>
      const AssetGenImage('assets/images/technology.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    frame10,
    frame11,
    frame12,
    frame13,
    frame14,
    frame15,
    frame16,
    busniess,
    darkLogo,
    entertainment,
    general,
    helth,
    mainLogo,
    science,
    sport,
    technology,
  ];
}

abstract final class Assets {
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

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
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
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

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    _svg.ColorMapper? colorMapper,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
        colorMapper: colorMapper,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
