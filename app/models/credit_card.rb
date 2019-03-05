class CreditCard < ApplicationRecord
    belongs_to :user
    has_many :amount_used_of_credits, dependent: :destroy
end
