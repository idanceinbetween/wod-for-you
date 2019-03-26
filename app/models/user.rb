class User < ActiveRecord::Base
  has_many :routines
  has_many :exercises, through: :routines

  validates :name, presence: true

end
