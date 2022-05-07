require 'json'

module Search
  class Core
    def initialize(file_name)
      @file = File.read(file_name)
      @product_ids_by_name = {}
      @products_json = JSON.parse(file)
    end

    attr_reader :file
    attr_accessor :product_ids_by_name, :products_json

    def call(search_parameters)
      tokenize_and_create_index(products_json)
      search(search_parameters)
    end

    def print_response(ids)
      if ids.nil? || ids.empty?
        puts 'No products found'
        return
      end

      ids.each_with_index do |id, index|
        print products_json[id]['name']
        print ', ' unless index == ids.size - 1
      end
      puts
    end

    private

    def tokenize_and_create_index(products_json)
      products_json.map do |product_json|
        tokenize_product(product_json)
      end
    end

    def tokenize_product(product_json)
      name_tokens = product_json['name'].split(' ').map(&:downcase)
      create_product_index(name_tokens, product_json['id'])
    end

    def create_product_index(tokens, product_id)
      tokens.each do |token|
        product_ids_by_name[token] = [] if product_ids_by_name[token].nil?
        product_ids_by_name[token] << product_id
      end
    end

    def search(search_parameters)
      names = search_parameters.split(' ').map(&:downcase)
      # return [] if no product was found for that word
      return [] if product_ids_by_name[names.first].nil?
      # return the product ids for that word if the index exists
      return product_ids_by_name[names.first] if names.size == 1

      ids_list = []
      names.each do |name|
        # return [] if no product was found for one of the search parameters
        return [] if product_ids_by_name[name].nil?

        # initialize ids_list
        if ids_list.empty?
          ids_list = product_ids_by_name[name]
          next
        end

        ids_list &= product_ids_by_name[name]
      end
      ids_list
    end
  end
end
