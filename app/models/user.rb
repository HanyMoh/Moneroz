class User < ApplicationRecord
  has_many :payments
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  EMAIL_REGEX = /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}\Z/i

  validates :user_name, presence: true,
                      length: { within: 2..40 },
                      uniqueness: true

  validates :email,    presence: true,
                      length: { maximum: 100 },
                      format: EMAIL_REGEX,
                      confirmation: true,
                      uniqueness: true

  validates :password, length: { minimum: 4, maximum: 120 }, on: :update, allow_blank: true

 default_scope { order('id ASC') }
end
