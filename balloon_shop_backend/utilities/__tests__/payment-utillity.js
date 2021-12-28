const paymentUtil = require('../payment-utility')

jest.mock('mongodb')

describe('Generate Transaction Reference', () => {

    let lastResult = ""

    test('Generate Transaction Reference #1', () => {
        let result = paymentUtil.genarateTransactionReference()
        expect(result).toMatch(/^[A-Z,0-9]{10}$/g)
        expect(result).not.toEqual(lastResult)
        lastResult = result
    })

    test('Generate Transaction Reference #2', () => {
        let result = paymentUtil.genarateTransactionReference()
        expect(result).toMatch(/^[A-Z,0-9]{10}$/g)
        expect(result).not.toEqual(lastResult)
        lastResult = result
    })

    test('Generate Transaction Reference #3', () => {
        let result = paymentUtil.genarateTransactionReference()
        expect(result).toMatch(/^[A-Z,0-9]{10}$/g)
        expect(result).not.toEqual(lastResult)
        lastResult = result
    })

})
