require 'scraper/base_drugs'
require 'scraper/patents'

# AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')

app = DrugApplication.find_by_application_number '050795'

products = app.app_products
products.each do |product|
  product.patents.each{|patent| patent.really_destroy!}
  product.exclusivities.destroy_all
end

products.destroy_all


attr = [
    {strength: 'EQ 75MG BASE', dosage: 'TABLET, DELAYED RELEASE;ORAL', market_status: 'Prescription', product_number: '001', patent_status: true},
    {strength: 'EQ 100MG BASE', dosage: 'TABLET, DELAYED RELEASE;ORAL', market_status: 'Prescription', product_number: '002', patent_status: true},
    {strength: 'EQ 150MG BASE', dosage: 'TABLET, DELAYED RELEASE;ORAL', market_status: 'Prescription', product_number: '003', patent_status: true},
    {strength: 'EQ 80MG BASE', dosage: 'TABLET, DELAYED RELEASE;ORAL', market_status: 'Prescription', product_number: '004', patent_status: true},
    {strength: 'EQ 200MG BASE', dosage: 'TABLET, DELAYED RELEASE;ORAL', market_status: 'Prescription', product_number: '005', patent_status: true},
    {strength: 'EQ 50MG BASE', dosage: 'TABLET, DELAYED RELEASE;ORAL', market_status: 'Prescription', product_number: '006', patent_status: true},
    {strength: 'EQ 60MG BASE', dosage: 'TABLET, DELAYED RELEASE;ORAL', market_status: 'Prescription', product_number: '007', patent_status: true},
    {strength: 'EQ 120MG BASE', dosage: 'TABLET, DELAYED RELEASE;ORAL', market_status: 'Prescription', product_number: '008', patent_status: true}
]

app.app_products.create(attr)

AppProduct.where(drug_application_id: app.id).each do |product|
  Scraper::Patents.new.save_patent_exclusivity_for(product.drug_application.application_number, product)
end
