class Category < ActiveRecord::Base
  has_many :words, dependent: :destroy
  has_many :lessons, dependent: :destroy

  validates :name, presence: true, length: {maximum: Settings.size_content},
   uniqueness: {case_sensitive: false}
  validates :discription, presence: true, length: {maximum: Settings.size_area}

  scope :alpha, -> {order name: :asc}

  def self.search search
    where "name LIKE ?", "%#{search}%"
  end
end
