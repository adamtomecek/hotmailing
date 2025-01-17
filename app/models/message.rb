class Message < ApplicationRecord
  has_rich_text :content
  has_many_attached :attachments

  validates :from, presence: true
  validates :to, presence: true

  belongs_to :topic, touch: true
  belongs_to :reply_to, optional: true, class_name: 'Message'
  has_many :replies, class_name: 'Message', foreign_key: :reply_to_id, dependent: :nullify

  before_validation :build_or_find_topic, if: -> { topic.blank? }

  scope :latest_first, -> { order(created_at: :desc) }

  after_create_commit -> { broadcast_prepend_to topic }
  after_update_commit -> { broadcast_replace_to topic }
  after_destroy_commit -> { broadcast_remove_to topic }

  def build_or_find_topic
    if reply_to.present?
      self.topic = reply_to.topic
    else
      build_topic(subject: subject)
    end
  end
end
