class AmountUsedOfCredit < ApplicationRecord
    belongs_to :credit_card
    belongs_to :user
end
