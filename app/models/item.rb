class Item < ApplicationRecord
    belongs_to :user
    belongs_to :item_type

    mount_uploader :image_url, ItemImageUploader
end
