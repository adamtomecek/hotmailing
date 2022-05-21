class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.string :subject
      t.string :from, null: false
      t.string :to, null: false
      t.string :cc
      t.string :bcc

      t.timestamps
    end
  end
end
