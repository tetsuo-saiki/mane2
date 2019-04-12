class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :item_types, dependent: :destroy
  has_many :items, dependent: :destroy
  has_many :user_assets, dependent: :destroy
  has_many :asset_transitions, dependent: :destroy
  has_many :incomes, dependent: :destroy
  has_many :debts, dependent: :destroy
  has_many :credit_cards, dependent: :destroy
  has_many :amount_used_of_credits, dependent: :destroy
  has_many :monthly_flows, dependent: :destroy
end
