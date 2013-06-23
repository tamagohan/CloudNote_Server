class CreateLoginSummaries < ActiveRecord::Migration
  def change
    create_table :login_summaries do |t|
      t.datetime :date,          null: false
      t.integer  :count
      t.integer  :scope,         null: false
      t.integer  :status,        null: false
      t.integer  :job_id
      t.integer  :client_id,     null: false

      t.timestamps
    end
  end
end
