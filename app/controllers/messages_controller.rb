class MessagesController < ApplicationController
  before_action :set_message, only: %i[ send_email show edit update destroy ]

  # GET /messages
  def index
    @messages = Message.all
  end

  # GET /messages/1
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  def send_email
    MessageMailer.with(message: @message).send_message.deliver_now

    redirect_back fallback_location: messages_url, notice: 'Message was send.'
  end

  # POST /messages
  def create
    @message = Message.new(message_params)

    if @message.save
      MessageMailer.with(message: @message).send_message.deliver_now
      redirect_to @message, notice: "Message was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /messages/1
  def destroy
    @message.destroy
    redirect_to messages_url, notice: "Message was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:subject, :from, :to, :cc, :bcc, :content, attachments: [])
    end
end
