class Exercise < ActiveRecord::Base
  has_many :routines
  has_many :users, through: :routines
  belongs_to :user

  validates :name, presence: true
end
