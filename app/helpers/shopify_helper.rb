module ShopifyHelper
  def fetch_shopify_inventory(product)
    variant_id = product.shopify_variant_id
    shopify_product = ShopifyAPI::Variant.find(variant_id, params: { fields: 'inventory_quantity' })
    shopify_product.inventory_quantity
  end
end
