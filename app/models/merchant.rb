class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices
  has_many :bulk_discounts

  validates_presence_of :name
  enum status: ["disabled", "enabled"]

  def self.top_5
    joins(:transactions)
    .where(transactions: {result: 0})
    .select("merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue")
    .group('merchants.id')
    .order(revenue: :desc)
    .limit(5)
  end

  def top_5_customers
    customers.top_five
  end

  def ordered_not_shipped
    invoice_items.joins(:invoice)
    .where.not(status: 2)
    .order("invoices.created_at asc")
  end


  def self.top_5_customers
    Customer.joins(:transactions)
    .where("transactions.result = ?", 0)
    .group("customers.id")
    .select("customers.*, count(transactions) as transaction_count")
    .order(transaction_count: :desc)
    .order(:first_name)
    .order(:last_name)
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
