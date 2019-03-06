class AssetTransition < ApplicationRecord
    belongs_to :user_asset
    belongs_to :user
end
