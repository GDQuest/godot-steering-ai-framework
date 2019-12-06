# Steering Behavior Toolkit #

This document describes an evolution to the design of the Steering Behavior AI system that was produced for the Hook! game. In that iteration, behaviors and agents were nodes, requiring tree iteration and holding node references. This version, on the other hand, is built entirely around Reference types which could be held on the root node of an actor. Once again, it is greatly inspired by the excellent GDX-AI module for LibGDX.

This document will be changed to a more thorough set of documentation for the actual system once it's implemented.

## Types ##

### Agent ###

_extends Reference_

The agent is the agent from which information is derived from to determine where the actor is, how fast it's currently going and rotating, as well as its mass and speed/velocity limits, and anything else the various behaviors use to calculate the result. It is the programmer's job to keep the Agent's values updated every frame.

### Proximity ###

_extends Reference_

Defines an area that is used by group behaviors to determine who is or isn't within the owner's neighbors. It is the programmer's job to make sure all relevant members of the group are within the Proximity so that no member is not accounted for.

### TargetAcceleration ###

_extends Reference_

A type that holds the desired increase to linear and angular velocities. Its contents get replaced by the behaviors.

### Behaviors ###
#### Behavior ####

_extends Reference_

The base type for steering behaviors. This will have a public facing calculate_steering, and a private facing version that should will be overriden.

#### Combination Behaviors ####
##### Blended #####

_extends Behavior_

Blended combines any number of behaviors, each one having a certain weight that indicates how strongly it affects the end velocities. For instance, a Seek blended with a 2x force AvoidCollision.

##### Priority #####

_extends Behavior_

Contains any number of behaviors, then iterates through them in order until one of them produces non-zero acceleration. Then it uses that one and skips the rest.

#### Individual Behaviors ####

##### Seek #####

_extends Behavior_

Given a target Agent, the math will produce a linear acceleration that will move it directly towards where the target is at this present time.

##### Flee #####

_extends Seek_

Given a target Agent, the math will produce a linear acceleration that will move it directly away where the target is at this present time.

##### Arrive #####

_extends Behavior_

Given a target Agent, the math will produce a linear acceleration that will move it directly towards where the target is at this present time, but aim to arrive there with zero velocity within a set amount of time.

##### MatchOrientation #####

_extends Behavior_

Given a target Agent, the math will produce an angular acceleration that will rotate the agent until its degree of rotation matches the target's, aiming to have zero rotation by the time it reaches it.

##### Pursue #####

_extends Behavior_

Given a target Agent, the math will produce a linear acceleration that will move it towards where the target will be by the time the agent reaches it, up to a maximum prediction time.

##### Evade #####

_extends Pursue_

Given a target Agent, the math will produce a linear acceleration that will move it away from where the target will be by the time the agent would reach it, up to a maximum prediction time.

##### Face #####

_extends MatchOrientation_

Given a target Agent, the math will produce an angular acceleration that will rotate the agent until it is facing its target, aiming to have zero rotation by the time it reaches it.

##### LookWhereYouAreGoing #####

_extends MatchOrientation_

The math will produce an angular acceleration that will rotate the agent until it is facing its current direction of linear travel, or no change if it is not moving.

##### FollowPath #####

_extends Arrive_

Given a target Array of locations making up a path, the math will produce a linear acceleration that will steer the agent along the path. Providing a non zero prediction time can make it cut corners, but appear to move more naturally.

##### Intersect #####

_extends Arrive_

Given two target Agents and a ratio of distance between them, the math will produce a linear acceleration that will steer the agent to reach the destination between them, cutting through an imaginary line between them.

##### MatchVelocity #####

_extends Behavior_

Given a target Agent, the math will produce a linear acceleration that will make its velocity the same as the target's.

##### Jump #####

_extends MatchVelocity_

Given a jump starting point, a target landing point, and information about gravity, the math will produce an acceleration that will make the agent reach the starting point at the velocity required to successfully jump and land at the target landing point.

#### Group Behaviors ####

##### GroupBehavior #####

_extends Behavior_

Base class for steering behaviors that take other agents in the world into consideration within an area around the owner.

##### Separation #####

_extends GroupBehavior_

Given a Proximity, the math will produce an acceleration that will keep the agent a minimum distance away from the proximity's owner.

##### Alignment #####

_extends GroupBehavior_

Given a Proximity, the math will produce an angular acceleration that will turn the agent to face along with the proximity's owner.

##### Cohesion #####

_extends GroupBehavior_

Given a Proximity, the math will produce a linear acceleration that will move the agent towards the center-of-mass of the Proximity group.

##### Hide #####

_extends Arrive_

Given a Proximity of obstacles and a target Agent, the math will produce a linear acceleration that will move the agent to the nearest hiding point to hide from the target behind an obstacle.

##### AvoidCollision #####

_extends GroupBehavior_

Given a Proximity of obstacles, the math will produce a linear acceleration that will move the agent away from the nearest obstacle in its proximity group.

##### RaycastAvoidCollision #####

_extends Behavior_

Given a configuration of Raycasts to perform, the math will produce a linear acceleration that will steer the agent away from anything the raycasts happen to hit.

## Usage ##

Instead of creating a complex array of nodes in a tree, instead the programmer will create the behaviors they need with `Reference.new()`, configuring required fields and calling behaviors' calculate_steering as they need from where they need. For example:

    //#KinematicBody2D
        var seek: = Seek.new()

        func _ready() -> void:
            configure


    //#StateMachine
        //#Follow
            var seek: Seek = owner.seek
            var accel: = TargetAcceleration.new()

            func physics_process(delta: float) -> void:
                accel = seek.calculate_steering(accel)
                owner.move_and_slide(accel.linear)
