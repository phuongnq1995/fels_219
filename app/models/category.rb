class Category < ActiveRecord::Base
  acts_as_paranoid

  has_many :words, dependent: :destroy
  has_many :lessons

  validates :name, presence: true, length: {maximum: Settings.size_content},
   uniqueness: {case_sensitive: false}
  validates :discription, presence: true, length: {maximum: Settings.size_area}

  scope :alpha, -> {order name: :asc}
  scope :search, ->(search) do
    with_deleted.where "name LIKE ?", "%#{search}%"
  end
end
