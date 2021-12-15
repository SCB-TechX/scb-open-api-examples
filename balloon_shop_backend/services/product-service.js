
const PRODUCTS_COLLECTION = 'products'
const _db = require('../data/db')

module.exports.createProduct = async (body) => {
    try {
        const { price, productName, imageUrl } = body
        const product = await _db.instance()
            .collection(PRODUCTS_COLLECTION)
            .insertOne({
                price: price,
                productName: productName,
                imageUrl: imageUrl,
            })
        return product.value;
    } catch (err) {
        throw err;
    }
}

module.exports.deleteProduct = (body) => {

}

module.exports.getProducts = async () => {
    try {
        const products = await _db.instance()
            .collection(PRODUCTS_COLLECTION)
            .find({})
            .sort({ price: 1 })
            .toArray();
        products.forEach((product) => {
            product.price = parseFloat(product.price).toFixed(2);
        })
        return products;
    } catch (err) {
        throw err;
    }
}