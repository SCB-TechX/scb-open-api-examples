const paymentUtil = require('../payment-utility')

test('adds 1 + 2 to equal 3', () => {
    expect(paymentUtil.genarateTransactionReference())
        .toHaveLength(10)
        .toMatch('[A-Z,0-9]+')
})