class CreateEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :entries do |t|
      t.string :status_change
      t.references :lock, null: false, foreign_key: true, type: :string
      t.datetime :timestamp

      t.timestamps
    end
  end
end
