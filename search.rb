require_relative './search/core'

search_core = Search::Core.new('files/products.json')
# search_core = Search::Core.new('files/products_big.json')
ids = search_core.call(ARGV.join(' '))
search_core.print_response(ids)
