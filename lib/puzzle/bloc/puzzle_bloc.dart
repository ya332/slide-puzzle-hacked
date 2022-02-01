// ignore_for_file: public_member_api_docs

import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:very_good_slide_puzzle/models/models.dart';

part 'puzzle_event.dart';
part 'puzzle_state.dart';

enum Mode { normal, crazy, hack }

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  PuzzleBloc(this._size, {this.random}) : super(PuzzleState()) {
    on<PuzzleInitialized>(_onPuzzleInitialized);
    on<TileTapped>(_onTileTapped);
    on<PuzzleReset>(_onPuzzleReset);
    on<PuzzleShuffle>(_onPuzzleShuffle);
    on<PuzzleCrazy>(_onPuzzleCrazy);
    on<PuzzleHack>(_onPuzzleHack);
    on<PuzzleNormal>(_onPuzzleNormal);
    on<PuzzleScoreAdded>(_onPuzzleScoreAdded);
    on<PuzzleHackFinished>(_onPuzzleHackFinished);
  }

  final int _size;

  final Random? random;

  void _onPuzzleInitialized(
    PuzzleInitialized event,
    Emitter<PuzzleState> emit,
  ) {
    final puzzle = _generatePuzzle(_size, shuffle: event.shufflePuzzle);
    emit(
      PuzzleState(
        puzzle: puzzle.sort(),
        numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
      ),
    );
  }

  void _onPuzzleReset(PuzzleReset event, Emitter<PuzzleState> emit) {
    state.setMode(Mode.normal);
    List<bool> resetDisplays = state.resetTileDisplays();
    if (state.animationController != null) {
      state.animationController?.reset();
    }
    emit(
      PuzzleState(
        puzzle: state.puzzle,
        numberOfCorrectTiles: state.puzzle.getNumberOfCorrectTiles(),
        mode: state.mode,
        puzzleHackFinished: false,
        tileDisplays: resetDisplays,
      ),
    );
  }

  void _onPuzzleHackFinished(
      PuzzleHackFinished event, Emitter<PuzzleState> emit) {
    emit(
      PuzzleState(
        puzzle: state.puzzle,
        numberOfCorrectTiles: state.puzzle.getNumberOfCorrectTiles(),
        mode: state.mode,
        puzzleHackFinished: true,
      ),
    );
  }

  void _onPuzzleScoreAdded(PuzzleScoreAdded event, Emitter<PuzzleState> emit) {
    print("state.totalScore" + state.totalScore.toString());
    var newDisplays = state.tileDisplays;
    var updatedScore = state.totalScore + event.data.toInt();
    print("before state.tileDisplays[event.data.toInt() - 1" +
        state.tileDisplays.toString());
    newDisplays[event.data.toInt() - 1] = false;
    final puzzle = _generatePuzzle(_size);
    print("after state.tileDisplays[event.data.toInt() - 1" +
        state.tileDisplays.toString());
    emit(
      PuzzleState(
        puzzle: puzzle.sort(),
        mode: state.mode,
        totalScore: updatedScore,
        tileDisplays: newDisplays,
      ),
    );
  }

  void _onPuzzleNormal(PuzzleNormal event, Emitter<PuzzleState> emit) {
    state.setMode(Mode.normal);
    state.setInstruction(Mode.normal);
    if (state.animationController != null) {
      state.animationController?.reset();
    }
    emit(
      PuzzleState(
        puzzle: state.puzzle,
        numberOfCorrectTiles: state.puzzle.getNumberOfCorrectTiles(),
        mode: state.mode,
      ),
    );
  }

  void _onPuzzleHack(PuzzleHack event, Emitter<PuzzleState> emit) {
    state.setMode(Mode.hack);
    state.setInstruction(Mode.hack);
    final animationController = state.animationController;
    animationController?.repeat();

    emit(
      PuzzleState(
        puzzle: state.puzzle,
        mode: state.mode,
        instruction: state.instruction,
      ),
    );
  }

  void _onTileTapped(TileTapped event, Emitter<PuzzleState> emit) {
    final tappedTile = event.tile;
    if (state.puzzleStatus == PuzzleStatus.incomplete) {
      if (state.puzzle.isTileMovable(tappedTile)) {
        final mutablePuzzle = Puzzle(tiles: [...state.puzzle.tiles]);
        final puzzle = mutablePuzzle.moveTiles(tappedTile, []);
        if (puzzle.isComplete()) {
          emit(
            state.copyWith(
              puzzle: puzzle.sort(),
              puzzleStatus: PuzzleStatus.complete,
              tileMovementStatus: TileMovementStatus.moved,
              numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
              numberOfMoves: state.numberOfMoves + 1,
              lastTappedTile: tappedTile,
            ),
          );
        } else {
          emit(
            state.copyWith(
              puzzle: puzzle.sort(),
              tileMovementStatus: TileMovementStatus.moved,
              numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
              numberOfMoves: state.numberOfMoves + 1,
              lastTappedTile: tappedTile,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
        );
      }
    } else {
      emit(
        state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
      );
    }
  }

  void _onPuzzleShuffle(PuzzleShuffle event, Emitter<PuzzleState> emit) {
    final puzzle = _generatePuzzle(_size);
    if (state.animationController != null) {
      state.animationController?.reset();
    }
    emit(
      PuzzleState(
        puzzle: puzzle.sort(),
        numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
      ),
    );
  }

  void _onPuzzleCrazy(PuzzleCrazy event, Emitter<PuzzleState> emit) {
    state.setMode(Mode.crazy);
    state.setInstruction(Mode.crazy);
    final animationController = state.animationController;
    animationController?.repeat();

    emit(
      PuzzleState(
        puzzle: state.puzzle,
        mode: state.mode,
        instruction: state.instruction,
      ),
    );
  }

  /// Build a randomized, solvable puzzle of the given size.
  Puzzle _generatePuzzle(int size, {bool shuffle = true}) {
    final correctPositions = <Position>[];
    final currentPositions = <Position>[];
    final whitespacePosition = Position(x: size, y: size);

    // Create all possible board positions.
    for (var y = 1; y <= size; y++) {
      for (var x = 1; x <= size; x++) {
        if (x == size && y == size) {
          correctPositions.add(whitespacePosition);
          currentPositions.add(whitespacePosition);
        } else {
          final position = Position(x: x, y: y);
          correctPositions.add(position);
          currentPositions.add(position);
        }
      }
    }

    if (shuffle) {
      // Randomize only the current tile posistions.
      currentPositions.shuffle(random);
    }

    var tiles = _getTileListFromPositions(
      size,
      correctPositions,
      currentPositions,
    );

    var puzzle = Puzzle(tiles: tiles);

    if (shuffle) {
      // Assign the tiles new current positions until the puzzle is solvable and
      // zero tiles are in their correct position.
      while (!puzzle.isSolvable() || puzzle.getNumberOfCorrectTiles() != 0) {
        currentPositions.shuffle(random);
        tiles = _getTileListFromPositions(
          size,
          correctPositions,
          currentPositions,
        );
        puzzle = Puzzle(tiles: tiles);
      }
    }

    return puzzle;
  }

  /// Build a list of tiles - giving each tile their correct position and a
  /// current position.
  List<Tile> _getTileListFromPositions(
    int size,
    List<Position> correctPositions,
    List<Position> currentPositions,
  ) {
    final whitespacePosition = Position(x: size, y: size);
    return [
      for (int i = 1; i <= size * size; i++)
        if (i == size * size)
          Tile(
            value: i,
            correctPosition: whitespacePosition,
            currentPosition: currentPositions[i - 1],
            isWhitespace: true,
          )
        else
          Tile(
            value: i,
            correctPosition: correctPositions[i - 1],
            currentPosition: currentPositions[i - 1],
          )
    ];
  }
}
