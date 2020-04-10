var mqtt = require('mqtt')
var client = mqtt.connect('mqtt://192.168.99.100:1883')

client.on('connect', () => {
    console.log('connected')
})