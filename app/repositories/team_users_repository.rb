class TeamUsersRepository
  attr_reader :team

  def initialize(team)
    @team = team
  end

  def all
    team.users
  end

  def leader
    team.leader
  end

  def subordinates
    team.users.where.not(id: leader.id)
  end
end
