require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }


  before { login(user1) }

  describe 'GET #new' do
    before { get :new, params: { question_id: answer.question } }
    it 'assigns a new Answer to @answers' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders question view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: answer.question, answer: attributes_for(:answer) } }.to change(answer.question.answers, :count).by(1)
      end

      it 'redirects to question show view' do
        post :create, params: { question_id: answer.question, answer: attributes_for(:answer) }

        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: answer.question, answer: attributes_for(:answer, :invalid) } }.to_not change(answer.question.answers, :count)
      end

      it 're-renders question view' do
        post :create, params: { question_id: answer.question, answer: attributes_for(:answer, :invalid) }

        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do

    context 'author answer' do

      before { answer.update(user_id: user1.id) }

      it 'deletes the question' do
        expect { delete :destroy, params: { question_id: answer.question, id: answer } }.to change(user1.answers, :count).by(-1)
      end

      it 'renders question view' do
        delete :destroy, params: { question_id: answer.question, id: answer }

        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'no author question' do
      before { answer.update(user_id: user2.id) }

      it "doesn't delete not the own question" do
        expect { delete :destroy, params: { question_id: answer.question, id: answer } }.to_not change(Answer, :count)
      end

      it 'redirects to question' do
        delete :destroy, params: { question_id: answer.question, id: answer }

        expect(response).to redirect_to question_path(answer.question)
      end
    end
  end
end
