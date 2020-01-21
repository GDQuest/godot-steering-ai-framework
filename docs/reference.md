# Godot Steering Toolkit Reference #

This document presents the classes used in the toolkit, presenting their properties and functions. All types are derived from Godot's `Reference` type.

## GSTAgentLocation ##

Represents a location and an orientation. This can be used as a target by behaviors that do not need much information about their target besides where they are.

| Property name | Type | Description |
|---|---|---|
| position | Vector3 | The agent's location in space |
| orientation | float | The agent's rotation in space |

## GSTSteeringAgent ##

> extends GSTAgentLocation

Represents an agent with a maximum acceleration, speed, and current velocity. All steering behaviors will expect one of these as their owner.

| Property name | Type | Description |
|---|---|---|
| zero_linear_speed_threshold | float | The velocity at which the agent is considered to no longer be moving |
| max_linear_speed | float | The agent's maximum linear velocity |
| max_linear_acceleration | float | The agent's maximum linear acceleration |
| max_angular_speed | float | The agent's maximum angular velocity |
| max_angular_acceleration | float | The agent's maximum angular acceleration |
| linear_velocity | Vector3 | The agent's current linear velocity |
| angular_velocity | float | The agent's current angular velocity |
| bounding_radius | float | The size of the agent's bounding radius when approximated by a sphere |

## GSTTargetAcceleration ##

Holds a linear and an angular acceleration amount, calculated by steering behaviors.

| Property name | Type | Description |
|---|---|---|
| linear | Vector3 | The desired change in linear velocity |
| angular | float | The desired change in angular velocity |

### set_zero ###

Resets the linear and angular components of the acceleration to 0.

```swift
set_zero() -> void
```

### add_scaled_accel ###

Adds another acceleration, multiplied by a scalar, to this one.

```swift
add_scaled_accel(
        accel: GSTTargetAcceleration,
        scalar: float
) -> void
```

#### Parameters ####

accel - GSTTargetAcceleration  
The acceleration object to add to this acceleration

scalar - float  
What to multiply accel by before adding its components to this acceleration's

### get_magnitude_squared ###

Returns the squared length of the linear and angular components.

```swift
get_magnitude_squared() -> float
```

#### Return value ####

magnitude_squared - A float with the linear vector's squared length added to the angular acceleration squared

### get_magnitude ###

Returns the length of the lienar and angular components.

```swift
get_magnitude() -> float
```

#### Return value ####

magnitude - A float with the linear vector's length added to the angular acceleration

## GSTSteeringBehavior ##

This is the base class that all steering behaviors derive from. Its main point of entry is the `calculate_steering` function, which takes and modifies a `GSTTargetAcceleration` object with the result. All behaviors take a `GSTSteeringAgent` in their constructor

| Property name | Type | Description |
|---|---|---|
| enabled | bool | Whether this behavior should calculate. Disabled behaviors return zero acceleration |
| agent | GSTSteeringAgent | The agent which this behavior calculates its behavior for |

### calculate_steering ###

Calculates the behavior's desired acceleration

```swift
calculate_steering(
        acceleration: GSTTargetAcceleration
) -> GSTTargetAcceleration
```

#### Parameters ####

acceleration - GSTTargetAcceleration  
The acceleration that will store the desired linear and/or angular acceleration sought out by the behavior.

#### Return value ####

acceleration - The same acceleration passed as the parameter, for method chaining.

## GSTPath ##

This is a class to represent a path made up of a number of Vector3 points in space.

| Property name | Type | Description |
|---|---|---|
| open | bool | Whether this path is ends without looping back to its start point |
| length | float | The total length of the path |

### new ###

Creates a new instance of GSTPath

```swift
new(
        waypoints: Array,
        open: bool = false
) -> GSTPath
```

#### Parameters ####

waypoints - Array  
An array that contains a set of Vector3s, representing a continuous path

open - bool  
Whether the path should be open, or loop back on itself

### create_path ###

Recreates the path using the provided waypoints

```swift
create_path(
        waypoints: Array
) -> void
```

#### Parameters ####

waypoints - Array  
An array that contains a set of Vector3s, representing a continuous path

## GSTSeek ##

> extends GSTSteeringBehavior

Produces acceleration that takes the owner on a direct path to where its target is when `calculate_steering` is called.

| Property name | Type | Description |
|---|---|---|
| target | GSTAgentLocation | The target whose position the behavior will seek to |

`GSTFlee` acts exactly like GSTSeek, but returns an acceleration that takes the owner on a direct path away from where the target is.

### new ###

Creates a new instance of GSTPath

```swift
new(
        agent: GSTSteeringAgent,
        target: GSTAgentLocation
) -> GSTSeek
```

#### Parameters ####

agent - GSTSteeringAgent  
The agent whose acceleration will be calculated by this behavior

target - GSTAgentLocation  
The location or agent towards who the behavior will seek to

## GSTArrive ##

> extends GSTSteeringBehavior

Produces acceleration that takes the owner on a direct path to where its target is when `calculate_steering` is called, but seeks to arrive there with 0 remaining velocity.

| Property name | Type | Description |
|---|---|---|
| target | GSTAgentLocation | The target whose position the behavior will seek to |
| arrival_tolerance | float | The distance from the target that the behavior assumes is close enough to count as arrived on target |
| deceleration_radius | float | The distance from the target where the agent will begin to slow down |
| time_to_reach | float | The time it takes to enact a change in velocity. Defaults to 0.1, a good starting point |

### new ###

Creates a new instance of GSTPath

```swift
new(
        agent: GSTSteeringAgent,
        target: GSTAgentLocation
) -> GSTArrive
```

#### Parameters ####

agent - GSTSteeringAgent  
The agent whose acceleration will be calculated by this behavior

target - GSTAgentLocation  
The location or agent where the behavior will arrive at

## GSTPursue ##

> extends GSTSteeringBehavior

Produces acceleration that takes the owner on a path to where its target will be some time in the future when `calculate_steering` is called.

| Property name | Type | Description |
|---|---|---|
| target | GSTSteeringAgent | The target whose position the behavior will seek to |
| max_predict_time | float | The maximum number of seconds in the future to extrapolate the target's upcoming position |

`GSTEvade` acts like GSTPursue, but returns an acceleration that takes the owner on a path away from where its target will be some time in the future.

### new ###

Creates a new instance of GSTPath

```swift
new(
        agent: GSTSteeringAgent,
        target: GSTSteeringAgent,
        max_predict_time: float = 1.0
) -> GSTPursue
```

#### Parameters ####

agent - GSTSteeringAgent  
The agent whose acceleration will be calculated by this behavior

target - GSTAgentLocation  
The agent that the behavior will pursue

max_predict_time - float  
The maximum amount of time in seconds in the future to extrapolate the target's upcoming position

## GSTMatchOrientation ##

> extends GSTSteeringBehavior

Produces acceleration that will rotate the owner to match its target's own rotation when `calculate_steering` is called.

| Property name | Type | Description |
|---|---|---|
| target | GSTAgentLocation | The target whose rotation the behavior will match |
| alignment_tolerance | float | The rotational distance from the target's rotation that the behavior assumes is close enough to count as aligned |
| deceleration_radius | float | The rotational distance from the target's rotation where the agent will begin to slow down |
| time_to_reach | float | The time it takes to enact a change in velocity. Defaults to 0.1, a good starting point |

### new ###

Creates a new instance of GSTPath

```swift
new(
        agent: GSTSteeringAgent,
        target: GSTAgentLocation
) -> GSTMatchOrientation
```

#### Parameters ####

agent - GSTSteeringAgent  
The agent whose acceleration will be calculated by this behavior

target - GSTAgentLocation  
The location or agent whose orientation is to be matched

## GSTFace ##

> extends `GSTMatchOrientation`

Produces acceleration that will rotate the owner to point towards its target when `calculate_steering` is called.

### new ###

Creates a new instance of GSTPath

```swift
new(
        agent: GSTSteeringAgent,
        target: GSTAgentLocation
) -> GSTFace
```

#### Parameters ####

agent - GSTSteeringAgent  
The agent whose acceleration will be calculated by this behavior

target - GSTAgentLocation  
The location or agent towards who the behavior will look towards

## GSTLookWhereYouGo ##

> extends `GSTMatchOrientation`

Produces acceleration that will rotate the owner to point towards its direction of travel when `calculate_steering` is called.

### new ###

Creates a new instance of GSTPath

```swift
new(
        agent: GSTSteeringAgent
) -> GSTLookWhereYouGo
```

#### Parameters ####

agent - GSTSteeringAgent  
The agent whose acceleration will be calculated by this behavior

## GSTFollowPath ##

> extends `GSTArrive`

Produces acceleration that will make the owner follow the provided path when `calculate_steering` is called.

| Property name | Type | Description |
|---|---|---|
| path | GSTPath | The path that the owner will follow |
| path_offset | float | The amount of distance from the path that the agent is allowed to be and still be considered 'on path' |
| arrive_enabled | bool | Whether to defer to the arrive behavior, or seek along the path exactly |
| prediction_time | float | The amount of seconds in the future to extrapolate the agent's position along the path |

### new ###

Creates a new instance of GSTPath

```swift
new(
        agent: GSTSteeringAgent,
        path: GSTPath,
        path_offset: float = 0.0,
        prediction_time: float = 0.0
) -> GSTFollowPath
```

#### Parameters ####

agent - GSTSteeringAgent  
The agent whose acceleration will be calculated by this behavior

path - GSTPath  
The path that the agent is expected to adhere to

path_offset - float  
The amount of distance from the path that the agent is allowed to be at

prediction_time - float  
The maximum number of seconds in the future to predict the agent's arrival time at the next point on the path

## GSTGroupBehavior ##

> extends GSTSteeringBehavior

The base class from which all group behaviors derive from. Group behaviors make use of proximities, a way to define a group and identify one's immediate neighbors in the area.

| Property name | Type | Description |
|---|---|---|
| proximity | GSTProximity | The proximity that will identify this behavior's neighbors |

## GSTCohesion ##

> extends GSTGroupBehavior

Produces acceleration that will move the agent towards the center of mass of its neighbors in its proximity when `calculate_steering` is called.

### new ###

Creates a new instance of GSTPath

```swift
new(
        agent: GSTSteeringAgent,
        proximity: GSTProximity
) -> GSTCohesion
```

#### Parameters ####

agent - GSTSteeringAgent  
The agent whose acceleration will be calculated by this behavior

proximity - GSTProximity  
The proximity group that contains this behavior's potential neighbors

## GSTSeparation ##

> extends GSTGroupBehavior

Produces acceleration that will move the agent away from its neighbors in its proximity when `calculate_steering` is called.

| Property name | Type | Description |
|---|---|---|
| decay_coefficient | float | The coefficient for the inverse square law that determines the strength of the separation from a given neighbor |

### new ###

Creates a new instance of GSTPath

```swift
new(
        agent: GSTSteeringAgent,
        proximity: GSTProximity
) -> GSTSeparation
```

#### Parameters ####

agent - GSTSteeringAgent  
The agent whose acceleration will be calculated by this behavior

proximity - GSTProximity  
The proximity group that contains this behavior's potential neighbors

## GSTAvoidCollisions ##

> extends GSTGroupBehavior

Produces acceleration that will move the agent away from neighbors in order to avoid collisions in its way when `calculate_steering` is called.

### new ###

Creates a new instance of GSTPath

```swift
new(
        agent: GSTSteeringAgent,
        proximity: GSTProximity
) -> GSTAvoidCollisions
```

#### Parameters ####

agent - GSTSteeringAgent  
The agent whose acceleration will be calculated by this behavior

proximity - GSTProximity  
The proximity group that contains this behavior's potential neighbors

## GSTBlend ##

> extends GSTSteeringBehavior

Combines multiple steering behaviors into one, and returns acceleration that combines them all, each multiplied by an associated strength when `calculate_steering` is called.

### new ###

Creates a new instance of GSTPath

```swift
new(
        agent: GSTSteeringAgent
) -> GSTBlend
```

#### Parameters ####

agent - GSTSteeringAgent  
The agent whose acceleration will be calculated by this behavior

## GSTPriority ##

> extends GSTSteeringBehavior

Combines multiple steering behaviors into one, and returns acceleration for the first in the list that returns a non-zero amount of acceleration when `calculate_steering` is called.

| Property name | Type | Description |
|---|---|---|
| threshold_for_zero | float | The amount of acceleration which is considered to be close enough to zero to be considered zero |

### new ###

Creates a new instance of GSTPath

```swift
new(
        agent: GSTSteeringAgent
) -> GSTPriority
```

#### Parameters ####

agent - GSTSteeringAgent  
The agent whose acceleration will be calculated by this behavior
