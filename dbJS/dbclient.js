var mqtt = require('mqtt')
var mongo = require('mongodb')
var client = mqtt.connect('mqtt://192.168.99.100:1883')
var mongoClient = mongo.MongoClient;
var url = 'mongodb://192.168.99.100:27017/'

client.on('connect', () => {
    console.log('connected')
    client.subscribe('#', () => {
        mongoClient.connect(url, (err, db) => {
            if (err) throw err
            console.log('dbcreated')
            var dbo = db.db('testJS')
            dbo.createCollection("history", (err, res) => {
                if (err) throw err
                console.log("Collectin created")
                db.close()
            })
        })
    })

})

client.on('message', (topic, payload) => {
    var data = payload.toString()
    mongoClient.connect(url, (err, db) => {
        if (err) throw err
        var dbo = db.db("testJS")
        dbo.collection("history")
            .insertOne({
                "topic": topic,
                "body": data
            }, (err, res) => {
                if (err) throw err
                console.log("inserted")
                db.close()
            })
    })
})

function getInserts(topic) {
    var result;
    mongoClient.connect(url, (err, db) => {
        if (err) throw err
        var dbo = db.db('testJS');
        result = dbo.collection("history")
            .find({}, {
                projection: {
                    _id: 0,
                    topic: 1,
                    title: 1
                }
            }).toArray((err, data) => {
                result = data;
                console.log(res)
                db.close();
            })
        return result;
    })
}

module.exports.getInserts = getInserts;