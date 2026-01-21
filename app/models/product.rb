class Product < ApplicationRecord
    has_many :product_variants, dependent: :destroy
    before_validation :set_slug, on: :create

    validates :slug, presence: true, uniqueness: true

    def set_slug
        self.slug ||= name.parameterize if name.present?
    end
end
