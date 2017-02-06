require 'spec_helper'

describe SkillCategory do
  it { is_expected.to have_many :skills }
  it { is_expected.to have_many :roles }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }
end
