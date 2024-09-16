require 'rails_helper'

RSpec.describe InboxMailbox, type: :mailbox do
  it 'routes emails to correct mailbox' do
    expect(InboxMailbox).to receive_inbound_email(to: 'test@example.com')
  end

  it 'marks e-mail as delivered and creates new Message' do
    mail = Mail.new(
      from: 'from@example.com',
      to: 'test@example.com',
      subject: 'Test email',
      body: 'Test body',
    )

    mail_processed = process(mail)

    expect(mail_processed).to have_been_delivered
    expect(Message.count).to eq 1

    message = Message.last
    expect(message.from).to eq 'from@example.com'
    expect(message.to).to eq 'test@example.com'
    expect(message.subject).to eq 'Test email'
  end

  it 'saves attachments' do
    mail = Mail.new(
      from: 'from@example.com',
      to: 'test@example.com',
      subject: 'Test email',
      body: 'Test body',
    )

    mail.attachments['test.csv'] = { mime_type: 'text/csv', content: 'a,b,c' }
    mail.attachments['test.png'] = { mime_type: 'image/png', content: 'Not PNG' }

    mail_processed = process(mail)

    message = Message.last

    expect(message.attachments.count).to eq 2
    expect(message.attachments[0].blob.filename).to eq 'test.csv'
    expect(message.attachments[1].blob.filename).to eq 'test.png'
  end

  it 'uses HTML body' do
    mail = Mail.new(
      from: 'from@example.com',
      to: 'test@example.com',
      subject: 'Test email',
    )

    text_part = Mail::Part.new do
      body 'This is plain text'
    end

    html_part = Mail::Part.new do
      content_type 'text/html; charset=UTF-8'
      body '<h1>This is HTML</h1>'
    end

    mail.text_part = text_part
    mail.html_part = html_part

    mail_processed = process(mail)
    message = Message.last

    expect(message.content.to_plain_text).to eq 'This is HTML'
  end

  it 'tracks replies' do
    mail = Mail.new(
      from: 'from@example.com',
      to: 'test@example.com',
      subject: 'Test email',
      body: 'Test body',
    )

    mail_processed = process(mail)

    reply = Mail.new(
      from: 'test@example.com',
      to: 'from@example.com',
      subject: 'Re: Test email',
      body: 'Test reply',
      references: mail_processed.message_id,
    )

    process(reply)

    expect(Message.count).to eq 2
    expect(Message.first.subject).to eq 'Test email'
    expect(Message.last.subject).to eq 'Re: Test email'
    expect(Message.last.reply_to_id).to eq Message.first.id
  end
end


