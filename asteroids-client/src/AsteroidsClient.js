export default class AsteroidsClient {
    
    constructor() {
        this.subscribers = {};
    }
    
    connect(url = 'ws://localhost:8065/websocket') {        
        const onOpen = (event) => console.log('WebSocket: Open')
        const onClose = (event) => console.log('WebSocket: Closed') 
        
        this.websocket = new WebSocket(url)
        this.websocket.onopen = (event) => { onOpen(event) }
        this.websocket.onclose = (event) => { onClose(event) }
        this.websocket.onmessage = (event) => { this.onMessage(event) }
    }
    
    onMessage(event) {
        //console.log('WebSocket: Message', event.data)
        let message = JSON.parse(event.data);
        message.s = message.s || []
        message.x = message.x || []
        
        if(this.subscribers['frame']) {
            this.subscribers.frame.forEach(callback => callback(message))
        }
    }
    
    on(eventName, callback) {
        this.subscribers[eventName] = this.subscribers[event] || []
        this.subscribers[eventName].push(callback);
    }

    send(response) {
        this.websocket.send(JSON.stringify(response))
    }
    
    disconnect() {
        this.websocket.close()
    }
}