require 'spec_helper'

describe PositionsController do


  context 'normal user' do
    let(:role) { create(:role, name: 'junior1', technical: true) }
    let(:user) { create(:user, primary_role: role) }
    let!(:params) { attributes_for(:position, user_id: user.id, role_id: role.id) }
    let(:position) { create(:position, role: role, user: user) }
    before { sign_in(user) }

    describe '#create' do
      it 'doesn\'t create new position' do
        expect { post :create, position: params }.not_to change { Position.count }
      end
    end

    describe '#update' do
      def update
        put :update,
            id: position.id,
            position: { starts_at: Date.today - 15.days }
      end

      it 'doesn\'t update position' do
        expect { update }.not_to change { position }
      end
    end

    describe '#destroy' do
      it 'doesn\t destroy record' do
        expect { delete :destroy, id: position.id }.not_to change { position }
      end
    end
  end

  context 'admin user' do
    let(:admin_user) { create(:user, :admin) }

    before { sign_in(admin_user) }

    describe '#new' do
      before { get :new }

      it 'responds success with HTTP status 200' do
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

      it 'exposes new position' do
        expect(controller.position.created_at).to be_nil
      end
    end

    describe '#create' do
      let(:role) { create(:role, name: 'junior1', technical: true) }
      let(:user) { create(:user, primary_role: role) }
      let!(:params) { attributes_for(:position, user_id: user.id, role_id: role.id) }

      context 'with valid attributes' do
        it 'creates a new position' do
          expect { post :create, position: params }.to change(Position, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        let(:invalid_params) { params.except(:starts_at) }

        it 'does not save' do
          expect { post :create, position: invalid_params }.to_not change(Position, :count)
        end
      end
    end

    describe '#update' do
      let(:role) { create(:role, name: 'junior1', technical: true) }
      let(:user) { create(:user, primary_role: role) }
      let!(:position) { create(:position, user: user, role: role) }

      it 'exposes positions' do
        put :update, id: position, position: position.attributes
        expect(controller.position).to eq position
      end

      context 'valid attributes' do
        it 'changes position start date' do
          attributes = { starts_at: Date.new(2014, 05, 19) }
          put :update, id: position, position: attributes
          position.reload
          expect(position.starts_at.day).to eq 19
        end
      end

      context 'invalid attributes' do
        it 'does not change position attributes' do
          attributes = { starts_at: nil }
          put :update, id: position, position: attributes
          position.reload
          expect(position.starts_at.day).to_not be nil
        end
      end
    end

    describe '#destroy' do
      let(:intern_role) { create(:role, name: 'intern', technical: true) }
      let(:user) { create(:user, primary_role: intern_role) }
      let!(:position) { create(:position, user: user, role: intern_role) }

      it 'deletes the position' do
        @request.env['HTTP_REFERER'] = positions_path
        expect { delete :destroy, id: position }.to change(Position, :count).by(-1)
      end
    end

    describe '#toggle_primary' do
      subject { put :toggle_primary, id: position.id }
      let(:junior_role) { create(:role, name: 'junior', technical: true) }
      let(:user) { create(:user, primary_role: junior_role) }
      let(:intern_role) { create(:role, name: 'intern', technical: true) }

      context 'when position is not primary' do
        let!(:position) { create(:position, user: user, role: intern_role, primary: false) }

        it 'toggles position to primary' do
          expect{ subject }.to change{ position.reload.primary }.from(false).to(true)
        end

        it 'sends mail with position change' do
          expect(SendMailWithUserJob).to receive(
            :perform_async
          ).with(
            PositionMailer,
            :new_primary,
            position.reload,
            user.id
          )
          subject
        end

        it 'updates user primary role' do
          expect { subject }.to change{ user.reload.primary_role.id }.from(junior_role.id).to(intern_role.id)
        end
      end

      context 'when position is primary' do
        let!(:position) { create(:position, user: user, role: intern_role, primary: true) }

        let(:intern_role) { create(:role, name: 'intern', technical: true) }

        it 'toggles position to not primary' do
          expect{ subject }.to change{ position.reload.primary }.from(true).to(false)
        end
      end
    end
  end
end
