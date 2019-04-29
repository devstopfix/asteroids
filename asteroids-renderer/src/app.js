import fakeServer from './fakeServer'
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

window.onblur = () => {
    console.log('window.onblur: pausing renderer')
    renderer.pause();
}
window.onfocus = () => {
    console.log('window.onfocus: resuming renderer')
    renderer.resume();
}

renderer.start()
server.connect()