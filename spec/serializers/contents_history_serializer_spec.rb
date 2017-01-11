require 'spec_helper'

describe ContentsHistorySerializer do
  subject { described_class.new(user_skill_rate).serializable_hash }

  let(:freeze_time) { Time.local(2017, 1, 11, 17, 50, 0) }

  before do
    Timecop.freeze(freeze_time) { user_skill_rate }
    Timecop.freeze(freeze_time + 30.days) { user_skill_rate_content_1 }
    Timecop.freeze(freeze_time + 60.days) { user_skill_rate_content_2 }
  end

  let(:skill_category) { create(:skill_category, name: 'backend') }
  let(:skill) { create(:skill, skill_category: skill_category) }
  let(:user_skill_rate) do
    create(:user_skill_rate, user: user, skill: skill )
  end
  let(:user) { create(:user) }
  let(:user_skill_rate_content_1) do
    create(:user_skill_rate_content, user_skill_rate: user_skill_rate )
  end
  let(:user_skill_rate_content_2) do
    create(:user_skill_rate_content, user_skill_rate: user_skill_rate )
  end

  context 'when date range is set' do
    let(:context) do
      { start_date: freeze_time + 45.days, end_date: freeze_time + 75.days }
    end
    subject do
      described_class.new(user_skill_rate, context: context).serializable_hash
    end

    it { expect(subject[:user_id]).to eq(user_skill_rate.user_id) }
    it { expect(subject[:skill_id]).to eq(user_skill_rate.skill_id) }
    it { expect(subject[:rate]).to eq(user_skill_rate.rate) }
    it { expect(subject[:created_at]).to eq(user_skill_rate.created_at) }
    it { expect(subject[:updated_at]).to eq(user_skill_rate.updated_at) }
    it { expect(subject[:note]).to eq(user_skill_rate.note) }
    it { expect(subject[:favorite]).to eq(user_skill_rate.favorite) }
    it { expect(subject[:name]).to eq(skill.name) }
    it { expect(subject[:description]).to eq(skill.description) }
    it { expect(subject[:rate_type]).to eq(skill.rate_type) }
    it { expect(subject[:category]).to eq(skill_category.name) }
    it { expect(subject[:history]).to eq([user_skill_rate_content_2]) }
    it do
      expect(
        subject[:first_change_before_data_range]
      ).to eq(user_skill_rate_content_1)
    end
  end

  context 'when date range is not set' do
    subject { described_class.new(user_skill_rate).serializable_hash }

    it { expect(subject[:user_id]).to eq(user_skill_rate.user_id) }
    it { expect(subject[:skill_id]).to eq(user_skill_rate.skill_id) }
    it { expect(subject[:rate]).to eq(user_skill_rate.rate) }
    it { expect(subject[:created_at]).to eq(user_skill_rate.created_at) }
    it { expect(subject[:updated_at]).to eq(user_skill_rate.updated_at) }
    it { expect(subject[:note]).to eq(user_skill_rate.note) }
    it { expect(subject[:favorite]).to eq(user_skill_rate.favorite) }
    it { expect(subject[:name]).to eq(skill.name) }
    it { expect(subject[:description]).to eq(skill.description) }
    it { expect(subject[:rate_type]).to eq(skill.rate_type) }
    it { expect(subject[:category]).to eq(skill_category.name) }
    it do
      expect(subject[:history]).to eq(
        [
          user_skill_rate_content_1, user_skill_rate_content_2
        ]
      )
    end
    it { expect(subject[:first_change_before_data_range]).to eq(nil) }
  end
end
