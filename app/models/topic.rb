class Topic < ApplicationRecord
  has_many :messages, dependent: :destroy
end
