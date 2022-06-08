require 'rspec'
require 'lib/checkout'

describe Checkout do
    before do
        # Do nothing
        @promotional_rules = {
            total: {
                min_value: 61,
                discount: 0.1
            },
            products: [
                {
                    product_code: '001',
                    min_amount: 2,
                    discount_price: 8.5
                }
            ]
        }

        @invalid_code_message = 'Invalid Product! Ignored Code: 005'
    end
    
    after do
        # Do nothing
    end
    
    context 'checkout tests' do
        
        it 'first scenario' do
            co = Checkout.new(@promotional_rules)
            co.scan('001')
            co.scan('002')
            co.scan('003')
            price = co.total
            
            expect(price).to eq 66.78
        end
        
        it 'second scenario' do
            co1 = Checkout.new(@promotional_rules)
            co1.scan('001')
            co1.scan('003')
            co1.scan('001')
            price1 = co1.total
            
            expect(price1).to eq 36.95
        end
        
        it 'third scenario' do
            co2 = Checkout.new(@promotional_rules)
            co2.scan('001')
            co2.scan('002')
            co2.scan('001')
            co2.scan('003')
            price2 = co2.total
            
            expect(price2).to eq 73.76
        end
        
        it 'fourth scenario' do
            co2 = Checkout.new(@promotional_rules)
            co2.scan('001')
            co2.scan('002')
            co2.scan('001')
            _last_scan = co2.scan('005')

            expect(_last_scan).to eq @invalid_code_message
            price2 = co2.total
            
            expect(price2.round(2)).to eq 55.8
        end
    
    end
end
