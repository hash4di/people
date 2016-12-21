require 'spec_helper'

describe ::Skills::UserSkillRates::Update do
  subject do
    described_class.new(
      user_skill_rate_id: user_skill_rate.id,
      params: params
    )
  end

  describe '#call' do
    let(:user) { create(:user) }
    let(:user_skill_rate) do
      create(:user_skill_rate, note: 'abc', rate: 0, favorite: false, user: user)
    end
    let(:params) do
      {
        id: user_skill_rate.id,
        note: 'def',
        rate: 1,
        favorite: true
      }
    end

    it 'updates note on user rate skill' do
      expect { subject.call }.to change { user_skill_rate.reload.note }.from('abc').to('def')
    end

    it 'updates favorite on user rate skill' do
      expect { subject.call }.to change { user_skill_rate.reload.rate }.from(0).to(1)
    end

    it 'updates favorite on user favorite skill' do
      expect { subject.call }.to change { user_skill_rate.reload.favorite }.from(false).to(true)
    end

    context "when user_skill_rate_content doesn't exist today" do
      let(:last_content) { user_skill_rate.contents.last }

      it 'creates new user_skill_rate_content' do
        expect { subject.call }.to change { user_skill_rate.contents.count }
      end

      it 'sets correct values on new content' do
        subject.call
        user_skill_rate.reload
        aggregate_failures do
          expect(last_content.favorite).to eq(user_skill_rate.favorite)
          expect(last_content.note).to eq(user_skill_rate.note)
          expect(last_content.rate).to eq(user_skill_rate.rate)
        end
      end
    end

    context 'when user_skill_rate_content exists today' do
      let!(:user_skill_rate_content) do
        create(
          :user_skill_rate_content,
          user_skill_rate_id: user_skill_rate.id
        )
      end

      it "doesn't create new user_skill_rate_content" do
        expect { subject.call }.to_not change { user_skill_rate.contents.count }
      end

      it 'updates content' do
        subject.call
        user_skill_rate_content.reload
        user_skill_rate.reload
        aggregate_failures do
          expect(user_skill_rate_content.favorite)
            .to eq(user_skill_rate.favorite)
          expect(user_skill_rate_content.note).to eq(user_skill_rate.note)
          expect(user_skill_rate_content.rate).to eq(user_skill_rate.rate)
        end
      end
    end
  end
end
