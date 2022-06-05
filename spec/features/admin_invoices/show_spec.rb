require 'rails_helper'

RSpec.describe 'Admin Invoice Show Page', type: :feature do
  let!(:merchant1) { create(:merchant) }

  let!(:item1) { create(:item, merchant: merchant1) }
  let!(:item2) { create(:item, merchant: merchant1) }

  let!(:customer1) { create(:customer) }
  let!(:customer2) { create(:customer) }

  let!(:invoice1) { create(:invoice, customer: customer1) }
  let!(:invoice2) { create(:invoice, customer: customer2) }

  let!(:transaction1) { create(:transaction, invoice: invoice1, result: 1) }
  let!(:transaction2) { create(:transaction, invoice: invoice2, result: 1) }

  let!(:invoice_item1) { create(:invoice_item, item: item1, invoice: invoice1, unit_price: 3011) }
  let!(:invoice_item2) { create(:invoice_item, item: item2, invoice: invoice1, unit_price: 2524) }
  it 'lists invoice attributes' do
    visit "/admin/invoices/#{invoice1.id}"
    expect(page).to have_content("Status: #{invoice1.status}")
    expect(page).to have_content("Invoice ##{invoice1.id}")
    expect(page).to have_content("Created on: #{invoice1.created_at.strftime('%A, %B %d, %Y')}")
    expect(page).to have_content("#{invoice1.customer.first_name} #{invoice1.customer.last_name}")
  end

  it 'lists items on the invoice' do
    visit "/admin/invoices/#{invoice1.id}"
    within '#itemtable' do
      expect(page).to have_content('Item Name')
      expect(page).to have_content('Unit Price')
      expect(page).to have_content('Status')
      expect(page).to have_content('Quantity')
    end

    within "#invoice-item-#{invoice_item1.id}" do
      expect(page).to have_text(item1.name.to_s)
      expect(page).to have_text('$30.11')
      expect(page).to have_text(invoice_item1.quantity.to_s)
      expect(page).to have_text(invoice_item1.status.to_s)
    end
  end
end