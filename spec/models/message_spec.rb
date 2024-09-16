require 'rails_helper'

RSpec.describe Message, type: :model do
  it 'builds topic with same subject' do
    message = create(:message, subject: 'Test subject')

    expect(message.topic.subject).to eq 'Test subject'
  end

  it 'uses existing topic if the message is a reply' do
    message = create(:message)
    reply = create(:message, reply_to: message)

    expect(reply.topic).to eq message.topic
  end
end
