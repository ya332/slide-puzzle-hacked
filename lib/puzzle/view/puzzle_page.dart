// ignore_for_file: public_member_api_docs
// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/bloc/puzzle_bloc.dart';
import 'package:very_good_slide_puzzle/util/util.dart';

class PuzzlePage extends StatelessWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<PuzzleBloc>().add(const Initialize());

    return Scaffold(
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: PuzzleBoard()),
      ),
      backgroundColor: Colors.blue.shade100,
    );
  }
}

class PuzzleBoard extends StatelessWidget {
  const PuzzleBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tiles = context.select((PuzzleBloc bloc) => bloc.state.tiles);
    final size = getPuzzleDimension(tiles);
    final orderedTiles = tiles.toList()
      ..sort((tileA, tileB) =>
          tileA.currentPosition.compareTo(tileB.currentPosition));
    if (size == 0) {
      return const CircularProgressIndicator();
    } else {
      return GridView.count(
        crossAxisCount: size,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: [for (var tile in orderedTiles) TileWidget(tile: tile)],
      );
    }
  }
}

class TileWidget extends StatelessWidget {
  const TileWidget({Key? key, required this.tile}) : super(key: key);

  final Tile tile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<PuzzleBloc>().add(TileTapped(tile)),
      child: Container(
        decoration: BoxDecoration(
          color: (tile.value != 0) ? Colors.blue : Colors.blue.shade100,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
          child: (tile.value != 0)
              ? Text(
                  '${tile.value}',
                  style: const TextStyle(fontSize: 30),
                )
              : Container(),
        ),
      ),
    );
  }
}
