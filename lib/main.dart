import 'package:dino_runner/screen/game/game.dart';
import 'package:dino_runner/screen/sprites/enemy_sprite.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  runApp(
    const DinoRunApp()
  );
}

Widget _buildHud(GameScreen ref){
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: (){
            ref.pauseEngine();
            ref.overlays.add('pauseMenu');
          }, 
          icon: const Icon(
            Icons.pause,
            color: Colors.white,
            size: 30,
          )
        ),
        ValueListenableBuilder(
          valueListenable: ref.dino.life,
          builder: (context, int value, child) {
            final list = List.generate(value, (index) => const Icon(Icons.favorite, size: 30, color: Colors.red,),);
            
            return Row(
              children: list,
            );
          },
        )
      ],
    ),
  );
}

Widget _buildPauseMenu(GameScreen ref){
  return Center(
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      color: Colors.black.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Paused",
              style: TextStyle(
                color: Colors.white,
                fontSize: 21
              ),
            ),
            IconButton(
              onPressed: (){
                ref.resumeEngine();
                ref.overlays.remove('pauseMenu');
              }, 
              icon: const Icon(
                Icons.play_arrow,
                size: 30,
                color: Colors.white,
              )
            )
          ],
        ),
      ),
    ),
  );
}

Widget _buildGameOverMenu(GameScreen ref){
  return Center(
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      color: Colors.black.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Game Over",
              style: TextStyle(
                color: Colors.white,
                fontSize: 21
              ),
            ),
            Text(
              "Your score was ${ref.score}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 21
              ),
            ),
            IconButton(
              onPressed: (){
                ref.overlays.remove('gameOverMenu');
                ref.score = 0;
                ref.dino.life.value = 5;
                ref.enemyManager.reset();
                ref.dino.run();
                ref.children.whereType<EnemySprite>().forEach((element) {
                  element.removeFromParent();
                });
                ref.resumeEngine();
              }, 
              icon: const Icon(
                Icons.replay_outlined,
                size: 30,
                color: Colors.white,
              )
            )
          ],
        ),
      ),
    ),
  );
}


class DinoRunApp extends StatelessWidget {
  const DinoRunApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dino Run',
      home: Scaffold(
        body: GameWidget(
          game: GameScreen(),
          loadingBuilder: (_)=> const CircularProgressIndicator(),
          overlayBuilderMap: {
            'Hud': (_, GameScreen gameRef)=> _buildHud(gameRef),
            'pauseMenu': (_, GameScreen gameRef)=> _buildPauseMenu(gameRef),
            'gameOverMenu': (_, GameScreen gameRef)=> _buildGameOverMenu(gameRef),
          },
          initialActiveOverlays: ["Hud"],
        ),
      ),
    );
  }
}
