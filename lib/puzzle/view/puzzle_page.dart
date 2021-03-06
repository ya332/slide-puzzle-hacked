import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/timer/timer.dart';

/// {@template puzzle_page}
/// The root page of the puzzle UI.
///
/// Builds the puzzle based on the current [PuzzleTheme]
/// from [ThemeBloc].
/// {@endtemplate}
class PuzzlePage extends StatelessWidget {
  /// {@macro puzzle_page}
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(
        themes: const [
          SimpleTheme(),
        ],
      ),
      child: const PuzzleView(),
    );
  }
}

/// {@template puzzle_view}
/// Displays the content for the [PuzzlePage].
/// {@endtemplate}
class PuzzleView extends StatelessWidget {
  /// {@macro puzzle_view}
  const PuzzleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    /// Shuffle only if the current theme is Simple.
    final shufflePuzzle = theme is SimpleTheme;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: BlocProvider(
        create: (context) => TimerBloc(
          ticker: const Ticker(),
        ),
        child: BlocProvider(
          create: (context) => PuzzleBloc(4)
            ..add(
              PuzzleInitialized(
                shufflePuzzle: shufflePuzzle,
              ),
            ),
          child: const _Puzzle(
            key: Key('puzzle_view_puzzle'),
          ),
        ),
      ),
    );
  }
}

class _Puzzle extends StatelessWidget {
  const _Puzzle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            theme.layoutDelegate.backgroundBuilder(state),
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  children: const [
                    _PuzzleHeader(
                      key: Key('puzzle_header'),
                    ),
                    _PuzzleSections(
                      key: Key('puzzle_sections'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PuzzleHeader extends StatelessWidget {
  const _PuzzleHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ResponsiveLayoutBuilder(
        small: (context, child) => Padding(
          padding: const EdgeInsets.only(
            bottom: 50,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _PuzzleLogo(),
            ],
          ),
        ),
        medium: (context, child) => Padding(
          padding: const EdgeInsets.only(
            bottom: 50,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _PuzzleLogo(),
            ],
          ),
        ),
        large: (context, child) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
          ),
          child: Row(
            children: const [
              _PuzzleLogo(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PuzzleLogo extends StatelessWidget {
  const _PuzzleLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (context, child) => const SizedBox(
        height: 24,
        child: Icon(Icons.favorite, color: Colors.amber, size: 104),
      ),
      medium: (context, child) => const SizedBox(
        height: 29,
        child: Icon(Icons.favorite, color: Colors.amber, size: 104),
      ),
      large: (context, child) => const SizedBox(
        height: 32,
        child: Icon(Icons.favorite, color: Colors.amber, size: 104),
      ),
    );
  }
}

class _PuzzleSections extends StatefulWidget {
  const _PuzzleSections({Key? key}) : super(key: key);

  @override
  State<_PuzzleSections> createState() => _PuzzleSectionsState();
}

class _PuzzleSectionsState extends State<_PuzzleSections>
    with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    duration: const Duration(seconds: 10),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _animationController.value = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final stateWithNoAnimationController =
        context.select((PuzzleBloc bloc) => bloc.state);
    final state = stateWithNoAnimationController
        .setAnimationController(_animationController);

    return ResponsiveLayoutBuilder(
      small: (context, child) => Column(
        children: [
          theme.layoutDelegate.startSectionBuilder(state),
          AnimatedBuilder(
            animation: _animationController,
            child: const PuzzleBoard(),
            builder: (BuildContext context, Widget? child) {
              return Transform.rotate(
                angle: _animationController.value * 2.0 * math.pi,
                child: child,
              );
            },
          ),
          theme.layoutDelegate.endSectionBuilder(state),
        ],
      ),
      medium: (context, child) => Column(
        children: [
          theme.layoutDelegate.startSectionBuilder(state),
          AnimatedBuilder(
            animation: _animationController,
            child: const PuzzleBoard(),
            builder: (BuildContext context, Widget? child) {
              return Transform.rotate(
                angle: _animationController.value * 2.0 * math.pi,
                child: child,
              );
            },
          ),
          theme.layoutDelegate.endSectionBuilder(state),
        ],
      ),
      large: (context, child) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: theme.layoutDelegate.startSectionBuilder(state),
          ),
          AnimatedBuilder(
            animation: _animationController,
            child: const PuzzleBoard(),
            builder: (BuildContext context, Widget? child) {
              return Transform.rotate(
                angle: _animationController.value * 2.0 * math.pi,
                child: child,
              );
            },
          ),
          Expanded(
            child: theme.layoutDelegate.endSectionBuilder(state),
          ),
        ],
      ),
    );
  }
}

/// {@template puzzle_board}
/// Displays the board of the puzzle.
/// {@endtemplate}
class PuzzleBoard extends StatelessWidget {
  /// {@macro puzzle_board}
  const PuzzleBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);
    final puzzle = context.select((PuzzleBloc bloc) => bloc.state.puzzle);
    final size = puzzle.getDimension();
    if (size == 0) return const CircularProgressIndicator();

    return BlocListener<PuzzleBloc, PuzzleState>(
      listener: (context, state) {
        if (theme.hasTimer && state.puzzleStatus == PuzzleStatus.complete) {
          context.read<TimerBloc>().add(const TimerStopped());
        }
      },
      child: state.mode == Mode.hack
          ? theme.layoutDelegate.boardBuilder(
              size,
              handleDisplays(puzzle.tiles, state.tileDisplays),
            )
          : theme.layoutDelegate.boardBuilder(
              size,
              puzzle.tiles
                  .map(
                    (tile) => _PuzzleTile(
                      key: Key('puzzle_tile_${tile.value.toString()}'),
                      tile: tile,
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

// ignore: public_member_api_docs
List<Widget> handleDisplays(List<Tile> tiles, List<bool> displays) {
  final processedTiles = <Widget>[];
  tiles.forEach((tile) {
    if (tile.isDragged == false) {
      processedTiles.add(
        _PuzzleTile(
          key: Key('puzzle_tile_${tile.value.toString()}'),
          tile: tile,
        ),
      );
    } else {
      processedTiles.add(const SizedBox());
    }
  });
  return processedTiles;
}

class _PuzzleTile extends StatelessWidget {
  const _PuzzleTile({
    Key? key,
    required this.tile,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    return tile.isWhitespace
        ? theme.layoutDelegate.whitespaceTileBuilder(context)
        : theme.layoutDelegate.tileBuilder(tile, state);
  }
}
