class Topic < ApplicationRecord
  has_many :messages, dependent: :destroy

  def attachments
    messages.map { |message| (message.attachments + message.content.embeds) }.flatten
  end
end
