import 'package:quran/features/quran/states/quran_by_reciter/quran_by_reciter_bloc.dart';
import 'package:quran/features/quran/states/reciter_bloc/reciter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:quran/config/locale/app_localizations.dart';
import 'package:quran/features/quran/data/models/quran_model.dart';
import 'package:quran/features/quran/states/search_bloc/search_bloc.dart';
import 'package:quran/ui/screens/quran_player_screen.dart';
import 'package:quran/ui/widgets/quran_reciter_list.dart';

class HomeScreen extends StatefulWidget {
  final GetIt instance;
  const HomeScreen({super.key, required this.instance});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ReciterBloc reciterBloc;
  late QuranByReciterBloc quranByReciterBloc;
  late SearchBloc searchBloc;
  final TextEditingController _searchFieldController = TextEditingController();

  bool showSearchResults = false;
  @override
  void initState() {
    super.initState();
    reciterBloc = widget.instance.get<ReciterBloc>();
    quranByReciterBloc = widget.instance.get<QuranByReciterBloc>();
    searchBloc = widget.instance.get<SearchBloc>();
  }

  void searchFieldListener() {
    if (_searchFieldController.text.isEmpty) {
      return;
    }
    searchEvent(_searchFieldController.text);
    return;
  }

  void searchEvent(String keyword) {
    searchBloc.add(SearchEvent.search(keyword));
    return;
  }

  @override
  void dispose() {
    _searchFieldController.clear();
    _searchFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Container(
              constraints: constraints,
              child: Column(
                children: [
                  _bodyBuilder(constraints),
                ],
              )),
        );
      },
    );
  }

  Widget _bodyBuilder(BoxConstraints constraints) {
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: searchBloc,
      builder: (context, state) {
        return state.maybeMap(
          cleared: (value) {
            return _listsArtistSongs(parentConstraints: constraints);
          },
          orElse: () {
            return _listsArtistSongs(parentConstraints: constraints);
          },
        );
      },
    );
  }

  Widget _listsArtistSongs({required BoxConstraints parentConstraints}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 100,
      child: QuranByReciterListWidget(
          quranByReciterBloc: quranByReciterBloc,
          reciterBloc: reciterBloc,
          onTapTrack: onTapTrack),
    );
  }

  onTapTrack({required List<QuranModel> tracks, int initialIndex = 0}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => QuranPlayerScreen(
                  sura: (AppLocalizations.of(context)!.isEnLocale)
                      ? reciterBloc.suarsEnglishName
                      : reciterBloc.suarsArabicName,
                  tracks: tracks,
                  initialIndex: initialIndex,
                )));
    return;
  }

  onReload() {
    searchFieldListener();
    return;
  }
}
