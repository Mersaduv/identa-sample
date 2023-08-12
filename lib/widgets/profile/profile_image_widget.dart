import 'dart:io';

import 'package:flutter/material.dart';
import 'package:identa/constants/colors.dart';
import 'package:identa/core/repositories/note_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class ProfileImageWidget extends StatelessWidget {
  final File? coverImage;
  final Function() onPickImage;
  
  const ProfileImageWidget({
    Key? key,
    this.coverImage,
    required this.onPickImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 142,
        height: 142,
        decoration: const BoxDecoration(
          color: MyColors.primaryColor,
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            coverImage != null
                ? GestureDetector(
                    onTap: () {
                      if (coverImage != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImageView(
                              imagePath: context
                                  .read<NoteProvider>()
                                  .coverImage!
                                  .path,
                            ),
                          ),
                        );
                      }
                    },
                    child: ClipOval(
                      child: Image.file(
                        coverImage!,
                        width: 142,
                        height: 142,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: onPickImage,
                    color: Colors.white,
                    iconSize: 30,
                  ),
            coverImage != null
                ? Positioned(
                    bottom: 2,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(100),
                        bottomRight: Radius.circular(100),
                        topLeft: Radius.zero,
                        topRight: Radius.zero,
                      ),
                      child: Opacity(
                        opacity: 0.4,
                        child: InkWell(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                            topLeft: Radius.zero,
                            topRight: Radius.zero,
                          ),
                          onTap: onPickImage,
                          child: Container(
                            width: 142,
                            height: 65,
                            decoration: const BoxDecoration(
                              color: Color(0xFF2993CF),
                              shape: BoxShape.rectangle,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: MyColors.primaryColor,
                                  radius: 16.0,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 33,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Text(""),
          ],
        ),
      ),
    );
  }
}

class FullScreenImageView extends StatelessWidget {
  final String imagePath;

  const FullScreenImageView({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider: FileImage(File(imagePath)),
      minScale: PhotoViewComputedScale.contained * 0.8,
      maxScale: PhotoViewComputedScale.covered * 2,
    );
  }
}

