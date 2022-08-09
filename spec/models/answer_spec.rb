# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  subject(:answer) { create(:answer) }

  describe 'associations' do
    it { should belong_to :question }
    it { should belong_to :user }
    it { should have_one(:question_where_is_top).dependent(:nullify) }

    it 'has many attached files' do
      expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end

  describe 'set_as_top!' do
    it 'set as top answer' do
      answer.set_as_top!
      expect(answer.question.top_answer).to be answer
    end
  end

  describe 'top?' do
    it 'is false if not marked as top' do
      expect(answer).not_to be_top
    end

    it 'is true if marked as top' do
      answer.set_as_top!
      expect(answer).to be_top
    end
  end
end
