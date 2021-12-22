
const PRODUCTS_COLLECTION = 'products'
const _db = require('../data/db')

module.exports.getProducts = async () => {
    try {
        const products = await _db.instance()
            .collection(PRODUCTS_COLLECTION)
            .find({})
            .sort({ price: 1 })
            .toArray()
        products.forEach((product) => {
            product.price = parseFloat(product.price).toFixed(2)
        })
        return products
    } catch (err) {
        throw err
    }
}