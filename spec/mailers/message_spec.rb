require "rails_helper"

RSpec.describe MessageMailer, type: :mailer do
  describe 'Sending a message' do
    let(:message) do
      create(
        :message,
        subject: 'Test subject',
        from: 'adam@tmck.cz',
        to: 'test@example.com',
        cc: 'cc@example.com',
        bcc: 'bcc@example.com',
        content: 'my content',
      )
    end

    let(:mail) { MessageMailer.with(message: message).send_message }

    it 'renders the headers' do
      expect(mail.subject).to eq 'Test subject'
      expect(mail.from).to eq ['adam@tmck.cz']
      expect(mail.to).to eq ['test@example.com']
      expect(mail.cc).to eq ['cc@example.com']
      expect(mail.bcc).to eq ['bcc@example.com']
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('my content')
    end
  end
end
