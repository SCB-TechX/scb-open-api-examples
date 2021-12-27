const { MongoClient } = require('mongodb')

let instance
const client = new MongoClient(process.env.DB_CONNECTION_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
})
const connectToDatabase = async () => {
    const connection = await client.connect()
    instance = connection.db()
    console.log('Connected to the database')
}

module.exports = {
    connect: connectToDatabase,
    instance: () => { return instance }
}