class InboxMailbox < ApplicationMailbox
  attr_reader :message

  def process
    @message = Message.create!(
      from: mail.from.join(', '),
      to: mail.to.join(', '),
      subject: mail.subject,
      attachments: parsed_attachments.map { |attachment| attachment[:blob] },
      content: process_email_content,
      message_id: mail.message_id,
      reply_to: Message.find_by(message_id: mail.references),
    )
  end

  private

  def process_email_content
    if mail.html_part.present?
      document = Nokogiri::HTML(mail.html_part.body.decoded)
      document.at_css("body").inner_html.encode('utf-8')
    elsif mail.text_part.present?
      mail.text_part.body.decoded
    else
      mail.body.decoded
    end
  end

  def parsed_attachments
    @parsed_attachments ||= mail.attachments.map do |attachment|
      blob = blob_from_attachment(attachment)

      {
        attachment: attachment,
        blob: blob
      }
    end
  end

  def blob_from_attachment(attachment)
    ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new(attachment.decoded),
      filename: attachment.filename,
      content_type: attachment.content_type,
    )
  end
end
