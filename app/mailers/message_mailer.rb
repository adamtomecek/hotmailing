class MessageMailer < ApplicationMailer
  def send_message
    @message = params[:message]

    mail subject: @message.subject, from: @message.from, to: @message.to, cc: @message.cc, bcc: @message.bcc
  end
end
