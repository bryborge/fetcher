class CreateFetchRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :fetch_requests do |t|
      t.string :url
      t.string :requested_by
      t.string :status
      t.string :storage_url

      t.timestamps
    end    
  end
end
