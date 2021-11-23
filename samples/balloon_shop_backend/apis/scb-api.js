const { v4: uuidv4 } = require('uuid');
const axios = require('axios');


module.exports.tokenV1 = async () => {
    try {
        const uuid = uuidv4()
        const response = await axios.post(
            process.env.SCB_HOST + '/v1/oauth/token',
            {
                applicationKey: process.env.SCB_API_KEY,
                applicationSecret: process.env.SCB_API_SECRET
            },
            {
                headers: {
                    'Content-Type': 'application/json',
                    'Accept-Language': 'EN',
                    'resourceOwnerId': 'test',
                    'requestUId': uuid
                }
            })
        console.log(response.data)
    } catch (err) {
        console.log(err.response.data)
    }
}