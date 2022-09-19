# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :user }
  it { should belong_to(:top_answer).dependent(:destroy).optional }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it_behaves_like 'commentable'

  it 'has many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'sorted_answers' do
    subject(:question) { create(:question) }

    let(:answers) { create_list(:answer, 2, question: question) }

    it 'sorted answers without top answer' do
      expect(question.sorted_answers).to eq answers
    end

    it 'sorted answers with top answer' do
      answers[1].set_as_top!
      question.reload

      expect(question.sorted_answers).to eq answers.reverse
    end
  end
end
