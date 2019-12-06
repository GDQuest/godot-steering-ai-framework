# Steering Behavior Toolkit #

## Steering Behaviors ##

Making agents that use artificial intelligence move and behave fits in two main modules:

1. Decision making - Based on what the AI knows, how should it behave, what should it behave against/towards, when to do it, and other questions like that.
1. Action and reaction - How to act on the decision that has been taken, how to go from point A to point B, or how to act at all.

Steering Behaviors are systems that aim to help answer the second. They are, as their name implies, behaviors for the AI to undergo to steer its agents through the game world. For example, an enemy spaceship pursuing the player through an asteroid field needs to avoid collisions with asteroids it may run into, and move in the direction that will take it to where the player is.

Steering behaviors are a flexible and lower performance cost method of figuring out how to move around _immediately_ in a second-to-second resolution, relative to more expensive and complex pathfinding algorithms like A\* that aim to plot routes through the entire game field for movement that could be seconds or minutes into the future. Steering behaviors will not have as fine a resolution as complex pathfinding, but they are easier and more than sufficient for many games. They also have the added bonus of being able to work _with_ more complex pathfinding methods.

## Toolkit Purpose ##

The implementation laid out in this repository is built to run on the [Godot game engine](https://godotengine.org/). It is a purely GDScript code oriented design to keep scene trees from being bloated, geared towards the goal of making the game's programmer(s) life in making complex behaviors easier by prioritizing, combining, and chaining different modular, pre-packaged behaviors together.

## Toolkit Design and Features ##

The toolkit takes a lot of its inspiration from the AI module from [LibGDX](https://libgdx.badlogicgames.com/), a Java based game development framework, named GDX-AI. It's an exllencent base to work from. Some of the information in this document has a more thorough breakdown on the [GDX-AI Wiki](https://github.com/libgdx/gdx-ai/wiki/Steering-Behaviors). Though the technical aspects and Java-specific implementation details can be ignored and the toolkit will be far from identical in how it functions, it makes for an excellent primer and includes a few diagrams.

### Agent ###

The Agent type holds information on the actor's position, velocity of travel, current orientation, as well as speed limits, mass, drag, size and other similar information. This information is used by the behaviors. It is up to the programmer to keep this information up-to-date.

### Proximity ###

A way of defining a number of Agents within an area around an owner. For instance, in a spaceship game, the squad leader's ship would be the owner of the Proximity, and the agents would be in the group and their group-based behaviors would use that information to know where the area is and where it is going.

### TargetAcceleration ###

The result of each behavior results in a desired **change** in velocity, linear or angular. This can be added to the current velocity to go up and down until the target is reached. The TargetAcceleration type holds both a linear and an angular acceleration, though whether they are used depends on which behavior is used.

### Behaviors ###

- Combination Behaviors - More often than not, one behavior will not be enough to do everything you want your agent to do. These special behaviors take other behaviors and works to combine them. Combination behaviors can combine other combination behaviors.
    - Blended - Takes any number of behaviors and associates each with a strength that determines how strong that behavior is going to be. The final acceleration will be a combination of all behaviors in the blend.
    - Priority - Takes any number of behaviors, but the order matters - only the first to return a non-zero acceleration will be used, and all others ignored. Great for prioritizing avoiding firey death by crashing into an asteroid over pursuing the player.

- Individual Behaviors - Behaviors that only feature the agent and some target information, often another agent.
    - Seek/Flee - Produces acceleration to take the agent to where the target is right now. Flee is the opposite and moves away from where the target is.
	- Arrive - Produces acceleration to take the agent to where the target is, but slow down to zero velocity by the time it is on top of it.
	- MatchOrientation - Produces angular acceleration to turn the agent to match the target's own facing, and slow down to zero velocity by the time it is matched.
	- Pursue/Evade - Produces acceleration to take the agent to where the target will be by the time it is reached. Evade is the opposite and moves away from where the target is going to be.
	- Face - Produces angular acceleration to turn the agent towards the target. A turret could use this to keep a bead on enemies.
	- LookWhereYouAreGoing - Produces angular acceleration to turn the agent towards the direction it is traveling. This creates an agent that moves more naturally, especially if they can then choose to move independent of their travel upon need, like humans.
	- FollowPath - Produces acceleration that will lead the agent into following a given series of points that form a path. This can be a path generated by a complex pathfinding algorithm like A\*.
	- Intersect - Produces acceleration that will lead the agent to cut through an imaginary line between two other agents. For example, a bodyguard could try to bodyblock for a projectile to protect another agent.
	- MatchVelocity - Produces acceleration that will lead the agent to have the same velocity as its target. Mimics that pretend they're the players could use this.
	- Jump - Produces acceleration that will lead the agent to have enough velocity to jump against gravity from a target starting point with enough speed to land at the target landing point.

- Group Behaviors - Behaviors that use Proximity objects to keep track of other agents in a given group.
    - Separation - Produces acceleration that will keep the agent away from a distance from other neighbors in the Proximity group. Units in a RTS could be made to smartly keeping away from neighbors with an contagious infection, or units in spaceships keeping away from their target because their weapons are dangerous to themselves in short range (missiles).
	- Alignment - Produces angular acceleration that will rotate the agent to face along with the other agents in the Proximity group. Spaceships in a flight formation, for example.
	- Cohesion - Produces acceleration that will aim to keep the agents in the Proximity group in a balanced group within the Proximity. An example is a sheep catching up to the rest of its flock.
	- Hide - Produces acceleration that will keep the agent behind an object in the Proximity and a target agent. It could be a stalker in the forest staying out of sight but following the player.
	- AvoidCollisions - Produces acceleration that will keep the agent from hitting objects in the Proximity group. For example, moving through a minefield without hitting any of the mines.
	- RaycastAvoidCollisions - Produces acceleration that will prevent the agent from hitting something that it is usually facing - great for discovering that there is an obstacle in the agent's direction of travel, whereas AvoidCollisions works in a radius around the agent.

## Resources, links, and information ##

- [RedBlobGames](https://www.redblobgames.com/) - An excellent resources for complex pathfinding like A\*, graph theory, and other algorithms that are game-development related. Steering behaviors are not covered, but for anyone looking to study and bulk up on their algorithms, this is a great place.
- [Understanding Steering Behaviors](https://gamedevelopment.tutsplus.com/series/understanding-steering-behaviors--gamedev-12732) - Breakdowns of various behaviors by Fernando Bevilacqua with graphics and in-depth explanations that go beyond the scope of this document or GDX-AI's wiki entries.
- [GDX-AI Wiki - Steering Behaviors](https://github.com/libgdx/gdx-ai/wiki/Steering-Behaviors) - Descriptions of how LibGDX's AI submodule uses steering behaviors with a few graphics.