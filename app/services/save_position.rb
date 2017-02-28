class SavePosition
  attr_reader :position

  def initialize(position)
    @position = position
  end

  def call
    position.save && set_primary_role && update_user_commitment
  end

  private

  def set_primary_role
    return true unless position.primary
    position.user.update(primary_role: position.role)
  end

  def update_user_commitment
    user = CommitmentSetter.new(position.user,
      position.role.name.to_sym).call
    user.save
  end
end
