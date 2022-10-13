require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Commentable }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe "for user" do
    let(:user) { create(:user) }
    let(:question) { create(:question, :with_files, user: user) }
    let(:answer) { create(:answer, :with_files, user: user) }
    let(:other_user) { create(:user) }
    let(:other_question) { create(:question, :with_files, user: other_user) }
    let(:other_answer) { create(:answer, :with_files, user: other_user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :comment, Question }
    it { should be_able_to :comment, Answer }

    it { should be_able_to :update, create(:question, user: user) }
    it { should_not be_able_to :update, create(:question) }

    it { should be_able_to :update, create(:answer, user: user) }
    it { should_not be_able_to :update, create(:answer) }

    it { should be_able_to :destroy, question }
    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, other_answer }
    it { should_not be_able_to :destroy, other_question }


  end
end
