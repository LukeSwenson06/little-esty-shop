class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates_presence_of :name
  validates_presence_of :description
  validates_numericality_of :unit_price

  enum status:["Disabled", "Enabled"]

  def self.enabled
    where(status: 1)
  end

  def self.disabled
    where(status: 0)
  end

  def self.most_popular
    joins(invoices: :transactions)
    .where("transactions.result = ?", 0)
    .select("items.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .group(:id)
    .order(revenue: :desc)
    .limit(5)
  end

  def best_day
    invoices
    .joins(:transactions)
    .select("invoices.created_at")
    .where("transactions.result = ?", 0)
    .order(Arel.sql("sum(invoice_items.quantity) desc, date_trunc('day', invoices.created_at) desc"))
    .group("invoices.created_at")
    .pluck("invoices.created_at")
    .first
    .strftime("%m/%d/%y")
  end
end
