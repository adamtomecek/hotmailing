class MessageMailer < ApplicationMailer
  def send_message
    @message = params[:message]

    # regular uploaded attachments
    @message.attachments.each do |attachment|
      attachments[attachment.blob.filename.to_s] = {
        mime_type: attachment.blob.content_type,
        content: attachment.blob.download,
      }
    end

    # rich content inline attachments
    @message.content.embeds.each do |attachment|
      attachments.inline[attachment.blob.filename.to_s] = {
        mime_type: attachment.blob.content_type,
        content: attachment.blob.download,
      }
    end

    if @message.reply_to.present?
      headers['In-Reply-To'] = @message.reply_to.message_id
    end

    mail subject: @message.subject, from: @message.from, to: @message.to, cc: @message.cc, bcc: @message.bcc
  end
end
