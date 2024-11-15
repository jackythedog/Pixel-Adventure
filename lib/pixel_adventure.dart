import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/painting.dart';
import 'package:pixel_adventure/actors/player.dart';
import 'package:pixel_adventure/levels/level.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late CameraComponent cam;
  Player player = Player();
  late JoystickComponent joystick;
  bool showJoystick = true;

  @override
  FutureOr<void> onLoad() async {
    final world = Level(levelName: "level-02", player: player);

    // load all images into cache
    await images.loadAllImages();

    cam = CameraComponent.withFixedResolution(
        world: world, width: 640, height: 360);
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);

    if (showJoystick) {
      addJoysStick();
    }
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoyStick();
    }
    super.update(dt);
  }

  void addJoysStick() {
    joystick = JoystickComponent(
        knob: SpriteComponent(
            sprite: Sprite(
              images.fromCache("HUD/Knob.png"),
            ),
            size: Vector2.all(20)),
        background: SpriteComponent(
            sprite: Sprite(
              images.fromCache("HUD/Joystick.png"),
            ),
            size: Vector2.all(40)),
        margin: const EdgeInsets.only(left: 12, bottom: 20),
        knobRadius: 20);

    add(joystick);
  }

  void updateJoyStick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.playerDirection = PlayerDirection.left;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.playerDirection = PlayerDirection.right;
        break;
      default:
        //idle
        player.playerDirection = PlayerDirection.none;
        break;
    }
  }
}
