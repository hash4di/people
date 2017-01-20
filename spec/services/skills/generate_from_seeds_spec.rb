require 'spec_helper'

describe Skills::GenerateFromSeeds do
  subject { described_class.call }

  before do
    SKILLS_AND_CATEGORIES = [
      {
        :ref_name=>"backend_ruby-on-rails", :name=>"Ruby on Rails", :rating=>"int", :description=>"Rails is a web application development framework written in the Ruby language. It is designed to make programming web applications easier by making assumptions about what every developer needs to get started.", :category=>"backend"
      },
      {
        :ref_name=>"backend_sinatra", :name=>"Sinatra", :rating=>"boolean", :description=>"Sinatra is a free and open source software web application library and domain-specific language written in Ruby. It is an alternative to other Ruby web application frameworks such as Ruby on Rails. It is dependent on the Rack web server interface.", :category=>"backend"
      }
    ]
  end

  describe '.call' do
    it 'creates one new category' do
      expect { subject }.to change{ SkillCategory.count }.from(0).to(1)
    end

    it 'creates two new skills' do
      expect { subject }.to change{ Skill.count }.from(0).to(2)
    end
  end
end
