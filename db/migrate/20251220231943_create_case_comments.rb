class CreateCaseComments < ActiveRecord::Migration[8.0]
  def change
    create_table :case_comments do |t|
      t.references :case, null: false, foreign_key: true
      t.text :content
      t.string :admin_name

      t.timestamps
    end
  end
end
