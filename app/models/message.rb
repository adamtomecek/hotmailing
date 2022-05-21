class Message < ApplicationRecord
  has_rich_text :content

  validates :from, presence: true
  validates :to, presence: true
end
