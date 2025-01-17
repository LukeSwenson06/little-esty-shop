class Invoice < ApplicationRecord
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants
  belongs_to :customer

  enum status:["in progress", "completed", "cancelled"]

  def total_revenue
    invoice_items.sum('quantity * unit_price')

  end

  def self.not_shipped
    all
    .joins(:invoice_items)
    .where.not("invoice_items.status = ?", 2)
    .order(created_at: :desc)
  end

  def formatted_date
    created_at.strftime("%A, %B %d, %Y")
  end

  def all_invoice_revenue
    invoice_items.each.sum do |invoice_item|
      invoice_item.discounted_revenue
    end
  end
end
