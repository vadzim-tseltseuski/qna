class AddTopAnswerToQuestion < ActiveRecord::Migration[6.1]
  def change
    add_reference :questions, :top_answer, foreign_key: { to_table: :answers }
  end
end
