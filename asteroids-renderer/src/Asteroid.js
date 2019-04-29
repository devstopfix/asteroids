import { fabric } from 'fabric'
import * as shapes from './shapes'
import * as utils from './utils'

export default class Asteroid {
    constructor({id, x, y, r},  canvas) {

        this.roid = new fabric.Polygon(shapes.asteroid(r), {
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

    update({x, y}, duration) {
        let animation = {
            left: x,
            top: y,
            angle: '+=' + (duration / 5)
        }

        //let textAnimation = { left: this.roid.left - 15, top: this.roid.top - 25 }
        let animationSettings = { duration: duration, easing: utils.easing.linear }

        if(Math.abs(this.roid.left - x) > 100) {
            this.roid.set('left', x)
            //this.text.set('left', x)
        }
        if(Math.abs(this.top - y) > 100) {
            this.roid.set('top', y)
            //this.text.set('top', y)
        }
        this.roid.animate(animation, animationSettings)
    }

    remove() {
        this.canvas.remove(this.roid)
        //this.canvas.remove(this.text)
    }
}