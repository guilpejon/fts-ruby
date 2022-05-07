require_relative '../search/core.rb'

describe Search::Core do
  describe '#call' do
    let(:search) { described_class.new('spec/test_products.json') }

    context 'when searching for one word' do
      it 'expects to return one product id when one match is found' do
        found_ids = search.call('Lightweight')
        expect(found_ids).to match_array([0])
      end

      it 'expects to return an empty list when there was no match' do
        found_ids = search.call('NonExistingName')
        expect(found_ids).to match_array([])
      end
    end

    context 'when searching for two words' do
      it 'expects to return two product ids with those two words' do
        found_ids = search.call('Durable Leather')
        expect(found_ids).to match_array([1, 2])
      end

      it 'expects to return an empty list when one of the words had no match' do
        found_ids = search.call('Durable NonExistingName')
        expect(found_ids).to match_array([])
      end
    end

    context 'when searching for an exact product name' do
      it 'expects to return the product id' do
        found_ids = search.call('Enormous Granite Bench')
        expect(found_ids).to match_array([3])
      end
    end

  end

  describe '#print_response' do
    let(:search) { described_class.new('spec/test_products.json') }

    context 'when searching for one word' do
      it 'expects to output a message when no products are found' do
        found_ids = search.call('NonExistingName')
        expect { search.print_response(found_ids) }.to output("No products found\n").to_stdout
      end

      it 'expects to output one product name when there is one match' do
        found_ids = search.call('Granite')
        expect { search.print_response(found_ids) }.to output("Enormous Granite Bench\n").to_stdout
      end
    end

    context 'when searching for two words' do
      it 'expects to output a message when no products are found for one of the search parameters' do
        found_ids = search.call('Durable NonExistingName')
        expect { search.print_response(found_ids) }.to output("No products found\n").to_stdout
      end

      it 'expects to output two product names for these words' do
        found_ids = search.call('Durable')
        expect { search.print_response(found_ids) }.to output("Durable Leather Car, Durable Leather Lamp\n").to_stdout
      end
    end
  end
end
