require 'json'

module Search
  class Core
    def initialize(file_name)
      @file_name = file_name
    end

    def create_index
      # don't allow index to be created twice
      return false unless @product_ids_by_name.nil?

      @product_ids_by_name = {}
      @products_json = file_to_json(@file_name)
      tokenize_and_create_index
    end

    def search_by_name(search_parameters)
      found_ids = search(search_parameters)
      print_response(found_ids)
    end

    private

    def file_to_json(file_name)
      JSON.parse(File.read(file_name))
    rescue Errno::ENOENT
      puts 'Error while reading the products file.'
      exit(1)
    end

    def tokenize_and_create_index
      @products_json.map do |product_json|
        tokenize_product(product_json)
      end
    end

    def tokenize_product(product_json)
      name_tokens = product_json['name'].split(' ').map(&:downcase)
      create_product_index(name_tokens, product_json['id'])
    end

    def create_product_index(tokens, product_id)
      tokens.each do |token|
        @product_ids_by_name[token] = [] if @product_ids_by_name[token].nil?
        @product_ids_by_name[token] << product_id
      end
    end

    def search(search_parameters)
      names = search_parameters.split(' ').map(&:downcase)
      # return [] if no product was found for that word
      return [] if @product_ids_by_name[names.first].nil?
      # return the product ids for that word if the index exists
      return @product_ids_by_name[names.first] if names.size == 1

      found_product_ids = []
      names.each do |name|
        # return [] if no product was found for one of the search parameters
        return [] if @product_ids_by_name[name].nil?

        # initialize found_product_ids
        found_product_ids = @product_ids_by_name[name] and next if found_product_ids.empty?

        found_product_ids &= @product_ids_by_name[name]
      end
      found_product_ids
    end

    def print_response(ids)
      if ids.nil? || ids.empty?
        puts 'No products found'
        return
      end

      ids.each_with_index do |id, index|
        print @products_json[id]['name']
        print ', ' unless index == ids.size - 1
      end
      puts
    end
  end
end
