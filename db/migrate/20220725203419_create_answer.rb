class CreateAnswer < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.text :body, null: false

      t.timestamps
    end
  end
end
