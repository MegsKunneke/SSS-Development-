class ShopifyAPI
  include HTTParty

  base_uri 'https://eucaiot.myshopify.com/admin/api/2023-04'

  def initialize
    @options = { headers: { 'X-Shopify-Access-Token' => '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' } }
  end

  def get_product(sku)
    self.class.get("/products.json?sku=#{sku}", @options)
  end

  def get_inventory_level(product_id)
    self.class.get("/inventory_levels.json?inventory_item_id=#{product_id}", @options)
  end
end
