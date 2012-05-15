require 'ostruct'

require_relative '../../lib/should_be_on_web/catalog'
require_relative '../../features/support/file_generators'

include FileGenerators

module ShouldBeOnWeb
  describe Catalog do
    subject { Catalog.new(products) }

    let(:products) {
      [
        OpenStruct.new(sku: '0101001', qty: '1'),
        OpenStruct.new(sku: '0101002', qty: '0')
      ]
    }

    its(:products) { should == products }

    describe "#from_xml" do
      it "parses xml and creates a catalog of products" do
        products = [
          { StockNum: '0101001', CurrStk: '1', Description: 'Ring' },
          { StockNum: '0101002', CurrStk: '0', Description: 'Watch' }
        ]
        xml = bsmart_catalog_xml(products)

        subject = Catalog.from_xml(xml)
        subject.products.first.sku.should == '0101001'
      end
    end

    describe "#web_candidates" do
      it "returns a list of skus that are in stock and not on web" do
        p1 = OpenStruct.new(sku: '01-01-001')
        p1.stub(in_stock?: true, image_exists?: true, on_web?: false)

        p2 = OpenStruct.new(sku: '0101002')
        p2.stub(in_stock?: true, image_exists?: true, on_web?: true)

        on_web    = ['01-01-002', '99-99-999']
        image_dir = '.'

        subject = Catalog.new([p1, p2])

        actual = subject.web_candidates(on_web, image_dir)
        actual.size.should == 1
        actual.first.sku.should == '01-01-001'
      end

      context "when all products in catalog are present in web_skus" do
        it "returns an empty array" do
          web_skus = %w{0101001 0101002}
          p1 = OpenStruct.new(sku: '01-01-001')
          p1.stub(in_stock?: true, image_exists?: true, on_web?: true)

          p2 = OpenStruct.new(sku: '01-01-002')
          p2.stub(in_stock?: true, image_exists?: true, on_web?: true)

          subject = Catalog.new([p1, p2])

          subject.web_candidates(web_skus).should be_empty
        end
      end
    end
  end
end
