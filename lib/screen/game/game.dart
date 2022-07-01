import 'package:dino_runner/controller/audio_manager.dart';
import 'package:dino_runner/screen/sprites/dino_sprite.dart';
import 'package:dino_runner/screen/sprites/enemy_sprite.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/widgets.dart';

import '../../controller/enemy_manager.dart';


class GameScreen extends FlameGame with TapDetector {
  DinoSprite dino = DinoSprite();
  TextComponent? _scoreText;
  EnemyManager enemyManager = EnemyManager();
  int score = 0;


  static const _audioAssets = [
    '8Bit Platformer Loop.wav',
    'hurt7.wav',
    'jump14.wav',
  ];


  @override
  Future<void>? onLoad() async {

    await AudioManager.instance.init(_audioAssets);
    AudioManager.instance.startBgm('8Bit Platformer Loop.wav');

    final backgroundImages = [
      loadParallaxImage('parallex/plx-1.png'),
      loadParallaxImage('parallex/plx-2.png'),
      loadParallaxImage('parallex/plx-3.png'),
      loadParallaxImage('parallex/plx-4.png'),
      loadParallaxImage('parallex/plx-5.png'),
      loadParallaxImage('parallex/plx-6.png', fill: LayerFill.none),
    ];

    final layers = backgroundImages.map((image) async => ParallaxLayer(
        await image,
        velocityMultiplier: Vector2(backgroundImages.indexOf(image) * .2, 0)));
    final parallaxComponent = ParallaxComponent(
      parallax: Parallax(
        await Future.wait(layers),
        baseVelocity: Vector2(100, 0),
      ),
    );

    add(parallaxComponent);
    add(dino);

    _scoreText = TextComponent(text: score.toString());
    _scoreText?.position = Vector2((size.toSize().width/2) - _scoreText!.size.toSize().width/2, 20);
    add(_scoreText!);


    add(enemyManager);

    return super.onLoad();
  }

  void pauseGame(){
    pauseEngine();
    overlays.add('pauseMenu');
  }

  @override
  void onTapDown(TapDownInfo info) {
    dino.jump();
    super.onTapDown(info);
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        pauseGame();
        break;
      case AppLifecycleState.inactive:
        pauseGame();
        break;
      case AppLifecycleState.paused:
        pauseGame();
        break;
      default:
    }
    super.lifecycleStateChange(state);
  }

  @override
  void update(double dt) {
    score += (60 * dt).floor();
    _scoreText!.text = score.toString();
    _scoreText?.position = Vector2((size.toSize().width/2) - _scoreText!.size.toSize().width/2, 20);
    children.whereType<EnemySprite>().forEach((enemy) {
      if(dino.distance(enemy)<30){
        dino.hit();
      }
    });
    if(dino.life.value<=0){
      pauseEngine();
      overlays.add('gameOverMenu');
    }
    super.update(dt);
  }
}
