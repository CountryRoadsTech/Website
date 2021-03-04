# frozen_string_literal: true

# The User model that can be signed in/out, may have pages, may be an admin, etc.
class User < ApplicationRecord
  # Include devise authentication modules:
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_many :pages, inverse_of: :user, dependent: :destroy
end
