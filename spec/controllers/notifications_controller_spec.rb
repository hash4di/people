require 'spec_helper'

describe NotificationsController do
  let(:user) { create(:user) }
  let(:notification) { create(:notification, receiver: user) }

  before { sign_in(user) }

  describe '#index' do
    subject { get :index }
    it 'renders correct template' do
      expect(subject).to render_template(:index)
    end
  end

  describe '#show' do
    subject { get :show, id: notification.id }
    it 'renders correct template' do
      expect(subject).to render_template(:show)
    end
  end

  describe '#update' do
    subject { put :update, params }
    let(:params) do
      {
        id: notification.id,
        notification: {
          notification_status: 'notified'
        }
      }
    end
    let(:notification) { create(:notification, :unread, receiver: user) }

    it 'updates notification status' do
      expect { subject }.to change {
        notification.reload.notification_status
      }.from('unread').to('notified')
    end

    it 'renders correct template' do
      expect(subject).to redirect_to(notification)
    end
  end
end
