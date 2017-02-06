  skip_before_filter :authenticate_admin!
  before_filter :authenticate_for_skills!
