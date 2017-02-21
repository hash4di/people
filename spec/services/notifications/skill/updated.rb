require 'spec_helper'

describe Notifications::Skill::Updated do
  subject { described_class.new(notifiable_id: skill.id) }

  let(:skill) { create(:skill) }
  let!(:rate) { create(:user_skill_rate, skill: skill, rate: 1, user: active_user_with_rate) }
  let(:active_user_with_rate) { create(:user) }
  let!(:active_user_without_rate) { create(:user) }
  let!(:inactive_user) { create(:user, :archived) }

  describe '#notify' do

    it 'sends notificaiton to all users' do
      expect { subject.notify }.to change { Notification.count }.by(1)
      expect { subject.notify }.to change {
        active_user_with_rate.notifications.count
      }.by(1)
      expect { subject.notify }.to_not change {
        active_user_without_rate.notifications.count
      }
      expect { subject.notify }.to_not change {
        inactive_user.notifications.count
      }
    end
  end
end
