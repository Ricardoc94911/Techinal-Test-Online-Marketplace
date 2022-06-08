class Checkout
    
    PRODUCT_CATALOG = [{
                           code: '001',
                           name: 'Lavender heart',
                           price: 9.25
                       }, {
                           code: '002',
                           name: 'Personalised cufflinks',
                           price: 45.0
                       }, {
                           code: '003',
                           name: 'Kids T-shirt',
                           price: 19.95
                       }]
    
    def initialize(promotional_rules = {})
        
        @promotional_rules = promotional_rules
        @basket = []
    
    end
    
    def total
        
        _total = 0
        
        @basket.each do |item|
            
            _price = 0
            _product_promotion = (@promotional_rules[:products] || []).find { |promotion| promotion[:product_code] == item[:code] }
            
            if !_product_promotion || _product_promotion[:min_amount] > item[:quantity]
                _total += _price = (item[:price] * item[:quantity])
                next
            end
            
            _total += _price = (_product_promotion[:discount_price] * item[:quantity])
        end
        
        if (@promotional_rules.dig(:total,:min_value) || Float::INFINITY) <= _total
            
            _total *= (1 - (@promotional_rules[:total][:discount] || 0))
        
        end
        
        return _total
    
    end
    
    def scan(item_code)
        
        #assuming item_code is the product code of one of the elements present in PRODUCT_CATALOG
        
        _b_item_index = @basket.index { |b_item| b_item[:code] == item_code }
        
        if _b_item_index == nil
            _product_to_add = PRODUCT_CATALOG.find { |c_item| c_item[:code] == item_code }.clone
            
            if !_product_to_add
                
                puts _message = ('Invalid Product! Ignored Code: ' + item_code.to_s)
                return _message
            end
            
            @basket << _product_to_add
            _b_item_index = @basket.size - 1
        end
        
        @basket[_b_item_index][:quantity] = @basket[_b_item_index][:quantity] ? @basket[_b_item_index][:quantity] + 1 : 1
    
    end
    
    def log_basket
        
        item_arr = []
        
        @basket.each do |item|
            
            for i in 1..item[:quantity]
                
                item_arr << item[:code]
                
            end
            
        end
        
        return item_arr.join(',')
    
    end

end