import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:ray_world_game/components/world_collidable.dart';

import '../functions/direction.dart';

class Player extends SpriteAnimationComponent
    with HasGameRef, CollisionCallbacks {
  Player()
      : super(
          size: Vector2.all(50.0),
        ){
    add(RectangleHitbox());
  }

  Direction direction = Direction.none;

  Direction collisionDirection = Direction.none;

  bool hasCollided = false;

  final double playerSpeed = 300.0;

  final double animationSpeed = 0.15;

  late final SpriteAnimation runDownAnimation;

  late final SpriteAnimation runLeftAnimation;

  late final SpriteAnimation runUpAnimation;

  late final SpriteAnimation runRightAnimation;

  late final SpriteAnimation standingAnimation;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // sprite = await gameRef.loadSprite('player.png');
    // position = gameRef.size / 2;
    await loadAnimations().then((_) => {animation = standingAnimation});
  }

  @override
  void update(double dt) {
    super.update(dt);
    movePlayer(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if(other is WorldCollidable){
      if(!hasCollided){
        hasCollided = true;
        collisionDirection = direction;
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    hasCollided = false;
  }

  bool canPlayerMoveUp() {
    if (hasCollided && collisionDirection == Direction.up) {
      return false;
    }
    return true;
  }

  bool canPlayerMoveDown() {
    if (hasCollided && collisionDirection == Direction.down) {
      return false;
    }
    return true;
  }

  bool canPlayerMoveLeft() {
    if (hasCollided && collisionDirection == Direction.left) {
      return false;
    }
    return true;
  }

  bool canPlayerMoveRight() {
    if (hasCollided && collisionDirection == Direction.right) {
      return false;
    }
    return true;
  }


  void movePlayer(double delta) {
    switch (direction) {
      case Direction.up:
        if (canPlayerMoveUp()) {
          animation = runUpAnimation;
          moveUp(delta);
        }
        break;
      case Direction.down:
        if (canPlayerMoveDown()) {
          animation = runDownAnimation;
          moveDown(delta);
        }
        break;
      case Direction.left:
        if (canPlayerMoveLeft()) {
          animation = runLeftAnimation;
          moveLeft(delta);
        }
        break;
      case Direction.right:
        if (canPlayerMoveRight()) {
          animation = runRightAnimation;
          moveRight(delta);
        }
        break;
      case Direction.none:
        animation = standingAnimation;
        break;
    }
  }


  void moveDown(double delta) {
    position.add(Vector2(0, delta * playerSpeed));
  }

  void moveUp(double delta) {
    position.add(Vector2(0, delta * -playerSpeed));
  }

  void moveLeft(double delta) {
    position.add(Vector2(delta * -playerSpeed, 0));
  }

  void moveRight(double delta) {
    position.add(Vector2(delta * playerSpeed, 0));
  }

  Future<void> loadAnimations() async {
    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load('player_spritesheet.png'),
      srcSize: Vector2(29.0, 32.0),
    );

    runDownAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: animationSpeed, to: 4);

    runLeftAnimation =
        spriteSheet.createAnimation(row: 1, stepTime: animationSpeed, to: 4);

    runUpAnimation =
        spriteSheet.createAnimation(row: 2, stepTime: animationSpeed, to: 4);

    runRightAnimation =
        spriteSheet.createAnimation(row: 3, stepTime: animationSpeed, to: 4);

    standingAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: animationSpeed, to: 1);
  }
}
