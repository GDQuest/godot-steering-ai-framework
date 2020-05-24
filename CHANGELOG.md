# Changelog

This document lists new features, improvements, changes, and bug fixes in every release of the add-on.

## Master

## Godot Steering AI Framework 3.0.0

### Changes

- The structure of the project has been overhauled in order to make it possible to import as an add-on in Godot directly.
- Acceleration for agents are now multiplied by delta in order to make acceleration be per second instead of instant. The demos' values have been increased significantly to better fit with reality.

### Fixes

- KinematicBody2DAgents and KinematicBody3DAgents that moved fast enough no longer reverse velocity suddenly during a frame where no acceleration is applied.
- Specialized Agents like RigidBody2DAgent should no longer crash due to a missing reference.
- Specialized physics agents no longer believe they are at 0,0,0 on the first frame.

## Godot Steering AI Framework 2.1.0

### Features

- There is now an `Arrive3d` demo to showcase 3D movement.

### Improvements

- All the demos got a bit of attention to improve their feel.

### Changes

- `GSAIUtils.vector3_to_angle` now uses the vector's X and Z components to determine angle. Use `GSAIUtils.vector2_to_angle` for 2D use cases.
- `GSAIMatchOrientation` and its subclasses like `GSAIFace` and `GSAILookWhereYouGo` now include a `use_z` property. It should be `true` when using 3D so that facing will be done with the X and Z components.
- The README now mentions a simple way to install the framework.
- Exposed `agent_count` inside the `AvoidCollisionsDemo`.
- Unused and undocumented variable `_body_type` has been removed from `SpecializedAgent`

### Bug fixes

- Fixed `GSAIKinematicBody3DAgent` and `GSAIRigidBody3DAgent` trying to use `global_position` instead of `transform.origin`.
- The `SeekFleeDemo`'s boundaries will now match the size of the screen.
- Fixed error when double clicking an item in the DemoPicker.
- Fixed the background sometimes not covering the entire viewport in demos.
- The specialized agents now use WeakRef internally to prevent crashes when their `body` is freed.
- `RigidBody2DAgent` now properly connects to physics updates.

## Godot Steering AI Framework 2.0.0

This release brings one new feature and bug fix, and breaking changes to the framework as we renamed all the classes.

**Important**: we renamed all classes from GST\* to GSAI\* (Godot Steering AI). When you upgrade the framework in your project, use the project search and replace feature in Godot (<kbd>Ctrl</kbd> <kbd>Shift</kbd> <kbd>F</kbd>) to find and replace `GST` with `GSAI`.

If you were using `GSTKinematicBodyAgent` or `GSTRigidBodyAgent`, search and replace them respectively with `GSAIKinematicBody3DAgent` and `GSAIRigidBody3DAgent`.

We decided to make this change as soon as possible, as the framework was released a few days ago.

### Features

- There is now a main scene with a demo picker, so you can select and play any demo on the fly.
- The demo projects now support resizing and toggling fullscreen with <kbd>F11</kbd>.

### Improvements

- We handled all warnings in the framework, so using it won't add warnings to your projects.

### Changes

- Renamed all classes from `GST*` (Godot Steering Toolkit) to `GSAI*` (Godot Steering AI).
- Removed `GSTNode2DAgent`, `GSTNodeAgent`, and `GSTSpatialAgent` classes.
    - For specialized steering agents, `GSAIKinematicBody2DAgent`, `GSAIRigidBody2DAgent`, or their 3D equivalent. 
    - If you intend to write your own movement system instead of using Godot's, the base class `GSTSpecializedAgent` is there to help you.
- Renamed `GSAIRigidBodyAgent` and `GSAIRigidBodyAgent` to `GSAIRigidBody3DAgent` and `GSAIRigidBody3DAgent` respectively.
    - 3D nodes like `Sprite`, `KinematicBody`, etc. are being renamed to `Sprite3D`, `KinematicBody3D`, etc. in the upcoming Godot 4.0 release, to be consistent with 2D nodes. We decided to rename them now instead of breaking compatibility in a future release.

### Bug fixes

- GSTFollowPath no longer loops back around itself on open paths when `predict_time` is non-zero.

## Godot Steering AI Framework 1.0.0

This is the first major release of the framework. It comes with:

- All the essential steering behaviors: `Arrive`, `AvoidCollisions`, `Blend`, `Cohesion`, `Evade`, `Face`, `Flee`, `FollowPath`, `LookWhereYouGo`, `MatchOrientation`, `Priority`, `Pursue`, `Seek`, `Separation`.
- Group behaviors and detecting neighbors.
- Blending and prioritized behaviors.
- Specialized types to code agents based on physics bodies:
    - For 2D games, `KinematicBody2DAgent` and `RigidBody2DAgent`.
    - For 3D games, `KinematicBody3DAgent` and `RigidBody3DAgent`.
- 9 Godot demos to learn straight from the code.

### Manual

To get started, check out the framework's [manual](https://www.gdquest.com/docs/godot-steering-toolkit/).

There, you can also find the full [code reference](https://www.gdquest.com/docs/godot-steering-toolkit/reference/).

*Note*: we generate the code reference from docstrings in the source code with [GDScript Docs Maker](https://github.com/GDQuest/gdscript-docs-maker).

