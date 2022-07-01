import 'package:flame/extensions.dart';

class EnemyModel {
  final String imageName;
  final Vector2 srcSize;
  final int nColumns;
  final bool canFly;
  final int speed;

  const EnemyModel(
      {required this.imageName,
      required this.srcSize,
      required this.nColumns,
      required this.canFly,
      required this.speed});
}
