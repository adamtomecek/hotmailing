class AddTopicToMessages < ActiveRecord::Migration[7.0]
  def change
    add_reference :messages, :topic, null: false, foreign_key: true
    add_reference :messages, :reply_to, null: true, foreign_key: { to_table: :messages }
    add_column :messages, :message_id, :string, index: true
  end
end
