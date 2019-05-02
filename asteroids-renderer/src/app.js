// import fakeServer from './fakeServer'
import Server from './Server'
import Renderer from './Renderer'
import transformFrame from './transformFrame'

const serverDimensions = {WIDTH: 4000, HEIGHT: 2250}
const clientDimensions = {WIDTH: 1920, HEIGHT: 1080}


const renderer = new Renderer({...clientDimensions, FRAME_RATE: 24})
//const server = new fakeServer(serverDimensions)
const server = new Server()

server.on('frame', (frame) => renderer.update(transformFrame(frame, transformRatio, serverDimensions)))

const transformRatio = {
    WIDTH: serverDimensions.WIDTH / clientDimensions.WIDTH,
    HEIGHT: serverDimensions.HEIGHT / clientDimensions.HEIGHT
}

// window.onblur = () => {  renderer.pause(); }
// window.onfocus = () => { renderer.resume(); }

function graphicsURL(window_location_href) {
    var url = new URL(window_location_href);

    switch (url.protocol) {
        case 'http:':
            url.protocol = 'ws';
            break;
        case 'https:':
            url.protocol = 'wss';
            break;
    }

    /* If running in development, override with default ports. TODO config? */
    switch (url.port) {
        case '3030':
            url.port = 8065;
    }

    /* If in development, hardcode to game zero. TODO config? */
    if (url.pathname.match(/\/\d+\/game$/)) {
        url.pathname = url.pathname.replace(/game$/, 'graphics');
    } else {
        url.pathname = "/0/graphics";
    }

    return url;
}

renderer.start()
server.connect(graphicsURL(window.location.href))
