class Exercise < ActiveRecord::Base
  has_many :routines
  has_many :users, through: :routines
  belongs_to :user

  validates :name, presence: true

  def self.hash_info_as_key
    hash = Hash.new
    Exercise.all.each do |o|
      key = "#{o.id}. #{o.name} (#{o.duration} mins) - #{o.description}"
      hash[key] = o.id
    end
    hash
  end

end
