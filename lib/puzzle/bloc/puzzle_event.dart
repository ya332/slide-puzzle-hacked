// ignore_for_file: public_member_api_docs

part of 'puzzle_bloc.dart';

abstract class PuzzleEvent extends Equatable {
  const PuzzleEvent();

  @override
  List<Object> get props => [];
}

class PuzzleInitialized extends PuzzleEvent {
  const PuzzleInitialized({required this.shufflePuzzle});

  final bool shufflePuzzle;

  @override
  List<Object> get props => [shufflePuzzle];
}

class TileTapped extends PuzzleEvent {
  const TileTapped(this.tile);

  final Tile tile;

  @override
  List<Object> get props => [tile];
}

class PuzzleReset extends PuzzleEvent {
  const PuzzleReset();
}

class PuzzleShuffle extends PuzzleEvent {
  const PuzzleShuffle();
}

class PuzzleCrazy extends PuzzleEvent {
  const PuzzleCrazy();
}

class PuzzleHack extends PuzzleEvent {
  const PuzzleHack();
}

class PuzzleNormal extends PuzzleEvent {
  const PuzzleNormal();
}

class PuzzleHackFinished extends PuzzleEvent {
  const PuzzleHackFinished();
}

class PuzzleScoreAdded extends PuzzleEvent {
  const PuzzleScoreAdded(this.data);

  final int data;

  @override
  List<Object> get props => [data];
}
