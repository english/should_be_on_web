require 'nokogiri'
require 'csv'

module FileGenerators
  def write_bsmart_catalog_xml filename, products
    xml = bsmart_catalog_xml products
    in_current_dir do
      File.open(filename, 'wb') {|file| file.write xml }
    end
  end

  def bsmart_catalog_xml products
    Nokogiri::XML::Builder.new { |xml|
      xml.catalog {
        xml.supplier {
          products.each do |product|
            xml.product {
              product.each {|key, value| xml.send key.to_sym, value }
            }
          end
        }
      }
    }.to_xml
  end

  def write_bsmart_csv filename, products
    in_current_dir do
      CSV.open filename, 'wb' do |csv|
        csv << ['sku', 'name']
        products.each do |product|
          csv << [ product[:sku], product[:name] ]
        end
      end
    end
  end

  def touch_files filenames
    in_current_dir do
      filenames.each do |filename|
        FileUtils.mkdir_p File.dirname filename
      end
      FileUtils.touch filenames
    end
  end
end
