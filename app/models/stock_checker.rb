module StockChecker
  def self.check_stock(product)
    shopify_inventory_data = ShopifyService.get_inventory_level(product['products_model'])

    if shopify_inventory_data[:status] == "200"
      shopify_inventory = shopify_inventory_data[:quantity].to_i

      if shopify_inventory > 0
        return 'In Stock'
      elsif shopify_inventory == 0 && product['in_stock_qty'].to_i > 0
        return '4 - 6 Weeks ETA'
      else
        return 'Out of Stock'
      end
    else
      return "API Error: #{shopify_inventory_data[:status]} - #{shopify_inventory_data[:error]}"
    end
  end
end
