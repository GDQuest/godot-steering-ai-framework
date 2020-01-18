# Steering Toolkit #

## Introduction ##

Agents in games can have rather complex behavioral needs. `Chase the player without crashing into other chasers while prioritizing picking up guns` could be a summary of a given AI's goals, but how to go about writing this behavior is a different issue altogether. Thankfully, smart people have cleared a lot of the hard work. The common steering behaviors' algorithms used in this toolkit originate as the mind child of [Craig Reynolds](http://www.red3d.com/cwr/) in the 1990s, but the implementation is highly inspired from the java game framework [LibGDX](https://libgdx.badlogicgames.com/)'s excellent [GDX-AI](https://github.com/libgdx/gdx-ai) framework.

Steering behaviors produce a 'desired force' that describes where and how an agent should move. They operate in a frame-to-frame mindset, using relatively simple math to calculate how an agent should move. That makes them fairly inexpensive compared to complex pathfinding algorithms like A\*, while being more easily written in a reusable way compared to highly specialized behavioral code made up of if statements that only works on one single agent type. You can achieve many kinds of movement by combining behaviors together, and this toolkit aims to provide an easy way to do just that.

## A couple things to keep in mind ##

 - To keep the math simple, agents move as if they are points with no size. Some collision detection and obstacle avoidance behaviors will use an agent's size to influence itself, but the movement will not consider whether or not an agent can actually fit in an opening without some help.
 - The behaviors that govern linear movement work fully in 3D, but the behaviors with an angular component keep the math simple by expecting the character will be upright and rotate around its Y axis. More complex six-axis motion may need more specialized code.
 - While the behaviors use Vector3 internally to run all of the math to support 3D games, it will work perfectly well with 2D. However, the user will have to convert between Vector3 and Vector2 as needed.

## The API ##

The toolkit works entirely by extending Godot's `Reference` type. This means that all behavior and behavior types are updated in code, rather than needing to form a complex tree of nodes that can unnecessarily bloat a scene tree. Ideally, all types should be declared wherever the movement code is to occur.

The breakdown of how it works is that any given behavior has a function called `calculate_steering`. It takes a type `GSTTargetAcceleration` and transforms it internally. The result are a desired linear and angular amount of *acceleration*; that is, a change in velocity.

### Types ###

There are a few classes that will be used extensively by the steering toolkit:

 - `GSTSteeringAgent`: The base type to represent an agent. All behaviors will expect an instance of this class as the main source of information. It represents an agent with a location and orientation, and has information like current velocity, maximum speeds and accelerations, and approximate size.
   - `GSTAgentLocation`: Certain behaviors only need the location of another agent to represent a "target" without any need for its current velocity. This class, which `GSTSteeringAgent` extends, only has location and orientation.
 - `GSTProximity`: This class defines an area used by group-based behaviors to find the owner's neighbors.
 - `GSTSteeringBehavior`: The base class which all other behaviors extend. This is the class that calculates a linear and/or angular acceleration meant to be applied to its owner.
 - `GSTTargetAcceleration`: Represents the amount of linear and/or angular acceleration that was calculated by a steering behavior.

Each steering behavior has the same structure: they take an `GSTSteeringAgent` as input to act as the owner of the behavior, and some behavior-specific parameters. The main point of entry to calculate acceleration is `calculate_steering` and it takes an instance of `GSTTargetAcceleration`, which gets transformed internally. Only enabled behaviors can return non-zero acceleration.

This value is only the acceleration that is *requested* by the steering toolkit. It must then be applied by the user using whatever method they choose, whether adding it to a velocity or applications of force, torque and impulse. It's also worth noting that steering behaviors only deal with accelerations - it's up to the user to set and maintain a maximum speed, if applicable.

### Individual Behaviors ###

Behaviors that only account for a limited number of agents; generally just the owner and maybe a target or two.

#### Seek and Flee ####

`GSTSeek` provides linear acceleration to move the owner directly towards the target position, which can be a `GSTAgentLocation` or `GSTSteeringAgent`.

`GSTFlee` provides linear acceleration to move the owner directly away from the target position, which can be a `GSTAgentLocation` or `GSTSteeringAgent`.

#### Arrive ####

`GSTArrive` provides linear acceleration to move the owner directly towards the target position, which can be a `GSTAgentLocation` or `GSTSteeringAgent`, but seeks to arrive at the target with 0 velocity.

 - `arrival_tolerance`: A radius that defines the distance from the target from which it can still be considered 'on target'.
 - `deceleration_radius`: A radius that specifies at what distance should the incoming agent begin to slow down. Too small may cause the agent to overshoot the target.
 - `time_to_target`: The time over which the target velocity can be reached, since an agent generally cannot change velocity instantly. A small value, like the default 0.1, is generally a good starting point.

#### Match Orientation ####

`GSTMatchOrientation` provides angular acceleration that will turn the owner to the target's orientation, which can be a `GSTAgentLocation` or `GSTSteeringAgent`. It behaves similarly to Arrive in that it will try to reach the target orientation and have zero rotational speed by the time it reaches it.

 - `alignment_tolerance`: Functions like Arrive's `arrival_tolerance` and indicates the distance that indicates an acceptable arrival point.
 - `deceleration_radius`: Functions like Arrive's `deceleration_radius` and indicates the angular distance before the agent starts slowing down.
 - `time_to_target`: Functions like Arrive's and defaults to 0.1.

#### Pursue and Evade ####

`GSTPursue` provides linear acceleration to move the owner towards the target position, which is a `GSTSteeringAgent`. The pursue behavior will try to predict where the agent will be in time T and seek towards that point to intercept it.

 - `max_predict_time`: The maximum amount of time in the future that the behavior will try to predict. If a target is far away or the agent is moving very slowly, the time could otherwise be so large that the prediction would be wildly off.

`GSTEvade` is an inversion of Pursue, and makes the agent flee from the future estimated position of the target.

#### Face ####

`GSTFace` provides angular acceleration that will turn the owner to look at its target, which can be a `GSTAgentLocation` or `GSTSteeringAgent`. Under the hood, it delegates code to `GSTMatchOrientation` and so uses its properties.

#### Look Where You Are Going ####

`GSTLookWhereYouGo` provides angular acceleration that will turn the owner to look in the direction of its current velocity. Under the hood, it delegates code to `GSTMatchOrientation` and so uses its properties.

#### Path following ####

`GSTFollowPath` provides linear acceleration to move the owner along the given path, of type `GSTPath`.

### Group Behaviors ###

Group behaviors are behaviors that take into consideration some or all of the objects in the game world. An agent will consider characters within its immediate area, as defined by a `GSTProximity`.

#### Separation ####

`GSTSeparation` is a group behavior that provides linear acceleration that repels it from the other neighbors defined in its immediate area defined by the given Proximity. The acceleration is calculated by examining each neighbor and adding its direction vector scaled by a strength decreasing according to distance via the inverse square law.

#### Cohesion ####

`GSTCohesion` is a group behavior that provides linear acceleration that attempts to move the agent towards the center of mass of the agents in its immediate area defined by the given Proximity. The acceleration is calculated by examining each neighbor and averaging their position to find the center of mass of the neighbors.

#### Avoid Collisions ####

`GSTAvoidCollisions` steers the owner to avoid obstacles lying in its path. An obstacle is any object that can be approximated by a sphere, and is defined by a given Proximity. The acceleration is calculated by working out who is the closest agent and reacting to avoid them first and foremost.

### Combining Behaviors ###

Individually, steering behaviors do a good job of moving within their parameters. However, more often than not, an agent will need to use more than one steering behaviors, and will need to steer differently based on different factors. For instance, it should avoid collisions before it tries to seek the player, but it should also look where it is going.

That is where combination behaviors come into effect. Combination behaviors can contain other combination behaviors.

#### Blended Steering ####

`GSTBlend` is a combination behavior that sums up all of the active behaviors within it, multiplied by a strength. All behaviors in the blended behavior are evaluated, which could make it more costly, and behavior weights need to be tweaked to achieve an optimal result that avoids forces that are conflicting/opposite.

#### Priority Steering ####

`GSTPriority` is a combination behavior that iterates through the active behaviors within it and returns the result of the first non-zero acceleration, skipping all the others afterwards.