class Message < ApplicationRecord
  has_rich_text :content
  has_many_attached :attachments

  validates :from, presence: true
  validates :to, presence: true
end
