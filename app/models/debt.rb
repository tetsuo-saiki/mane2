require 'activerecord-import'

class Debt < ApplicationRecord
    belongs_to :user
end
