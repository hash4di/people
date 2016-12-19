namespace :users do
  desc 'generates default skills for all users'
  task generate_default_user_skills: :environment do
    ::User.find_each do |user|
      ::Skills::UserSkillRatesGenerator.new(user_id: user.id).call
    end
  end
end
