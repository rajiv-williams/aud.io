import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_project/music_classes/models/song.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../../music_classes/models/db_utils.dart';
import 'fav_genre.dart';

class GenreModel {

  /*
  * Cloud Storage Functions
  * */
  String songCollectionID = "qH6SDHlnOTIVWWuBjnWP";

  List<String> genres = [
    "Hip Hop", "alternative", "classical",
    "dance", "grime", "pop", "rock", "soul"
  ];

  /*
  * Local Storage Functions
  * */
  Future<int> insertGenre(FavGenre genre) async{
    final db = await DBUtils.init();
    return db.insert(
      'genre_items',
      genre.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future getAllGenres() async {
    final db = await DBUtils.init();
    final List maps = await db.query('genre_items');
    List result = [];
    for (int i = 0; i < maps.length; i++){
      result.add(
          FavGenre.fromMap(maps[i])
      );
    }
    print(result);
    return result;
  }

  Future<int> deleteGenreById(int id) async {
    final db = await DBUtils.init();
    return db.delete(
      'genre_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}

