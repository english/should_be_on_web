require 'nokogiri'

module ShouldBeOnWeb
  class Catalog
    attr_reader :products

    def self.from_xml(xml)
      doc = Nokogiri::XML(xml)
      products = doc.css('product').map { |product_node|
        sku  = product_node.at_css('StockNum').content
        qty  = product_node.at_css('CurrStk').content
        name = product_node.at_css('Description').content

        Product.new(sku: sku, qty: qty, name: name)
      }

      new(products)
    end

    def initialize(products=[])
      @products = products
    end

    def web_candidates(on_web, image_dir='.', ignore_images=false)
      if ignore_images
        products.select { |product|
          product.in_stock? and not product.on_web?(on_web)
        }
      else
        products.select { |product|
          product.in_stock? and product.image_exists?(image_dir) and not product.on_web?(on_web)
        }
      end
    end
  end

  class Product
    attr_accessor :sku, :qty, :name

    def initialize(attrs={})
      attrs.each { |k, v| self.send("#{k}=", v) }
    end

    def in_stock?
      qty.to_i > 0
    end

    def department
      sku[0..1]
    end

    def sub_department
      sku[3..4]
    end

    def image
      File.join(department, sub_department, "#{sku}.jpg")
    end

    def image_exists?(image_dir)
      file = File.expand_path(File.join(image_dir, image))

      File.exists?(file)
    end

    def on_web?(skus)
      skus.include? sku.gsub('-', '')
    end
  end
end
