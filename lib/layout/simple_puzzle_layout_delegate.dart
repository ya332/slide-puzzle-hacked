// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/bloc/puzzle_bloc.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/typography/typography.dart';

/// {@template simple_puzzle_layout_delegate}
/// A delegate for computing the layout of the puzzle UI
/// that uses a [SimpleTheme].
/// {@endtemplate}
class SimplePuzzleLayoutDelegate extends PuzzleLayoutDelegate {
  /// {@macro simple_puzzle_layout_delegate}
  SimplePuzzleLayoutDelegate();

  int totalScore = 0;

  @override
  Widget startSectionBuilder(PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => Padding(
        padding: const EdgeInsets.only(left: 50, right: 32),
        child: child,
      ),
      child: (_) => SimpleStartSection(state: state),
    );
  }

  @override
  Widget endSectionBuilder(PuzzleState state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ResponsiveGap(
              small: 64,
              medium: 96,
            ),
            ResponsiveLayoutBuilder(
              small: (_, child) => const SimplePuzzleShuffleButton(),
              medium: (_, child) => const SimplePuzzleShuffleButton(),
              large: (_, __) => const SizedBox(),
            ),
            const ResponsiveGap(
              small: 64,
              medium: 96,
            ),
            ResponsiveLayoutBuilder(
              small: (_, child) => SimplePuzzleHackButton(),
              medium: (_, child) => SimplePuzzleHackButton(),
              large: (_, __) => const SizedBox(),
            ),
            const ResponsiveGap(
              small: 64,
              medium: 96,
            ),
            ResponsiveLayoutBuilder(
              small: (_, child) => const SimplePuzzleCrazyButton(),
              medium: (_, child) => const SimplePuzzleCrazyButton(),
              large: (_, __) => const SizedBox(),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ResponsiveGap(
              small: 64,
              medium: 96,
            ),
            ResponsiveLayoutBuilder(
              small: (_, child) => const SimplePuzzleResetButton(),
              medium: (_, child) => const SimplePuzzleResetButton(),
              large: (_, __) => const SizedBox(),
            ),
            const ResponsiveGap(
              small: 64,
              medium: 96,
            ),
            ResponsiveLayoutBuilder(
              small: (_, child) => const SimplePuzzleNormalButton(),
              medium: (_, child) => const SimplePuzzleNormalButton(),
              large: (_, __) => const SizedBox(),
            ),
            const ResponsiveGap(
              small: 64,
              medium: 96,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget backgroundBuilder(PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => const SizedBox(
        key: Key('simple_puzzle_dash_small'),
        child: Image(
          image: AssetImage('assets/images/wave.jpg'),
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
      ),
      medium: (_, __) => const SizedBox(
        key: Key('simple_puzzle_dash_medium'),
        child: Image(
          image: AssetImage('assets/images/space.jpg'),
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
      ),
      large: (_, __) => const Padding(
        padding: EdgeInsets.only(bottom: 53),
        child: SizedBox(
          key: Key('simple_puzzle_dash_large'),
          child: Image(
            image: AssetImage('assets/images/earth.jpg'),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
        ),
      ),
    );
  }

  @override
  Widget boardBuilder(int size, List<Widget> tiles) {
    return Column(
      children: [
        const ResponsiveGap(
          small: 32,
          medium: 48,
          large: 96,
        ),
        ResponsiveLayoutBuilder(
          small: (_, __) => SizedBox.square(
            dimension: _BoardSize.small,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_small'),
              size: size,
              tiles: tiles,
              spacing: 5,
            ),
          ),
          medium: (_, __) => SizedBox.square(
            dimension: _BoardSize.medium,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_medium'),
              size: size,
              tiles: tiles,
            ),
          ),
          large: (_, __) => SizedBox.square(
            dimension: _BoardSize.large,
            child: SimplePuzzleBoard(
              key: const Key('simple_puzzle_board_large'),
              size: size,
              tiles: tiles,
            ),
          ),
        ),
        const ResponsiveGap(
          large: 96,
        ),
      ],
    );
  }

  @override
  Widget tileBuilder(Tile tile, PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_small'),
        tile: tile,
        tileFontSize: _TileFontSize.small,
        state: state,
      ),
      medium: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_medium'),
        tile: tile,
        tileFontSize: _TileFontSize.medium,
        state: state,
      ),
      large: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_large'),
        tile: tile,
        tileFontSize: _TileFontSize.large,
        state: state,
      ),
    );
  }

  @override
  Widget whitespaceTileBuilder(BuildContext context) {
    final state = context.select((PuzzleBloc bloc) => bloc.state);
    if (state.mode != Mode.hack) {
      return const SizedBox();
    } else {
      return DragTarget<int>(
        builder: (
          BuildContext context,
          List<dynamic> accepted,
          List<dynamic> rejected,
        ) {
          return Container(
            height: 100.0,
            width: 100.0,
            color: Colors.white,
            child: Stack(
              children: <Widget>[
                Image.asset('assets/images/joker.jpg'),
                const Center(child: Text('Drop Target')),
              ],
            ),
          );
        },
        onAccept: (int data) {
          context.read<PuzzleBloc>().add(PuzzleScoreAdded(data));
        },
      );
    }
  }

  @override
  List<Object?> get props => [];
}

/// {@template simple_start_section}
/// Displays the start section of the puzzle based on [state].
/// {@endtemplate}
@visibleForTesting
class SimpleStartSection extends StatelessWidget {
  /// {@macro simple_start_section}
  const SimpleStartSection({
    Key? key,
    required this.state,
  }) : super(key: key);

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    final state = context.select((PuzzleBloc bloc) => bloc.state);
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveGap(
          small: 20,
          medium: 83,
          large: 151,
        ),
        const PuzzleName(),
        const ResponsiveGap(large: 16),
        SimplePuzzleTitle(
          status: state.puzzleStatus,
        ),
        const ResponsiveGap(
          small: 12,
          medium: 16,
          large: 32,
        ),
        NumberOfMovesAndTilesLeft(
          numberOfMoves: state.numberOfMoves,
          numberOfTilesLeft: state.numberOfTilesLeft,
        ),
        const ResponsiveGap(large: 32),
        ResponsiveLayoutBuilder(
          small: (_, child) => Padding(
            padding: const EdgeInsets.only(top: 25, left: 50, right: 32),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: state.instruction,
                style: PuzzleTextStyle.bodySmall.copyWith(
                  color: PuzzleColors.primary5,
                  backgroundColor: PuzzleColors.primary2,
                ),
              ),
            ),
          ),
          medium: (_, child) => Padding(
            padding: const EdgeInsets.only(top: 25, left: 50, right: 32),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: state.instruction,
                style: PuzzleTextStyle.bodySmall.copyWith(
                  color: PuzzleColors.primary5,
                  backgroundColor: PuzzleColors.primary2,
                ),
              ),
            ),
          ),
          large: (_, __) => const SizedBox(),
        ),
        const ResponsiveGap(large: 32),
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(),
          medium: (_, __) => const SizedBox(),
          large: (_, __) => const SimplePuzzleShuffleButton(),
        ),
        const ResponsiveGap(large: 32),
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(),
          medium: (_, __) => const SizedBox(),
          large: (_, __) => SimplePuzzleHackButton(),
        ),
        const ResponsiveGap(large: 32),
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(),
          medium: (_, __) => const SizedBox(),
          large: (_, __) => const SimplePuzzleCrazyButton(),
        ),
        const ResponsiveGap(large: 32),
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(),
          medium: (_, __) => const SizedBox(),
          large: (_, __) => const SimplePuzzleResetButton(),
        ),
        const ResponsiveGap(large: 32),
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(),
          medium: (_, __) => const SizedBox(),
          large: (_, __) => const SimplePuzzleNormalButton(),
        ),
        const ResponsiveGap(large: 32),
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(),
          medium: (_, __) => const SizedBox(),
          large: (_, __) => RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              text: state.instruction,
              style: PuzzleTextStyle.bodySmall.copyWith(
                color: PuzzleColors.primary5,
                backgroundColor: PuzzleColors.primary2,
              ),
            ),
          ),
        ),
        const ResponsiveGap(large: 32),
      ],
    );
  }
}

/// {@template simple_puzzle_title}
/// Displays the title of the puzzle based on [status].
///
/// Shows the success state when the puzzle is completed,
/// otherwise defaults to the Puzzle Challenge title.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleTitle extends StatelessWidget {
  /// {@macro simple_puzzle_title}
  const SimplePuzzleTitle({
    Key? key,
    required this.status,
  }) : super(key: key);

  /// The state of the puzzle.
  final PuzzleStatus status;

  @override
  Widget build(BuildContext context) {
    return PuzzleTitle(
      title: status == PuzzleStatus.complete
          ? context.l10n.puzzleCompleted
          : context.l10n.puzzleChallengeTitle,
    );
  }
}

abstract class _BoardSize {
  static double small = 312;
  static double medium = 424;
  static double large = 472;
}

/// {@template simple_puzzle_board}
/// Display the board of the puzzle in a [size]x[size] layout
/// filled with [tiles]. Each tile is spaced with [spacing].
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleBoard extends StatelessWidget {
  /// {@macro simple_puzzle_board}
  const SimplePuzzleBoard({
    Key? key,
    required this.size,
    required this.tiles,
    this.spacing = 8,
  }) : super(key: key);

  /// The size of the board.
  final int size;

  /// The tiles to be displayed on the board.
  final List<Widget> tiles;

  /// The spacing between each tile from [tiles].
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: size,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      children: tiles,
    );
  }
}

abstract class _TileFontSize {
  static double small = 36;
  static double medium = 50;
  static double large = 54;
}

/// {@template simple_puzzle_tile}
/// Displays the puzzle tile associated with [tile] and
/// the font size of [tileFontSize] based on the puzzle [state].
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleTile extends StatelessWidget {
  /// {@macro simple_puzzle_tile}
  const SimplePuzzleTile({
    Key? key,
    required this.tile,
    required this.tileFontSize,
    required this.state,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  /// The font size of the tile to be displayed.
  final double tileFontSize;

  /// The state of the puzzle.
  final PuzzleState state;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    if (state.mode == Mode.hack) {
      return Draggable(
        data: tile.value,
        feedback: TextButton(
          style: TextButton.styleFrom(
            primary: PuzzleColors.primary7,
            textStyle: PuzzleTextStyle.headline2.copyWith(
              fontSize: tileFontSize,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
          ).copyWith(
            foregroundColor: MaterialStateProperty.all(PuzzleColors.white),
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (states) {
                if (tile.value == state.lastTappedTile?.value) {
                  return theme.pressedColor;
                } else if (states.contains(MaterialState.hovered)) {
                  return theme.hoverColor;
                } else {
                  return theme.defaultColor;
                }
              },
            ),
          ),
          onPressed: state.puzzleStatus == PuzzleStatus.incomplete
              ? () => context.read<PuzzleBloc>().add(TileTapped(tile))
              : null,
          child: Text(tile.value.toString()),
        ),
        childWhenDragging: const SizedBox(),
        child: TextButton(
          style: TextButton.styleFrom(
            primary: PuzzleColors.primary7,
            textStyle: PuzzleTextStyle.headline2.copyWith(
              fontSize: tileFontSize,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
          ).copyWith(
            foregroundColor: MaterialStateProperty.all(PuzzleColors.white),
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (states) {
                if (tile.value == state.lastTappedTile?.value) {
                  return theme.pressedColor;
                } else if (states.contains(MaterialState.hovered)) {
                  return theme.hoverColor;
                } else {
                  return theme.defaultColor;
                }
              },
            ),
          ),
          onPressed: state.puzzleStatus == PuzzleStatus.incomplete
              ? () => context.read<PuzzleBloc>().add(TileTapped(tile))
              : null,
          child: Text(tile.value.toString()),
        ),
      );
    }
    return TextButton(
      style: TextButton.styleFrom(
        primary: PuzzleColors.primary7,
        textStyle: PuzzleTextStyle.headline2.copyWith(
          fontSize: tileFontSize,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ).copyWith(
        foregroundColor: MaterialStateProperty.all(PuzzleColors.white),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (states) {
            if (tile.value == state.lastTappedTile?.value) {
              return theme.pressedColor;
            } else if (states.contains(MaterialState.hovered)) {
              return theme.hoverColor;
            } else {
              return theme.defaultColor;
            }
          },
        ),
      ),
      onPressed: state.puzzleStatus == PuzzleStatus.incomplete
          ? () => context.read<PuzzleBloc>().add(TileTapped(tile))
          : null,
      child: Text(tile.value.toString()),
    );
  }
}

class SimpleDragTarget extends StatelessWidget {
  /// {@macro puzzle_shuffle_button}
  const SimpleDragTarget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PuzzleButton(
      textColor: PuzzleColors.primary0,
      backgroundColor: PuzzleColors.primary6,
      onPressed: () => context.read<PuzzleBloc>().add(const PuzzleReset()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/shuffle_icon.png',
            width: 17,
            height: 17,
          ),
          const Gap(10),
          Text(context.l10n.puzzleShuffle),
        ],
      ),
    );
  }
}

/// {@template puzzle_shuffle_button}
/// Displays the button to shuffle the puzzle.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleShuffleButton extends StatelessWidget {
  /// {@macro puzzle_shuffle_button}
  const SimplePuzzleShuffleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PuzzleButton(
      textColor: PuzzleColors.primary0,
      backgroundColor: PuzzleColors.primary7,
      onPressed: () => context.read<PuzzleBloc>().add(const PuzzleShuffle()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/shuffle_icon.png',
            width: 17,
            height: 17,
          ),
          const Gap(10),
          Text(context.l10n.puzzleShuffle),
        ],
      ),
    );
  }
}

/// {@template puzzle_hack_button}
/// Displays the button to shuffle the puzzle.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleHackButton extends StatefulWidget {
  /// {@macro puzzle_shuffle_button}
  SimplePuzzleHackButton({Key? key}) : super(key: key);

  // ignore: public_member_api_docs
  @override
  // ignore: library_private_types_in_public_api
  _SimplePuzzleHackButtonState createState() => _SimplePuzzleHackButtonState();
}

class _SimplePuzzleHackButtonState extends State<SimplePuzzleHackButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currentBackgroundColor = PuzzleColors.primary7;
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    if (state.mode == Mode.hack) {
      currentBackgroundColor = PuzzleColors.primary10;
    }

    return PuzzleButton(
      textColor: PuzzleColors.primary0,
      backgroundColor: currentBackgroundColor,
      onPressed: () {
        context.read<PuzzleBloc>().add(const PuzzleHack());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.asset(
          //   'assets/images/shuffle_icon.png',
          //   width: 17,
          //   height: 17,
          // ),
          // const Gap(10),
          Text(context.l10n.puzzleHack),
        ],
      ),
    );
  }
}

/// {@template puzzle_hack_button}
/// Displays the button to shuffle the puzzle.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleCrazyButton extends StatefulWidget {
  /// {@macro puzzle_shuffle_button}
  const SimplePuzzleCrazyButton({Key? key}) : super(key: key);
  // ignore: public_member_api_docs

  @override
  // ignore: library_private_types_in_public_api
  _SimplePuzzleCrazyButtonState createState() =>
      _SimplePuzzleCrazyButtonState();
}

class _SimplePuzzleCrazyButtonState extends State<SimplePuzzleCrazyButton> {
  @override
  Widget build(BuildContext context) {
    var currentBackgroundColor = PuzzleColors.primary7;
    final state = context.select((PuzzleBloc bloc) => bloc.state);
    if (state.mode == Mode.crazy) {
      currentBackgroundColor = PuzzleColors.primary10;
    }
    return PuzzleButton(
      textColor: PuzzleColors.primary0,
      backgroundColor: currentBackgroundColor,
      onPressed: () {
        context.read<PuzzleBloc>().add(const PuzzleCrazy());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.asset(
          //   'assets/images/shuffle_icon.png',
          //   width: 17,
          //   height: 17,
          // ),
          // const Gap(10),
          Text(context.l10n.puzzleCrazy),
        ],
      ),
    );
  }
}

/// {@template puzzle_reset_button}
/// Displays the button to shuffle the puzzle.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleResetButton extends StatefulWidget {
  /// {@macro puzzle_shuffle_button}
  const SimplePuzzleResetButton({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _SimplePuzzleResetButtonState createState() =>
      _SimplePuzzleResetButtonState();
}

class _SimplePuzzleResetButtonState extends State<SimplePuzzleResetButton> {
  @override
  Widget build(BuildContext context) {
    return PuzzleButton(
      textColor: PuzzleColors.primary0,
      backgroundColor: PuzzleColors.primary7,
      onPressed: () {
        context.read<PuzzleBloc>().add(const PuzzleReset());
        // setState(() {});
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(context.l10n.puzzleReset),
        ],
      ),
    );
  }
}

/// {@template puzzle_reset_button}
/// Displays the button to shuffle the puzzle.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleNormalButton extends StatefulWidget {
  /// {@macro puzzle_shuffle_button}
  const SimplePuzzleNormalButton({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _SimplePuzzleNormalButtonState createState() =>
      _SimplePuzzleNormalButtonState();
}

class _SimplePuzzleNormalButtonState extends State<SimplePuzzleNormalButton> {
  @override
  Widget build(BuildContext context) {
    var currentBackgroundColor = PuzzleColors.primary7;
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    if (state.mode == Mode.normal) {
      currentBackgroundColor = PuzzleColors.primary10;
    }

    return PuzzleButton(
      textColor: PuzzleColors.primary0,
      backgroundColor: currentBackgroundColor,
      onPressed: () {
        context.read<PuzzleBloc>().add(const PuzzleNormal());
        // setState(() {});
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(context.l10n.puzzleNormal),
        ],
      ),
    );
  }
}
