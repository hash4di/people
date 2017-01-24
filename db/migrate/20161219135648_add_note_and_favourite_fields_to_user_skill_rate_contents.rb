class AddNoteAndFavouriteFieldsToUserSkillRateContents < ActiveRecord::Migration
  def change
    add_column :user_skill_rate_contents, :note, :string
    add_column :user_skill_rate_contents, :favorite, :boolean
  end
end
