Asteroids Renderer
==================

Uses websockets to connect to [an asteroids game server](https://github.com/devstopfix/asteroids-server) and renders the game state on html canvas with fabric.js.

Usage
-----
```
npm install
npm start
```

Supported Game State Protocol
-----------------------------
```
{
  a:   [    [ id, x, y, r], ... ]           // List of asteroids
  s:   [    [ id, x, y, r, t, col], ... ]   // List of ships
  b:   [    [ id, x, y], ... ]              // List of bullets
  x:   [    [x, y], ... ]                   // List of explosions (only occur once)
  n:   integer                              // Incrementing frame number
  dim: [x, y]                               // The size of the play area (currently 4000.0 x 2250.0)
  hi:  [  [tag, score]  ]                   // Individual high score
  t:   [  [team, score]  ]                  // Team high score
}
```

Asteroid Definition
```
id	integer 	id of rock, autoincrementing, never reused
x	float	metres from bottom left
y	float	metres from bottom left
r	float	radius in metres
```
Ship Definition
```
tag	String	3 unicode chars. unique
x	float	metres from bottom left
y	float	metres from bottom left
r	float	radius in metres
t	float	angle theta clockwise from x-axis in radians (0.. 2π)
col	string	color - six char hex code (e.g. FFFFFF for white)
```

Bullet Definition
```
id	integer
x	float	metres from bottom left
y	float	metres from bottom left
```
eXplosion Definition		Duration and design is determined by GUI
```
x	float	metres from bottom left
y	float	metres from bottom left
```
Frame
```
n	integer	Frame can be ignored if out of order (e.g. ignore frame with smaller number than last)
        Might not be sequential though - just increasing!
```

## Build

To build a minified HTML and JS file in the `bin/` folder, run:

    npm run buildmin
