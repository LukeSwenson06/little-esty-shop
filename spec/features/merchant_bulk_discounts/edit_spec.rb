require 'rails_helper'

RSpec.describe "Bulk Discounts Edit Page", type: :feature do
  describe 'User Story 5 - Bulk Discounts Edit' do
    it "visits the merchants show page and has a link to let you edit the discount" do
      merchant = create_list(:merchant, 2)
      bulk_discount1 = merchant[0].bulk_discounts.create!(threshold: 10, discount_percentage: 20)

      visit merchant_bulk_discount_path(merchant[0], bulk_discount1)

      expect(page).to have_content("Threshold: #{bulk_discount1.threshold}")
      expect(page).to have_content("Discount Percentage: #{bulk_discount1.discount_percentage}")
      expect(page).to have_link("Edit Discount")
      click_link "Edit Discount"

      expect(current_path).to eq edit_merchant_bulk_discount_path(merchant[0], bulk_discount1)

      expect(page).to have_field(:threshold, with: 10)
      expect(page).to have_field(:discount_percentage, with: 20)
      expect(page).to have_button("Submit Discount")

      fill_in :threshold, with: 25
      fill_in :discount_percentage, with: 50
      click_on "Submit Discount"

      expect(current_path).to eq merchant_bulk_discount_path(merchant[0], bulk_discount1)

      expect(page).to have_content("Threshold: 25")
      expect(page).to have_content("Discount Percentage: 50")
      expect(page).to_not have_content("Threshold: 10")
      expect(page).to_not have_content("Discount Percentage: 20")

      end
    end

    it "return to edit page when form is not filled out correctly" do
      merchant = create_list(:merchant, 2)
      bulk_discount1 = merchant[0].bulk_discounts.create!(threshold: 10, discount_percentage: 20)

      visit edit_merchant_bulk_discount_path(merchant[0], bulk_discount1)

      fill_in :threshold, with: 50
      fill_in :discount_percentage, with: 105
      click_on "Submit Discount"

      expect(current_path).to eq edit_merchant_bulk_discount_path(merchant[0], bulk_discount1)

    end
  end
