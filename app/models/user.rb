# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  user_name              :string           default(""), not null
#  active                 :boolean          default(FALSE)
#  role                   :string           default("guest"), not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  admin                  :boolean          default(FALSE)
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_user_name             (user_name) UNIQUE
#

class User < ApplicationRecord
  has_many :payments
  has_many :documents

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
