# Asteroids Graphics for Elixoids


## Development

Start a reactor that serves your files, and a process that compiles the code when the sources change:

    elm reactor && find src | entr -r elm make src/main.elm --output public/elixoids.dev.js

Open the browser:

    http://localhost:8000/public/dev.html



## Credits

[JSON parser routine](https://gist.github.com/simonykq/f4623eb5e87ff2834afba1f156e57614) by [Simon Yu](https://github.com/simonykq)
