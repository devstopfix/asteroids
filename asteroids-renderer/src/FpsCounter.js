import { fabric } from 'fabric'

export default class FpsCounter extends fabric.Text {
    
    constructor(canvas) {
        super('FPS: 0', {
            fontFamily: 'Arial',
            fontSize: 12,
            fill: 'black',
            fontWeight: 'bold',
            left: 5,
            top: 5,
            selectable: false
        })
        
        canvas.add(this)
        
        this.frames = 0
        this.startTime = Date.now()
        this.prevTime = this.startTime
    }
    
    update() {
        var time = Date.now()
        this.frames++

        if ( time > this.prevTime + 1000 ) {
            let fps = Math.round( ( this.frames * 1000 ) / ( time - this.prevTime ) )
            this.prevTime = time
            this.frames = 0

            this.setText("FPS: " + fps)
        }
    }
}