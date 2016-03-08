class ProjectSection < SitePrism::Section
  element :archive_icon, '.project-name .action a.archive'
  element :unarchive_icon, '.project-name .action a.unarchive'
  element :member_dropdown, '.project-details .Select-placeholder'
  element :time_from_element, '.time-from time'
  element :time_to_element, '.time-to time'
  element :billable_counter, '.billable .count'
  element :non_billable_counter, '.non-billable .count'
  element :notes_button, '.show-notes'
  element :new_note_field, 'input.new-project-note-text'
  element :new_note_button, 'a.new-project-note-submit'

  elements :memberships, '.membership'
  elements :notes, '.project-note'
  elements :note_remove_buttons, '.note-remove'
end
