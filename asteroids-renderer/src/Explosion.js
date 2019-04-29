import { fabric } from 'fabric'
import * as shapes from './shapes'
import * as utils from './utils'

const colors = ['#ffffff', '#ffffff', '#F7DC6F', '#FF5733', '#AED6F1'];

export default function Explosion({ x, y }, canvas) {
  var color = colors[Math.trunc(x) % colors.length];
  let lines = [];
  for (var i = 0; i < 16; i++) {
    var angle = 6.28 * Math.random();
    var line = new fabric.Circle({
      radius: 0.5,
      left: x,
      top: y,
      fill: color,
      stroke: color,
      selectable: false,
      originX: 'left',
      originY: 'top',
      angle: angle,
      dx: Math.cos(angle) + Math.random() - 0.5,
      dy: Math.sin(angle) + Math.random() - 0.5,
      opacity: 0.9
    })
    canvas.add(line)
    lines.push(line)
  }

  lines.forEach((line) => {
    line.animate({
      left: line.get('left') + 80 * line.dx,
      top: line.get('top') + 80 * line.dy,
      opacity: 0.6,
      radius: 2.0
    }, {
        duration: 400,
        easing: utils.easing.linear,
        onComplete: () => canvas.remove(line)
      })
  })
}