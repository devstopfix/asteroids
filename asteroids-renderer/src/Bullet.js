import { fabric } from 'fabric'
import * as shapes from './shapes'
import * as utils from './utils'


export default class Bullet {
    constructor({id, x, y}, canvas) {
        var bullet = new fabric.Circle({
            radius: 1.2,
            left: x,
            top: y,
            fill: '#7DF9FF',
            stroke: '#FFFFFF',
            selectable: false,
            originX: 'left',
            originY: 'top',
            opacity: 0.9
        })

        canvas.add(bullet)
        this.canvas = canvas
        this.id = id
        this.bullet = bullet
    }

    update({x, y}, duration = 50) {
        let animation = {
            left: x,
            top: y,
            opacity: 0.1
        }

        let animationSettings = { duration: duration, easing: utils.easing.linear }

        if(Math.abs(this.bullet.left - x) > 100) {
            this.bullet.set('left', x)
        }
        if(Math.abs(this.bullet.top - y) > 100) {
            this.bullet.set('top', y)
        }
        this.bullet.animate(animation, animationSettings)
    }

    remove() {
        let self = this;
        setTimeout(function() {
            self.canvas.remove(self.bullet)
        }, 50)
    }
}