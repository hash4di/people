class AddRefNameToSkills < ActiveRecord::Migration
  def change
    add_column :skills, :ref_name, :string, index: true
  end
end
