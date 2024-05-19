class RemoveCorrectFromAnswers < ActiveRecord::Migration[7.1]
  def change
    remove_column :answers, :correct
  end
end
