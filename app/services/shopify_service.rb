require 'net/http'
require 'json'

class ShopifyService
  BASE_URL = 'https://eucaiot.myshopify.com/admin/api/2023-04'
  ACCESS_TOKEN = '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'

   def self.get_inventory_level(product_sku)
    uri = URI("#{BASE_URL}/inventory_levels.json?sku=#{product_sku}")
    req = Net::HTTP::Get.new(uri)
    req["X-Shopify-Access-Token"] = ACCESS_TOKEN

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(req)
    end

    if res.is_a?(Net::HTTPSuccess)
      data = JSON.parse(res.body)
      return { status: res.code, quantity: data["inventory_levels"].sum { |level| level["available"].to_i } }
    else
      return { status: res.code, error: res.message }
    end
  end

  def self.get_inventory_level(inventory_item_id)
    uri = URI("#{BASE_URL}/inventory_levels.json?inventory_item_id=#{inventory_item_id}")
    req = Net::HTTP::Get.new(uri)
    req["X-Shopify-Access-Token"] = ACCESS_TOKEN

    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') {|http|
      http.request(req)
    }

    if res.is_a?(Net::HTTPSuccess)
      data = JSON.parse(res.body)
      return {status: res.code, quantity: data["inventory_quantity"]}
    else
      # handle error - you might want to log this somewhere
      return {status: res.code, error: res.message}
    end
  end
end
