class UserAsset < ApplicationRecord
    belongs_to :user
    has_many :asset_transitions, dependent: :destroy
end
