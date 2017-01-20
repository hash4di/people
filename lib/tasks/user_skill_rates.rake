namespace :user_skill_rates do
  desc 'Generate user_skill_rates with default values for all users'
  task generate_all: :environment do
    active_users = User.active
    skills = Skill.all
    bar = RakeProgressbar.new(active_users.count * skills.count)

    active_users.each do |user|
      skills.each do |skill|
        UserSkillRate.find_or_create_by(user_id: user.id, skill_id: skill.id)
        bar.inc
      end
    end
    bar.finished
  end
end
