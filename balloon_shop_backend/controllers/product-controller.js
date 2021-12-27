const { StatusCodes } = require("http-status-codes")
const productService = require('../services/product-service')

module.exports.getProducts = async (req, res) => {
    try {
        const products = await productService.getProducts()
        res.status(StatusCodes.OK).send(products).end()
    } catch (err) {
        throw err
    }
}