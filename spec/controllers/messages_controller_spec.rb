require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  describe 'POST /messages' do
    it 'creates a new Message' do
      message_params = attributes_for(:message)

      expect {
        post :create, params: { message: message_params }
      }.to change { Message.count }.by(1)
    end

    it 'sends an e-mail' do
      message_params = attributes_for(:message)

      expect {
        post :create, params: { message: message_params }
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  describe 'POST /messages/:id/send_email' do
    it 'sends an e-mail' do
      message = create(:message)

      expect {
        post :send_email, params: { id: message.id }
      }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
