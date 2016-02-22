class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :issues, :rtid, :request_type_id
    rename_column :clusters, :rtid, :request_type_id
  end
end
