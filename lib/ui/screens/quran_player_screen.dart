import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:quran/config/locale/app_localizations.dart';
import 'package:quran/features/quran/data/models/quran_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/ui/widgets/media_player_screen/navigation_button_widget.dart';
import 'package:quran/ui/widgets/media_player_screen/progress_widget.dart';
import 'package:quran/ui/widgets/top_likes.dart';
import 'package:quran/ui/widgets/track_list.dart';
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [tracks] are quran list
/// [initialIndex] is index of song list that will be played
class QuranPlayerScreen extends StatefulWidget {
  final int initialIndex;
  List<QuranModel> tracks;
  final List<String> sura;
  var savedQuranList;
  List<QuranModel> savedQuranList2 = [];

  QuranPlayerScreen(
      {super.key,
      required this.tracks,
      required this.sura,
      this.initialIndex = 0});

  @override
  State<QuranPlayerScreen> createState() => _QuranPlayerScreenState();
}

class _QuranPlayerScreenState extends State<QuranPlayerScreen>
    with TickerProviderStateMixin {
  late final ValueNotifier<int> _currentMusicIndex;
  final ValueNotifier<bool> _isShuffleActive = ValueNotifier(false);
  late final StreamSubscription<int?> _currentMusicIndexSubscription;
  late final StreamSubscription<bool?> _shuffleModeSubscription;
  final player = AudioPlayer();

  final cacheManager = DefaultCacheManager();

  List<AudioSource> audioSources = [];

  Future<void> _initPlayer() async {
    await checkList();
    final cacheManager = DefaultCacheManager();
    var cacheDir = await getTemporaryDirectory();
    for (var track in widget.tracks) {
      // Check if the requested URL is already in cache
      final file = await cacheManager.getFileFromCache(track.audioUrl);
      var localPath = '${cacheDir.path}/${track.audioUrl}';

      if ((file != null && await file.file.exists()) ||
          await File(localPath).exists()) {
        // Already cached
        audioSources.add(AudioSource.uri(
            Uri.parse(file != null ? file.file.path : localPath)));
      } else {
        // Not cached, load and cache
        final source = LockCachingAudioSource(Uri.parse(track.audioUrl));
        audioSources.add(source);
      }
    }
    player.setAudioSource(ConcatenatingAudioSource(children: audioSources));
  }

  Future<bool> isAudioCashed(int trackIndex) async {
    // Get cache directory path
    final cacheManager = DefaultCacheManager();
    var cacheDir = await getTemporaryDirectory();
    // Get file path
    final path = '${cacheDir.path}/${widget.tracks[trackIndex].audioUrl}';

    // Check file exists
    final fileExists = await File(path).exists();
    // Check if the requested URL is already in cache
    final file =
        await cacheManager.getFileFromCache(widget.tracks[trackIndex].audioUrl);

    if ((file != null && await file.file.exists()) || fileExists) {
      // Already cached
      return true;
    } else {
      return false;
    }
  }

  checkList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? savedQuranList = pref.getString("savedQuranList");
    if (savedQuranList != null) {
      widget.savedQuranList = await jsonDecode(savedQuranList);
      debugPrint(widget.savedQuranList.toString());
      for (var item in widget.savedQuranList) {
        widget.savedQuranList2.add(QuranModel(
          id: item['id'],
          audioUrl: item['audio_url'],
        ));
      }
      if (widget.tracks.isEmpty) {
        widget.tracks.addAll(widget.savedQuranList2);
      }
    }
  }

  @override
  void initState() {
    _currentMusicIndex = ValueNotifier(widget.initialIndex);
    _initPlayer();
    player.setShuffleModeEnabled(false);
    player.playerStateStream.listen(listenStateStream);
    _currentMusicIndexSubscription =
        player.currentIndexStream.listen(listenCurrentIndex);
    _shuffleModeSubscription =
        player.shuffleModeEnabledStream.listen(listenShuffleMode);

    super.initState();
  }

  chekIntenetConnextion() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      await player.stop();
    }
  }

  @override
  void dispose() {
    _shuffleModeSubscription.cancel();
    _currentMusicIndexSubscription.cancel();
    _currentMusicIndex.dispose();
    player.stop();
    player.dispose();
    super.dispose();
  }

  void listenShuffleMode(bool? isEnabled) {
    try {
      if (isEnabled == null || !mounted) {
        return;
      }
      setState(() {
        _isShuffleActive.value = isEnabled;
      });
      return;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No internet connection!'),
      ));
    }
  }

  void listenCurrentIndex(int? index) async {
    if (index == null || !mounted) {
      return;
    }
    setState(() {
      _currentMusicIndex.value = index;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: _isShuffleActive,
        builder: (context, isShuffleModeActive, _) {
          return ValueListenableBuilder<int>(
              valueListenable: _currentMusicIndex,
              builder: (context, currentMusicIndex, _) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * .9,
                  child: Scaffold(
                    body:
                        SafeArea(
                      child: LayoutBuilder(builder: (context, constraints) {
                        return Container(
                          constraints: constraints,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Text(
                                    AppLocalizations.of(context)
                                            ?.translate('top_likes') ??
                                        "Top likes",
                                    key: const Key("top_likes"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              TopLikes(
                                sura: widget.sura,
                                tracks: widget.tracks,
                                currentIndex: currentMusicIndex,
                                onClickTrack: (index) {
                                  playWithSelectedIndex(index);
                                },
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 2, left: 16),
                                  child: Text(
                                    AppLocalizations.of(context)
                                            ?.translate('listen_Quran') ??
                                        "listen Quran",
                                    key: Key("listen_Quran"),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              TrackList(
                                sura: widget.sura,
                                tracks: widget.tracks,
                                currentIndex: currentMusicIndex,
                                onClickTrack: (index) {
                                  playWithSelectedIndex(index);
                                },
                              ),
                              SizedBox(
                                height: 180,
                                child: Column(
                                  children: [
                                    _mainBody(
                                        currentMusic:
                                            widget.tracks[currentMusicIndex],
                                        index: currentMusicIndex),
                                    MediaPlayerProgressWidget(
                                      audioPlayer: player,
                                    ),
                                    MediaPlayerNavigationButtonWidget(
                                      audioPlayer: player,
                                      onPlay: onPlay,
                                      onPrev: !player.hasPrevious
                                          ? null
                                          : player.seekToPrevious,
                                      onNext: !player.hasNext
                                          ? null
                                          : player.seekToNext,
                                      onClickPlaylist: () {},
                                      isShuffleActive: isShuffleModeActive,
                                      onClickShuffle: () {
                                        player.setShuffleModeEnabled(
                                            !isShuffleModeActive);
                                        if (!isShuffleModeActive) {
                                          player.shuffle();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                );
              });
        });
  }

  Widget _mainBody({required QuranModel currentMusic, required index}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.sura[index],
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.purple, fontSize: 16),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context)?.translate('sheikh') ??
                      "Abdul Basit Abdul Samad",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.purple, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> onPlay() async {
    if (player.playerState.playing) {
      if (player.playerState.processingState == ProcessingState.completed) {
        final connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          await player.stop();
          return;
        } else {
          await player.seek(Duration.zero);
          return;
        }
      } else {
        await player.pause();
        return;
      }
    }
    if (!player.playerState.playing) {
      await player.play();
      return;
    }
    return;
  }

  void playWithSelectedIndex(int index) async {
    await player.seek(Duration.zero, index: index);
    return;
  }

  void listenStateStream(PlayerState playerState) async {
    debugPrint("state is ${playerState.processingState}");
    if (playerState.processingState == ProcessingState.completed) {
      // Check for internet connection before playing next audio
      await chekIntenetConnextion();
    }
  }
}
