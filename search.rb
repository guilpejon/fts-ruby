require_relative './search/core'

search_core = Search::Core.new('files/products.json')
# search_core = Search::Core.new('files/products_big.json')
search_core.create_index
search_core.search_by_name(ARGV.join(' '))
