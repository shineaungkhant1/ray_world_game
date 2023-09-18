import 'dart:ui';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ray_world_game/components/world_collidable.dart';

import 'components/player.dart';
import 'components/world.dart';
import 'functions/direction.dart';
import 'functions/map_loader.dart';

class RayWorldGame extends FlameGame with HasCollisionDetection,KeyboardEvents{
  final Player player = Player();
  final World world = World();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await add(world);
    add(player);
    addWorldCollision();
    player.position = world.size / 2;
    camera.followComponent(player,
        worldBounds: Rect.fromLTRB(0, 0, world.size.x, world.size.y));
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event,
      Set<LogicalKeyboardKey> keysPressed,
      ) {
    final isKeyDown = event is RawKeyDownEvent;
    Direction? keyDirection;

    if (event.logicalKey == LogicalKeyboardKey.keyA) {
      keyDirection = Direction.left;
    } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
      keyDirection = Direction.right;
    } else if (event.logicalKey == LogicalKeyboardKey.keyW) {
      keyDirection = Direction.up;
    } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
      keyDirection = Direction.down;
    }


    if (isKeyDown && keyDirection != null) {
      player.direction = keyDirection;
    } else if (player.direction == keyDirection) {
      player.direction = Direction.none;
    }


    return super.onKeyEvent(event, keysPressed);
  }



  void addWorldCollision() async =>
      (await MapLoader.readRayWorldCollisionMap()).forEach((rect) {
    add(WorldCollidable()
        ..position = Vector2(rect.left, rect.top)
        ..width = rect.width
        ..height = rect.height);
  });

  void onJoypadDirectionChanged(Direction direction) {
    player.direction = direction;
  }
}
