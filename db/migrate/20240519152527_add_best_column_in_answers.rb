class AddBestColumnInAnswers < ActiveRecord::Migration[7.1]
  def change
    add_column :answers, :best, :boolean,  default: false, null: false
  end
end
