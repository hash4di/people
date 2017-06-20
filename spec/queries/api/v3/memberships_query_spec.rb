require 'spec_helper'

describe Api::V3::MembershipsQuery do
  subject { Api::V3::MembershipsQuery.new.all_overlapped(filter_params) }

  let(:requested_user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:other_user_2) { create(:user) }
  let(:other_user_3) { create(:user) }
  let(:f2f_date) { Time.now - 4.months }
  let(:filter_params) do
    { user_email: requested_user.email, f2f_date: f2f_date }
  end

  let(:requested_user_project) { create(:project) }
  let!(:membership_1) do
    create(
      :membership,
      project: requested_user_project,
      user: requested_user,
      starts_at: f2f_date - 12.months,
      ends_at: f2f_date + 1.months
    )
  end
  let!(:membership_2) do
    create(
      :membership,
      project: requested_user_project,
      user: other_user,
      starts_at: f2f_date - 5.months,
      ends_at: f2f_date + 2.months
    )
  end
  let!(:membership_3) do
    create(
      :membership,
      project: requested_user_project,
      user: other_user_2,
      starts_at: f2f_date - 5.months,
      ends_at: nil
    )
  end

  describe '#all_overlapped' do
    context 'when worked in the same project' do
      context 'when worked in the same time' do
        it 'returns correct memberships' do
          expect(subject).to_not include(membership_1)
          expect(subject).to include(membership_2)
          expect(subject).to include(membership_3)
        end
      end

      context 'when didin\'t work in the same time' do
        context 'when he worked before requested user' do
          let!(:membership_3) do
            create(
              :membership,
              project: requested_user_project,
              user: other_user,
              starts_at: f2f_date - 2.years,
              ends_at: f2f_date - 18.months
            )
          end

          it 'returns correct membership' do
            expect(subject).to_not include(membership_1)
            expect(subject).to include(membership_2)
            expect(subject).to_not include(membership_3)
          end
        end

        context 'when he worked when requested user had left the project' do
          let!(:membership_3) do
            create(
              :membership,
              project: requested_user_project,
              user: other_user_2,
              starts_at: f2f_date + 2.months,
              ends_at: f2f_date + 3.months
            )
          end

          it 'returns correct membership' do
            expect(subject).to_not include(membership_1)
            expect(subject).to include(membership_2)
            expect(subject).to_not include(membership_3)
          end
        end
      end
    end

    context 'when didn\'t work in the same project' do
      let(:other_project) { create(:project) }
      let!(:membership_3) do
        create(
          :membership,
          project: other_project,
          user: other_user,
          starts_at: f2f_date - 4.months,
          ends_at: f2f_date + 3.months
        )
      end

      it 'returns correct membership' do
        expect(subject).to_not include(membership_1)
        expect(subject).to include(membership_2)
        expect(subject).to_not include(membership_3)
      end
    end
  end
end
