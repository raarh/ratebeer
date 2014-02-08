class Rating < ActiveRecord::Base
  belongs_to :beer
  belongs_to :user
  validates_uniqueness_of :beer_id, :user_id
  validates_numericality_of :score, { greater_than_or_equal_to: 1,
                                      less_than_or_equal_to: 50,
                                      only_integer: true }
  def to_s
     "#{beer.name}, #{self.score}"
  end
end
