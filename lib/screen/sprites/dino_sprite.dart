import 'package:dino_runner/core/constants.dart';
import 'package:dino_runner/core/controller/audio_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/cache.dart';
import 'package:flutter/foundation.dart';

class DinoSprite extends SpriteAnimationComponent {
  var images = Images();
  late SpriteAnimation _runAnimation;
  late SpriteAnimation _hitAnimation;
  double speedY = 0.0;
  double maxY = 0.0;

  Timer? _timer;

  bool isHit = false;

  final ValueNotifier<int> life = ValueNotifier(5);

  @override
  Future<void>? onLoad() async {
    SpriteSheet dinoSheet = SpriteSheet(
      image: await images.load('DinoSprites - mort.png'),
      srcSize: Vector2.all(24),
    );
    anchor = Anchor.center;
    _runAnimation =
        dinoSheet.createAnimation(row: 0, stepTime: 0.1, from: 4, to: 10);
    _hitAnimation =
        dinoSheet.createAnimation(row: 0, stepTime: 0.1, from: 14, to: 16);

    animation = _runAnimation;

    _timer = Timer(1, onTick: (() {
      run();
    }));

    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    height = width = size.toSize().width / 10;
    x = width;
    y = size.toSize().height - groundHeight - (height/2) + 12;
    maxY = y;
    super.onGameResize(size);
  }

  @override
  void update(double dt) {
    //v = u+at
    speedY += GRAVITY * dt;
    //d = vt
    y += speedY * dt;

    if (isOnGround()) {
      y = maxY;
      speedY = 0;
    }

    _timer?.update(dt);
    super.update(dt);
  }

  bool isOnGround() {
    return y >= maxY;
  }

  void run() {
    animation = _runAnimation;
    isHit = false;
  }

  void hit() {
    if(!isHit){
      life.value -= 1;
      animation = _hitAnimation;
      _timer?.start();
      isHit = true;
      AudioManager.instance.playSfx('hurt7.wav');
    }
  }

  void jump() {
    if (isOnGround()) {
      AudioManager.instance.playSfx('jump14.wav');
      speedY = -500;
    }
  }
}
