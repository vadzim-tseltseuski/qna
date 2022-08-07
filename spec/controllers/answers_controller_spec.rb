require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:answer) { create(:answer) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }


  before { login(user1) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: answer.question, answer: attributes_for(:answer) }, format: :js }.to change(answer.question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { question_id: answer.question, answer: attributes_for(:answer), format: :js }

        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: answer.question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(answer.question.answers, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: answer.question, answer: attributes_for(:answer, :invalid), format: :js}

        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user1) }
    context 'own answer' do
      before { answer.update(user_id: user1.id) }

      context 'with valid attributes' do
        it 'assigns the requested answer to @answer' do
          patch :update, params: { question_id: answer.question, id: answer, answer: attributes_for(:answer) }, format: :js
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          patch :update, params: { question_id: answer.question, id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload

          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { question_id: answer.question, id: answer, answer: { body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { question_id: answer.question, id: answer, answer: attributes_for(:answer, :invalid) }, format: :js }

        it 'does not change answer' do
          answer.reload

          expect(answer.body).to eq 'Answer_Body'
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end

    end

      context 'not own answer' do
        before { answer.update(user_id: user2.id) }
        before { patch :update, params: { question_id: answer.question, id: answer, answer: { body: 'new body' } } }
        it 'does not change answer' do
          answer.reload
          expect(answer.body).to eq 'Answer_Body'
        end
        it 're-renders edit view' do
          expect(response).to redirect_to question_path(answer.question)
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
