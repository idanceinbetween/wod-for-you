class Exercise < ActiveRecord::Base
  has_many :routines
  has_many :users, through: :routines

  validates :name, presence: true
end
