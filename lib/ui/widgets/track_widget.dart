import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:quran/ui/widgets/shimmer/shimmer_loading.dart';

import '../../config/locale/app_localizations.dart';

/// Track Widget. Used for showing track thumbnail
class TrackWidget extends StatelessWidget {
  final String trackTitle;
  final String trackAuthorName;
  final String trackCoverUrl;
  final double height, width;
  final VoidCallback? onTap;
  const TrackWidget(
      {super.key,
      required this.trackCoverUrl,
      required this.trackTitle,
      required this.trackAuthorName,
      this.onTap,
      this.width = 100,
      this.height = 150});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSHpWMDBAp4yJ5Z4IFI7eO66-cYdNA39ZALR8r4wYIdbFcAyuLzNAtEqJ7U-EeeoFoHB3s&usqp=CAU', //trackCoverUrl,
      imageBuilder: (_, imageProvider) {
        return _builder(context: context, imageProvider: imageProvider);
      },
      errorWidget: (_, url, error) {
        var imageProvider = const AssetImage("assets/images/quran.png");
        return _builder(context: context, imageProvider: imageProvider);
      },
      placeholder: (_, url) {
        return loading(context: context, width: width, height: height);
      },
    );
  }

  static Widget loading({
    required BuildContext context,
    double width = 50,
    double height = 50,
  }) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ShimmerLoading(
              isLoading: true,
              child: Container(
                height: width,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 4),
                  child: ShimmerLoading(
                      isLoading: true,
                      child: Container(
                        height: 14,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 8.0),
                  child: ShimmerLoading(
                      isLoading: true,
                      child: Container(
                        height: 10,
                        width: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      )),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _builder({
    required BuildContext context,
    required ImageProvider imageProvider,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: const Border.fromBorderSide(BorderSide.none),
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 4),
                    child: Text(
                      trackTitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 0, bottom: 8.0),
                    child: Text(
                      AppLocalizations.of(context)!.translate('sheikh')!,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .labelSmall
                          ?.copyWith(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.outline),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
