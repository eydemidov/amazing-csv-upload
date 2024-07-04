class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true, uniqueness: true
  validates :password, strong_password: true
end
