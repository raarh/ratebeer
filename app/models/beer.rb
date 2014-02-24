class Beer < ActiveRecord::Base
  include RatingAverage
  belongs_to :brewery,  touch: true
  belongs_to :style
  has_many :ratings, :dependent => :destroy
  has_many :raters, -> {uniq}, through: :ratings, source: :user
  validates :name, :presence => true
  validates :style_id, :presence => true

  def to_s
    "#{brewery.name} #{self.name}"
  end
end
