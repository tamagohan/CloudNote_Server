class User < ActiveRecord::Base
  has_many :notes

  acts_as_authentic
end
