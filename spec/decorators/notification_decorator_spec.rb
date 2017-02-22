require 'spec_helper'

describe NotificationDecorator do
  let(:notification) { create(:notification) }

  subject { notification.decorate }

  describe '#icon_class' do
    context 'when notification type equals skill_created' do
      let(:notification) do
        create(:notification, notification_type: 'skill_created')
      end
      it { expect(subject.icon_class).to eq 'glyphicon-plus' }
    end
    context 'when notification type equals skill_updated' do
      let(:notification) do
        create(:notification, notification_type: 'skill_updated')
      end
      it { expect(subject.icon_class).to eq 'glyphicon-pencil' }
    end
  end
end
