class Room < ApplicationRecord
  belongs_to :user
  has_many :photos

  validates :room_type, presence: true
  validates :accommodate, presence: true
  validates :bed_room, presence: true
  validates :bath_room, presence: true
  validates :listing_name, presence: true, length: {maximum: 75} # 75 caractères max
  validates :summary, presence: true, length: {maximum: 600}
  validates :address, presence: true
  validates :price, numericality: { only_integer: true, greater_than: 5 } #seulement des nombres entiers supérieurs à 5
end
