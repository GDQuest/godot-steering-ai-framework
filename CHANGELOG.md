# Changelog #

This document lists new features, improvements, changes, and bug fixes in every release of the add-on.

## Godot Steering Toolkit 1.0.0 ##

This is the first major release of the framework. It comes with:

- All the essential steering behaviors: `Arrive`, `AvoidCollisions`, `Blend`, `Cohesion`, `Evade`, `Face`, `Flee`, `FollowPath`, `LookWhereYouGo`, `MatchOrientation`, `Priority`, `Pursue`, `Seek`, `Separation`.
- Group behaviors and detecting neighbors.
- Blending and prioritized behaviors.
- Specialized types to code agents based on physics bodies:
    - For 2D games, `KinematicBody2DAgent` and `RigidBody2DAgent`.
    - For 3D games, `KinematicBody3DAgent` and `RigidBody3DAgent`.
- 9 Godot demos to learn straight from the code.

### Manual ###

To get started, check out the framework's [manual](https://www.gdquest.com/docs/godot-steering-toolkit/).

There, you can also find the full [code reference](https://www.gdquest.com/docs/godot-steering-toolkit/reference/).

*Note*: we generate the code reference from docstrings in the source code with [GDScript Docs Maker](https://github.com/GDQuest/gdscript-docs-maker).

