const NodeCache = require("node-cache");
const cache = new NodeCache();

const scbApi = require('../apis/scb-api')



module.exports.getDeeplink = () => {
    scbApi.tokenV1()
}