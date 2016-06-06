import fakeServer from './fakeServer'
import Server from './Server'
import Renderer from './Renderer'
import transformFrame from './transformFrame'

// console.log('fabric', fabric)
// console.log('window.fabric', window.fabric);

const serverDimensions = {WIDTH: 4000, HEIGHT: 2250}
const clientDimensions = {WIDTH: 1600, HEIGHT: 1050}


const renderer = new Renderer({...clientDimensions, FRAME_RATE: 24})
//const server = new fakeServer(serverDimensions)
const server = new Server()

server.on('frame', (frame) => renderer.update(transformFrame(frame, transformRatio, serverDimensions)))

const transformRatio = {
    WIDTH: serverDimensions.WIDTH / clientDimensions.WIDTH,
    HEIGHT: serverDimensions.HEIGHT / clientDimensions.HEIGHT
}

renderer.start()
server.connect()
