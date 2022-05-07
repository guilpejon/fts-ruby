require_relative '../search/core'

# rubocop:disable Metrics/BlockLength
describe Search::Core do
  before(:all) do
    @search_core = described_class.new('spec/files/test_products.json')
  end

  describe '#create_index' do
    it 'expects to not raise an error' do
      expect do
        @search_core.create_index
      end.to_not raise_error
    end

    context 'when creating index for invalid file' do
      it 'expects to exit' do
        search_core = described_class.new('')
        expect do
          search_core.create_index
        end.to output("Error while reading the products file.\n").to_stdout.and raise_error(SystemExit)
      end
    end

    context 'when creating an index for the second time' do
      it 'expects to return false' do
        @search_core.create_index
        expect(@search_core.create_index).to be(false)
      end
    end
  end

  describe '#search' do
    before(:all) do
      @search_core.create_index
    end

    context 'when searching for one word' do
      it 'expects to output a message when no products are found' do
        expect do
          @search_core.search_by_name('NonExistingName')
        end.to output("No products found\n").to_stdout
      end

      it 'expects to output one product name when there is one match' do
        expect do
          @search_core.search_by_name('Granite')
        end.to output("Enormous Granite Bench\n").to_stdout
      end
    end

    context 'when searching for two words' do
      it 'expects to output a message when no products are found for one of the search parameters' do
        expect do
          @search_core.search_by_name('Durable NonExistingName')
        end.to output("No products found\n").to_stdout
      end

      it 'expects to output two product names for these words' do
        expect do
          @search_core.search_by_name('Durable')
        end.to output("Durable Leather Car, Durable Leather Lamp\n").to_stdout
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
