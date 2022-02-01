// ignore_for_file: public_member_api_docs

part of 'puzzle_bloc.dart';

enum PuzzleStatus { incomplete, complete }

enum TileMovementStatus { nothingTapped, cannotBeMoved, moved }

class PuzzleState extends Equatable {
  static const normal =
      'You picked Normal mode. Try to solve the puzzle by rearranging the tiles in ascending order';
  static const hack =
      'You picked Hacker mode. Try to drag and drop all tiles in the drop target before running out of time.';
  static const crazy =
      'You are in Crazy mode. Try to arrange the tiles while board rotates :)';

  static const initialDisplays = [
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true
  ];
  // ignore: lines_longer_than_80_chars
  PuzzleState({
    this.puzzle = const Puzzle(tiles: []),
    this.puzzleStatus = PuzzleStatus.incomplete,
    this.tileMovementStatus = TileMovementStatus.nothingTapped,
    this.numberOfCorrectTiles = 0,
    this.numberOfMoves = 0,
    this.lastTappedTile,
    this.animationController,
    this.mode = Mode.normal,
    this.instruction = normal,
    this.totalScore = 0,
    this.isTotalScoreShown = false,
    this.puzzleHackFinished = false,
    this.tileDisplays = initialDisplays,
  });

  /// [Puzzle] containing the current tile arrangement.
  final Puzzle puzzle;

  /// Status indicating the current state of the puzzle.
  final PuzzleStatus puzzleStatus;

  /// Status indicating if a [Tile] was moved or why a [Tile] was not moved.
  final TileMovementStatus tileMovementStatus;

  /// Represents the last tapped tile of the puzzle.
  ///
  /// The value is `null` if the user has not interacted with
  /// the puzzle yet.
  final Tile? lastTappedTile;

  /// Number of tiles currently in their correct position.
  final int numberOfCorrectTiles;

  /// Number of tiles currently not in their correct position.
  int get numberOfTilesLeft => puzzle.tiles.length - numberOfCorrectTiles - 1;

  /// Number representing how many moves have been made on the current puzzle.
  ///
  /// The number of moves is not always the same as the total number of tiles
  /// moved. If a row/column of 2+ tiles are moved from one tap, one move is
  /// added.
  final int numberOfMoves;

  AnimationController? animationController;

  Mode mode;

  String instruction;
  // ignore: lines_longer_than_80_chars

  int totalScore;

  bool isTotalScoreShown = false;

  bool puzzleHackFinished = false;

  List<bool> tileDisplays;

  PuzzleState copyWith({
    Puzzle? puzzle,
    PuzzleStatus? puzzleStatus,
    TileMovementStatus? tileMovementStatus,
    int? numberOfCorrectTiles,
    int? numberOfMoves,
    Tile? lastTappedTile,
    AnimationController? animationController,
    Mode? mode,
    String? instruction,
    int? totalScore,
    bool? isTotalScoreShown,
    bool? puzzleHackFinished,
    List<bool>? tileDisplays,
  }) {
    return PuzzleState(
      puzzle: puzzle ?? this.puzzle,
      puzzleStatus: puzzleStatus ?? this.puzzleStatus,
      tileMovementStatus: tileMovementStatus ?? this.tileMovementStatus,
      numberOfCorrectTiles: numberOfCorrectTiles ?? this.numberOfCorrectTiles,
      numberOfMoves: numberOfMoves ?? this.numberOfMoves,
      lastTappedTile: lastTappedTile ?? this.lastTappedTile,
      animationController: animationController ?? this.animationController,
      mode: mode ?? this.mode,
      instruction: instruction ?? this.instruction,
      totalScore: totalScore ?? this.totalScore,
      isTotalScoreShown: isTotalScoreShown ?? this.isTotalScoreShown,
      puzzleHackFinished: puzzleHackFinished ?? this.puzzleHackFinished,
      tileDisplays: tileDisplays ?? this.tileDisplays,
    );
  }

  PuzzleState setAnimationController(AnimationController animationController) {
    this.animationController = animationController;
    return copyWith(animationController: animationController);
  }

  PuzzleState setMode(Mode newMode) {
    mode = newMode;
    return copyWith(mode: newMode);
  }

  PuzzleState setPuzzleHackFinished(bool value) {
    puzzleHackFinished = value;
    return copyWith(puzzleHackFinished: value);
  }

  PuzzleState setTotalScore(int score) {
    this.totalScore = score;
    return copyWith(totalScore: score);
  }

  PuzzleState setIsTotalScoreShown(bool value) {
    isTotalScoreShown = value;
    return copyWith(isTotalScoreShown: isTotalScoreShown);
  }

  PuzzleState setTileDisplays(int tileIndex, bool val) {
    tileDisplays[tileIndex] = val;
    return copyWith(tileDisplays: tileDisplays);
  }

  List<bool> resetTileDisplays() {
    tileDisplays = initialDisplays;
    return tileDisplays;
  }

  PuzzleState setInstruction(Mode mode) {
    if (mode == Mode.hack) {
      this.instruction = hack;
    } else if (mode == Mode.normal) {
      this.instruction = normal;
    } else if (mode == Mode.crazy) {
      this.instruction = crazy;
    }
    return copyWith(instruction: instruction);
  }

  @override
  List<Object?> get props => [
        puzzle,
        puzzleStatus,
        tileMovementStatus,
        numberOfCorrectTiles,
        numberOfMoves,
        lastTappedTile,
        animationController,
        mode,
        instruction,
        totalScore,
        puzzleHackFinished,
      ];
}
