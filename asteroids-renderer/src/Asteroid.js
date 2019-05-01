import { fabric } from 'fabric'
import * as shapes from './shapes'
import * as utils from './utils'

export default class Asteroid {
    constructor({ id, x, y, r }, canvas) {

        this.roid = new fabric.Polygon(shapes.asteroid(Math.trunc(x), r), {
            left: x,
            top: y,
            fill: 'black',
            stroke: 'white',
            selectable: false,
            originX: 'center',
            originY: 'center'
        })

        this.id = id
        this.canvas = canvas
        this.canvas.add(this.roid)
    }

    update({ x, y }, duration) {
        let animation = {
            left: x,
            top: y,
            angle: '+=' + (duration / 20)
        }

        let animationSettings = { duration: duration, easing: utils.easing.linear }

        if (Math.abs(this.roid.left - x) > 10) {
            this.roid.set('left', x)
        }
        if (Math.abs(this.top - y) > 10) {
            this.roid.set('top', y)
        }
        this.roid.animate(animation, animationSettings)
    }

    remove() {
        this.canvas.remove(this.roid)
    }
}