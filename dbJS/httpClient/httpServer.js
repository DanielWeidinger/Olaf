var http = require('http')
var dbFunc = require('../dbclient')
var mongo = require('mongodb')
var mongoClient = mongo.MongoClient;
var url = 'mongodb://192.168.99.100:27017/'

console.log("josoosodjdsf")

var httpServer = http.createServer((req, res) => {
    var data;
    if (req.url === '/') {
        res.end("Nothing much!")
    } else {
        mongoClient.connect(url, (err, db) => {
            var query;
            if (req.url === "/all") {
                query = {
                    topic: /.*/
                }
                console.log("all_________________")
            } else {
                var re = new RegExp(".*" + req.url + ".*/", 'i')

                query = {
                    topic: re
                }
            }
            var dbo = db.db('testJS')
            data = dbo.collection('history').find(query, {
                    projection: {
                        _id: 0,
                        topic: 1,
                        title: 1
                    }
                })
                .toArray()
            data.then(v => {
                res.end(JSON.stringify(v))
            })

        })
    }
});


httpServer.on('connection', socket => {
    console.log("Connected http")
})

httpServer.listen(9090);
console.log("listen http")

var getEntries = async (topic) => {
    var data;
    mongoClient.connect(url, (err, db) => {
        var dbo = db.db('testJS')
        data = dbo.collection('history').find({}, {
                projection: {
                    _id: 0,
                    topic: 1,
                    title: 1
                }
            })
            .toArray()
        console.log(data)
        return data;
    })
}