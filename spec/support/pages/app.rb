class App < SitePrism::Page
  def abilities_page
    AbilitiesPage.new
  end

  def home_page
    HomePage.new
  end

  def projects_page
    ProjectsPage.new
  end

  def project_show_page
    ProjectShowPage.new
  end

  def project_edit_page
    ProjectEditPage.new
  end

  def project_new_page
    ProjectNewPage.new
  end

  def roles_page
    RolesPage.new
  end

  def scheduling_page
    SchedulingPage.new
  end

  def scheduling_juniors_inters_page
    SchedulingJuniorsIntersPage.new
  end

  def scheduling_to_rotate_page
    SchedulingToRotatePage.new
  end

  def scheduling_in_internals_page
    SchedulingInInternalsPage.new
  end

  def scheduling_in_rotations_page
    SchedulingInRotationsPage.new
  end

  def scheduling_projects_with_due_date_page
    SchedulingProjectsWithDueDatePage.new
  end

  def scheduling_booked_page
    SchedulingBookedPage.new
  end

  def scheduling_unavailable_page
    SchedulingUnavailablePage.new
  end

  def scheduling_not_scheduled_page
    SchedulingNotScheduledPage.new
  end

  def statistics_page
    StatisticsPage.new
  end

  def teams_page
    TeamsPage.new
  end

  def user_profile_page
    UserProfilePage.new
  end

  def users_page
    UsersPage.new
  end

  def user_skill_rates_page
    UserSkillRatesPage.new
  end

  def skills_page
    SkillsPage.new
  end

  def skills_new_page
    SkillsNewPage.new
  end

  def skill_details_page
    SkillDetailsPage.new
  end

  def draft_skills_page
    DraftSkillsPage.new
  end

  def draft_skill_edit_page
    DraftSkillEditPage.new
  end

  def skill_edit_page
    SkillEditPage.new
  end
end
