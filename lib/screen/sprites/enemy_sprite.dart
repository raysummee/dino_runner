import 'dart:math';

import 'package:dino_runner/core/enums/enemy_type_enum.dart';
import 'package:dino_runner/data/models/enemy_model.dart';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/rendering.dart';

import '../../core/constants.dart';

class EnemySprite extends SpriteAnimationComponent {
  
  EnemySprite(this.enemyType){
    _enemyData = _enemyDetails[enemyType];
  }

  var images = Images();
  late SpriteAnimation _runAnimation;
  late Size screenSize;
  EnemyTypeEnum enemyType;
  static final Random _random = Random();

  EnemyModel? _enemyData;

  static final Map<EnemyTypeEnum, EnemyModel> _enemyDetails = {
    EnemyTypeEnum.angryPig: EnemyModel(
        imageName: 'AngryPig/Walk (36x30).png',
        srcSize: Vector2(36, 30),
        nColumns: 16,
        canFly: false,
        speed: 250),
    EnemyTypeEnum.rino: EnemyModel(
        imageName: 'Rino/Run (52x34).png',
        srcSize: Vector2(52, 34),
        nColumns: 6,
        canFly: false,
        speed: 300),
    EnemyTypeEnum.bat: EnemyModel(
        imageName: 'Bat/Flying (46x30).png',
        srcSize: Vector2(46, 30),
        nColumns: 7,
        canFly: true,
        speed: 350),
  };

  
  
  @override
  Future<void>? onLoad() async {
    final enemyData = _enemyDetails[enemyType];
    anchor = Anchor.center;
    SpriteSheet dinoSheet = SpriteSheet(
      image: await images.load(enemyData!.imageName),
      srcSize: enemyData.srcSize,
    );
    _runAnimation = dinoSheet.createAnimation(
        row: 0, stepTime: 0.1, from: 0, to: enemyData.nColumns - 1);

    animation = _runAnimation;
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    screenSize = size.toSize();
    double scaleFactor = (screenSize.width / noOfTilesAlongWidth) / _enemyData!.srcSize.toSize().width;
    height = _enemyData!.srcSize.toSize().height * scaleFactor;
    width = _enemyData!.srcSize.toSize().width * scaleFactor;
    x = screenSize.width + width;
    y = screenSize.height - groundHeight - (height/2) + 3;

    if(_enemyData!.canFly && _random.nextBool()){
      y -= height;
    }
    super.onGameResize(size);
  }

  
  @override
  void update(double dt) {
    x -= _enemyData!.speed * dt;
    if (x < (-width)) {
      // x = screenSize.width + width;
      removeFromParent();
    }
    super.update(dt);
  }


}
