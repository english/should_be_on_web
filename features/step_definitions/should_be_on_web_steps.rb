Given /^the following images$/ do |images_table|
  touch_files(images_table.raw.flatten)
end

Then /^the output should match the following:$/ do |table|
  actual = CSV.parse(all_output, col_sep: "\t")
  table.diff! actual
end

Given /^an xml file named "([^"]*)" with the following products:$/ do |filename, products_table|
  write_bsmart_catalog_xml filename, products_table.hashes
end

Given /^a csv file named "([^"]*)" with the following products:$/ do |filename, products_table|
  write_bsmart_csv filename, products_table.hashes
end
