class ProductsController < ApplicationController
  require 'faraday'
  require 'json'

def index
offset = params[:offset].to_i + 1 # Increment the offset by 1

  conn = Faraday.new('https://www.seeedstudio.com/rest/V1/product/multiple', headers: {'Authorization': 'Bearer 2fcdf4zk3q50g0m0p0hsxlc5tfz3g4we', 'Content-Type': 'application/form-data'})

  response = conn.post do |req|
    req.params['appid'] = 'C000009484'
    req.params['limit'] = 50
    req.params['offset'] = offset
    req.params['sort'] = 'no'
  end

  @status = response.status

  begin
    products_data = JSON.parse(response.body)
    @products = products_data['data']

    # Filter products based on search query
    search_query = params[:search]
    if search_query.present?
      @products = @products.select do |product|
        product['products_name'].to_s.downcase.include?(search_query.downcase) ||
          product['products_model'].to_s.downcase.include?(search_query.downcase) ||
          # Add more fields to include in the search if necessary
          # ...
          product['products_description'].to_s.downcase.include?(search_query.downcase)
      end
    end
  rescue JSON::ParserError => e
    puts "Failed to parse JSON: #{e.message}"
    @products = []
  end

  @offset = offset

  unless @products.is_a?(Array)
    puts "'data' not found in the response body or it's not an Array"
    @products = []
  end
end

  def show
    conn = Faraday.new("https://www.seeedstudio.com/rest/V1/product/multiple/skus", headers: {'Authorization': 'Bearer 2fcdf4zk3q50g0m0p0hsxlc5tfz3g4we', 'Content-Type': 'application/form-data'})
    
    response = conn.post do |req|
      req.params['appid'] = 'C000009484'
      req.params['skus'] = params[:id]
    end

    @product = JSON.parse(response.body)['data'].first
    @status = response.status
  end
end