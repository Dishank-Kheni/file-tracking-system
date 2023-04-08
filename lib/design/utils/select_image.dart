import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fts_mobile/core/utils/core_constants.dart';
import 'package:fts_mobile/design/components/c_core_button.dart';
import 'package:fts_mobile/design/utils/design_utils.dart';

Image noImage({
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
}) =>
    selectImage(
      setldImageIcon(AppImages.logo),
      height: height,
      width: width,
      fit: fit,
    );

/// To select which Image/Icon being used in current mode
String setldImageIcon(
  String lightImageIcon, [
  String? darkImageIcon,
]) =>
    darkImageIcon != null && isDarkMode ? darkImageIcon : lightImageIcon;

Image selectImage(
  String image, {
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
}) {
  return Image.asset(
    image,
    fit: fit,
    width: width,
    height: height,
  );
}

Image selectFileImage(String? image,
    {BoxFit fit = BoxFit.cover, double? height, double? width}) {
  return ((image != null && image.isEmpty) || image == null)
      ? noImage()
      : Image.file(
          File(image),
          fit: fit,
          width: width,
          height: height,
        );
}

ImageProvider selectImageProvider(String? image) {
  return image == null
      ? selectImageProvider(AppImages.logo)
      : AssetImage(image);
}

ImageProvider selectFileProvider(String? image) {
  return image == null
      ? selectImageProvider(AppImages.logo)
      : FileImage(File(image));
}

ImageProvider selectNetworkImageProvider({
  String? image,
  String? defaultImage,
}) {
  return ((image != null && image.isEmpty) || image == null)
      ? selectImageProvider(defaultImage ?? AppImages.logo)
      : NetworkImage(image);
}

Widget selectIcon(
  String icon, {
  double? width,
  Color? color,
  void Function()? onPressed,
}) {
  return CCoreButton(
    onPressed: onPressed,
    child: SvgPicture.asset(
      icon,
      width: width,
      height: width,
      color: color,
    ),
  );
}

Widget networkImage({
  String? image,
  BoxFit fit = BoxFit.cover,
  double? height,
  double? width,
  double borderRadius = 0,
  bool showDefaultImage = true,
}) {
  return (isNullEmptyOrFalse(image) || image == null && showDefaultImage)
      ? noImage(
          fit: fit,
          width: width,
          height: height,
        )
      : ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: CachedNetworkImage(
            imageUrl: image ?? '',
            height: height,
            width: width,
            fit: fit,
            placeholder: (context, url) =>
                Center(child: defaultLoader(color: getColor21)),
            errorWidget: (context, url, error) => const Icon(
              CupertinoIcons.exclamationmark_circle,
              color: CupertinoColors.destructiveRed,
            ),
          ),
        );
}
