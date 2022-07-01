import 'dart:math';

import 'package:dino_runner/core/enums/enemy_type_enum.dart';
import 'package:dino_runner/screen/game/game.dart';
import 'package:dino_runner/screen/sprites/enemy_sprite.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class EnemyManager extends Component with HasGameRef<GameScreen>{
  late Random _random;
  late Timer _timer;
  int spawnLevel = 0;
  
  EnemyManager(){
    _random = Random();
    _timer = Timer(4, repeat: true,onTick: (){
      spawnEnemy();
    });
  }

  void spawnEnemy(){
    final randomNumber = _random.nextInt(EnemyTypeEnum.values.length);
    final randomEnemyType = EnemyTypeEnum.values.elementAt(randomNumber);
    final newEnemy = EnemySprite(randomEnemyType);
    gameRef.add(newEnemy);
  }

  void reset(){
    spawnLevel = 0;
    _timer = Timer(4, repeat: true,onTick: (){
      spawnEnemy();
    });
  }

  @override
  void onMount() {
    _timer.start();
    super.onMount();
  }

  @override
  void update(double dt) {
    _timer.update(dt);
    var newSpawnLevel = gameRef.score ~/ 500;
    if(spawnLevel<newSpawnLevel){
      spawnLevel = newSpawnLevel;

      var newWaitTime = (4/ (1 + (0.1 * newSpawnLevel)));
      debugPrint(newWaitTime.toString());
      _timer.stop();
      _timer = Timer(newWaitTime, repeat: true,onTick: (){
        spawnEnemy();
      });
      _timer.start();
    }
    super.update(dt);
  }
}