class AddSfIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :sf_id, :string
  end
end
