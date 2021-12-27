const RandomString = require("randomstring")
const productService = require('../services/product-service')

/**
 * @return {String} Random string contains A-Z,0-1 with length of 10
 */
module.exports.genarateTransactionReference = () => {
    return RandomString.generate({
        length: 10,
        charset: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    })
}

/**
 * 
 * @param {Array} orderedProducts 
 * @returns {Double} Total price
 */
module.exports.calculateTotalPrice = async (orderedProducts) => {
    let totalPrice = 0.00
    const products = await productService.getProducts()
    orderedProducts.forEach(orderedProduct => {
        const product = products.find(product => product._id.toString() === orderedProduct._id)
        if (product) {
            totalPrice = totalPrice + (product.price * orderedProduct.amount)
        } else {
            console.log('product', product)
            throw {}
        }
    })
    console.log('totalPrice', totalPrice)
    return totalPrice
}