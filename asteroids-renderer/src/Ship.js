import { fabric } from 'fabric'
import * as shapes from './shapes'
import * as utils from './utils'

export default class Ship {
    constructor({id, x, y, r, colour}, canvas) {
        this.ship = new fabric.Polygon(shapes.ship(r), {
            left: x,
            top: y,
            fill: 'transparent',
            stroke: fabric.Color.fromHex(colour).toRgb(),
            selectable: false,
            originX: 'center',
            originY: 'center'
        })

        this.text = new fabric.Text(id + '', {
            fontFamily: 'Source Code Pro,Courier New',
            left: x,
            top: y + r,
            fontSize: 16,
            fill: fabric.Color.fromHex(colour).toRgb(),
            originX: 'center',
            originY: 'top',
        })

        this.id = id
        this.canvas = canvas
        canvas.add(this.ship)
        canvas.add(this.text)
    }

    update({x, y, r,  angle}, duration) {
        this.ship.set('angle', angle)
        this.ship.set('left', x)
        this.ship.set('top', y)
        this.text.set('left', x)
        this.text.set('top', y + r)
        var animation = { angle: Math.abs(angle) }
        let animationSettings = { duration: duration, easing: utils.easing.linear }

        this.ship.animate(animation, animationSettings)
    }

    remove() {
        this.canvas.remove(this.ship)
        this.canvas.remove(this.text)
    }

}