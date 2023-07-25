import 'dart:convert';

import 'package:quran/features/quran/data/models/quran_model.dart';
import 'package:quran/features/quran/states/quran_by_reciter/quran_by_reciter_bloc.dart';
import 'package:quran/features/quran/states/reciter_bloc/reciter_bloc.dart';
import 'package:quran/ui/screens/quran_player_screen.dart';
import 'package:quran/ui/widgets/error_widget.dart';
import 'package:quran/ui/widgets/shimmer/shimmer_loading.dart';
import 'package:quran/ui/widgets/shimmer/shimmer_widget.dart';
import 'package:quran/ui/widgets/track_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/cores/theme.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../config/locale/app_localizations.dart';

/// Widget that show list of artists and theirs songs
///
/// [reciterBloc], [quranByReciterBloc] and [onTapTrack] are required
class QuranByReciterListWidget extends StatefulWidget {
  final ReciterBloc reciterBloc;
  final QuranByReciterBloc quranByReciterBloc;
  final void Function(
      {required List<QuranModel> tracks, required int initialIndex}) onTapTrack;

  var savedQuranList;
  List<QuranModel> savedQuranList2 = [];
  QuranByReciterListWidget(
      {super.key,
      required this.quranByReciterBloc,
      required this.reciterBloc,
      required this.onTapTrack});

  @override
  State<QuranByReciterListWidget> createState() =>
      _QuranByReciterListWidgetState();
}

class _QuranByReciterListWidgetState extends State<QuranByReciterListWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      widget.reciterBloc.add(const ReciterEvent.loadReciter());
      await checkList();
      return;
    });
    super.initState();
  }

  Future<void> checkList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? savedQuranList = pref.getString("savedQuranList");
    if (savedQuranList != null) {
      widget.savedQuranList2.clear();
      widget.savedQuranList = await jsonDecode(savedQuranList);
      debugPrint(widget.savedQuranList.toString());
      for (var item in widget.savedQuranList) {
        widget.savedQuranList2.add(QuranModel(
          id: item['id'],
          audioUrl: item['audio_url'],
        ));
      }
      debugPrint(
          "savedQuranList length is list player ${widget.savedQuranList2.length}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (p0, constraints) {
        return Container(
          constraints: constraints,
          child: BlocBuilder<ReciterBloc, ReciterState>(
            bloc: widget.reciterBloc,
            builder: (context, state) {
              return state.maybeMap(
                loading: (value) {
                  return _listArtists(artists: [], isLoading: false);
                },
                loaded: (value) {
                  return _listArtists(
                      artists: value.artists,
                      isLoading: false,
                      sura: (AppLocalizations.of(context)!.isEnLocale)
                          ? widget.reciterBloc.suarsEnglishName
                          : widget.reciterBloc.suarsArabicName);
                },
                error: (value) {
                  return ErrorWithReloadWidget(
                    errorMessage: value.error,
                    onReload: () {
                      widget.reciterBloc.add(const ReciterEvent.loadReciter());
                      return;
                    },
                  );
                },
                orElse: () {
                  return const Text('nothing here');
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _listArtists({
    required List<String> artists,
    bool isLoading = false,
    List<String> sura = const [],
  }) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: artists.map((e) {
          return _artistSongList(
              isLoading: isLoading, artistName: e, sura: sura);
        }).toList(),
      ),
    );
  }

  Widget _artistSongList({
    String artistName = "",
    bool isLoading = false,
    List<String> sura = const [],
  }) {
    return BlocBuilder<QuranByReciterBloc, Map<String, QuranByReciterState>>(
      bloc: widget.quranByReciterBloc,
      builder: (context, songArtistsState) {
        var songArtistState = songArtistsState[artistName.toLowerCase()] ??
            const QuranByReciterState.loading([]);
        debugPrint(songArtistState.songs.toString());

        return ShimmerWidget(
          linearGradient: AppTheme().shimmerGradient,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ShimmerLoading(
                          isLoading: false,
                          child: isLoading
                              ? Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                )
                              : Container())),
                  songArtistState.maybeMap(loaded: (value) {
                    return QuranPlayerScreen(
                      sura: (AppLocalizations.of(context)!.isEnLocale)
                          ? widget.reciterBloc.suarsEnglishName
                          : widget.reciterBloc.suarsArabicName,
                      tracks: songArtistState.songs.isNotEmpty
                          ? songArtistState.songs
                          : widget.savedQuranList2,
                      initialIndex: 0,
                    );
                  }, loading: (value) {
                    return QuranListWidget(
                      isLoading: true,
                    );
                  }, orElse: () {
                    return QuranPlayerScreen(
                      sura: (AppLocalizations.of(context)!.isEnLocale)
                          ? widget.reciterBloc.suarsEnglishName
                          : widget.reciterBloc.suarsArabicName,
                      tracks: widget.savedQuranList2, //songArtistState.songs,
                      initialIndex: 0,
                    );
                  })
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget QuranListWidget({
    bool isLoading = false,
    List<QuranModel> quran = const [],
    List<String> sura = const [],
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(isLoading ? 10 : quran.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: isLoading
                ? TrackWidget.loading(
                    context: context,
                    width: 50,
                    height: 50,
                  )
                : TrackWidget(
                    width: 50,
                    height: 50,
                    onTap: () {
                      widget.onTapTrack(tracks: quran, initialIndex: index);
                      return;
                    },
                    trackCoverUrl:
                        'https://www.google.com/imgres?imgurl=https%3A%2F%2Fimg.freepik.com%2Fpremium-photo%2FQuran-is-holy-book-islam-open-reading-mosque_488220-33735.jpg%3Fw%3D2000&tbnid=FsqraUoRjQ97vM&vet=12ahUKEwixy7PB2ZqAAxW5pycCHY-UBY8QMygoegUIARDGAg..i&imgrefurl=https%3A%2F%2Fwww.freepik.com%2Ffree-photos-vectors%2FQuran&docid=uAuLEsI2TfK93M&w=2000&h=1332&q=Quran&client=safari&ved=2ahUKEwixy7PB2ZqAAxW5pycCHY-UBY8QMygoegUIARDGAg', //songs[index].artworkUrl100,
                    trackTitle: sura[index],
                    trackAuthorName: ''),
          );
        }),
      ),
    );
  }
}
