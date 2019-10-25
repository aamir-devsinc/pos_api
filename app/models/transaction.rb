class Transaction < ApplicationRecord
  belongs_to :vendor, optional: true
  validates :amount, :transaction_date, :transaction_code, presence: true
  validates :transaction_code, uniqueness: true
end