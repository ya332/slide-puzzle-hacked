import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/puzzle/bloc/puzzle_bloc.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/typography/typography.dart';
import 'package:countdown_progress_indicator/countdown_progress_indicator.dart';

/// {@template number_of_moves_and_tiles_left}
/// Displays how many moves have been made on the current puzzle
/// and how many puzzle tiles are not in their correct position.
/// {@endtemplate}
class NumberOfMovesAndTilesLeft extends StatefulWidget {
  /// {@macro number_of_moves_and_tiles_left}
  NumberOfMovesAndTilesLeft({
    Key? key,
    required this.numberOfMoves,
    required this.numberOfTilesLeft,
    this.color,
  }) : super(key: key);

  /// The number of moves to be displayed.
  final int numberOfMoves;

  /// The number of tiles left to be displayed.
  final int numberOfTilesLeft;

  /// The color of texts that display [numberOfMoves] and [numberOfTilesLeft].
  /// Defaults to [PuzzleTheme.defaultColor].
  final Color? color;

  @override
  State<NumberOfMovesAndTilesLeft> createState() =>
      _NumberOfMovesAndTilesLeftState();
}

class _NumberOfMovesAndTilesLeftState extends State<NumberOfMovesAndTilesLeft> {
  // ignore: public_member_api_docs
  bool isResultShown = false;
  int currentScore = 0;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final l10n = context.l10n;
    final textColor = widget.color ?? theme.defaultColor;
    final state = context.select((PuzzleBloc bloc) => bloc.state);
    final countDownController = CountDownController();

    return ResponsiveLayoutBuilder(
      small: (context, child) => Center(child: child),
      medium: (context, child) => Center(child: child),
      large: (context, child) => child!,
      child: (currentSize) {
        final bodyTextStyle = currentSize == ResponsiveLayoutSize.small
            ? PuzzleTextStyle.bodySmall
            : PuzzleTextStyle.body;

        final countDownAndStatusWidget = <Widget>[
          SizedBox(
            height: 100,
            width: 100,
            child: CountDownProgressIndicator(
              controller: countDownController,
              valueColor: Colors.red,
              backgroundColor: Colors.blue,
              duration: 10,
              text: 'secs',
              onComplete: () {
                setState(() {
                  isResultShown = true;
                  context.read<PuzzleBloc>().add(const PuzzleHackFinished());
                });
                // state.setIsTotalScoreShown(true);
              },
            ),
          ),
          RichText(
            key: const Key('numberOfMovesAndTilesLeft'),
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Drag Score: ${state.totalScore}/105',
              style: PuzzleTextStyle.headline4.copyWith(
                color: textColor,
              ),
            ),
          ),
          const ResponsiveGap(large: 32),
          Visibility(
            visible: isResultShown,
            child: RichText(
              text: TextSpan(
                style: PuzzleTextStyle.headline4.copyWith(
                  color: state.totalScore >= 105 ? Colors.blue : Colors.red,
                ),
                text: state.totalScore >= 105 ? 'You won!' : 'You lost!',
              ),
            ),
          )
        ];

        if (state.mode == Mode.hack) {
          return ResponsiveLayoutBuilder(
            small: (_, child) => Padding(
              padding: const EdgeInsets.only(top: 25, left: 50, right: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: countDownAndStatusWidget,
              ),
            ),
            medium: (_, child) => Padding(
              padding: const EdgeInsets.only(top: 25, left: 50, right: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: countDownAndStatusWidget,
              ),
            ),
            large: (_, child) => Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Row(
                children: countDownAndStatusWidget,
              ),
            ),
          );
        }
        return RichText(
          key: const Key('numberOfMovesAndTilesLeft'),
          textAlign: TextAlign.center,
          text: TextSpan(
            text: widget.numberOfMoves.toString(),
            style: PuzzleTextStyle.headline4.copyWith(
              color: textColor,
            ),
            children: [
              TextSpan(
                text: ' ${l10n.puzzleNumberOfMoves} | ',
                style: bodyTextStyle.copyWith(
                  color: textColor,
                ),
              ),
              TextSpan(
                text: widget.numberOfTilesLeft.toString(),
                style: PuzzleTextStyle.headline4.copyWith(
                  color: textColor,
                ),
              ),
              TextSpan(
                text: ' ${l10n.puzzleNumberOfTilesLeft}',
                style: bodyTextStyle.copyWith(
                  color: textColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
