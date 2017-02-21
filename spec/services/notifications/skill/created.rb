require 'spec_helper'

describe Notifications::Skill::Created do
  subject { described_class.new(notifiable_id: skill.id) }

  let(:skill) { create(:skill) }

  describe '#notify' do
    let!(:first_active_user) { create(:user) }
    let!(:second_active_user) { create(:user) }
    let!(:inactive_user) { create(:user, :archived) }

    it 'sends notificaiton to all users' do
      expect { subject.notify }.to change { Notification.count }.by(2)
      expect { subject.notify }.to change { first_active_user.notifications.count }.by(1)
      expect { subject.notify }.to change { second_active_user.notifications.count }.by(1)
      expect { subject.notify }.to_not change { inactive_user.notifications.count }
    end
  end
end
