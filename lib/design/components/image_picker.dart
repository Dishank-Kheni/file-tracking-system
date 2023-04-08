import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fts_mobile/design/components/bg_blur.dart';
import 'package:fts_mobile/design/components/c_core_button.dart';
import 'package:fts_mobile/design/utils/design_utils.dart';
import 'package:fts_mobile/utils/extensions.dart';

class CImagePicker extends StatelessWidget {
  final String? imageUrl;
  final bool isImageUploading;
  final Function()? onPickImage;
  final Function()? onRemoveImage;
  final FilePickerResult? pickedFiles;
  const CImagePicker({
    Key? key,
    this.imageUrl,
    this.pickedFiles,
    this.onPickImage,
    this.onRemoveImage,
    this.isImageUploading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CCoreButton(
            onPressed: onPickImage,
            child: SizedBox(
              width: 85,
              height: 85,
              child: (imageUrl != null && (imageUrl?.isNotEmpty ?? false)) &&
                      pickedFiles == null
                  ? SizedBox.expand(
                      child: networkImage(
                        image: imageUrl,
                        borderRadius: 12,
                        showDefaultImage: false,
                      ),
                    ).dottedBorder()
                  : pickedFiles == null
                      ? Center(
                          child: selectIcon(
                            setldImageIcon(AppIcons.add),
                            color: getColor11,
                          ),
                        ).dottedBorder()
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: selectFileProvider(
                                    pickedFiles?.files.single.path,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ).dottedBorder(),
                            isImageUploading
                                ? Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      color: getColor11.withOpacity(.4),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: defaultLoader(color: getColor21),
                                  )
                                : const SizedBox(),
                          ],
                        ),
            ),
          ),
          if (imageUrl != null && (imageUrl?.isNotEmpty ?? false) ||
              pickedFiles != null)
            Positioned(
              right: 5,
              top: 5,
              child: BgBlur(
                borderRadius: BorderRadius.circular(60),
                child: selectIcon(
                  setldImageIcon(AppIcons.cross),
                  width: 8,
                  color: getColor11,
                  onPressed: onRemoveImage,
                ).all(4),
              ),
            ),
        ],
      ),
    );
  }
}
