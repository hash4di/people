class TeamsPage < SitePrism::Page
  set_url '/teams'

  element :show_users_button, '.show-users'
  element :new_team_button, '.new-team-add'
  element :new_team_form, '.js-new-team-form'
  element :new_team_name_input, '.js-new-team-form .form-control.name'
  element :save_team_button, 'a.new-team-submit'

  elements :empty_leader_rows, 'ul.team-members.empty'
  elements :filled_leader_rows, 'ul.team-members.filled'
  elements :memberships, '.membership'
  elements :promote_to_leader_icons, '.js-promote-leader'
  elements :billable_indicators, '.devs-indicator .devs'
  elements :non_billable_indicators, '.devs-indicator .jnrs'
  elements :add_user_dropdowns, 'footer.add-user-to-team'
  elements :edit_team_icons, '.js-edit-team'
  element :cancel_button, '.modal-dialog.edit-team .btn.btn-default.cancel'

  section :edit_team_modal, EditTeamModalSection, '.modal-dialog.edit-team'
end
