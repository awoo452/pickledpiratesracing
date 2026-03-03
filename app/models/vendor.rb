class Vendor < ApplicationRecord
  has_many :vendor_products, dependent: :destroy
  has_many :product_variants, through: :vendor_products
  has_many :products, through: :product_variants

  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
end
