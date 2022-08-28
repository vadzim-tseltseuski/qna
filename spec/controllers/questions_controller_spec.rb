require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'voted'

  let(:question) { create(:question) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user1) }

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user1) }

    before { get :edit, params: { id: question } }

    context 'author question' do
      before { question.update(user_id: user1.id) }

      before { get :edit, params: { id: question } }

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'no author question' do
      before { get :edit, params: { id: question } }

      it 'redirects to question path' do
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'POST #create' do
    before { login(user1) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(user1.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }

        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user1) }

    context 'author question' do
      before { question.update(user_id: user1.id) }

      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question),  format: :js}
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: 'QuestionTitle', body: 'QuestionBody' }, format: :js }
          question.reload

          expect(question.title).to eq 'QuestionTitle'
          expect(question.body).to eq 'QuestionBody'
        end

        it 'redirects to upload question' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(response).to redirect_to question
        end
      end


      context 'with invalid attributes' do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

        it 'does not change question' do
          question.reload

          expect(question.title).to eq 'QuestionTitle'
          expect(question.body).to eq 'QuestionBody'
        end

        it 're-renders edit view' do
          expect(response).to render_template :update
        end
      end
    end

    context 'not own question' do
      before { patch :update, params: { id: question, question: { title: 'QuestionTitle', body: 'QuestionBody' } }, format: :js }

      it 'does not change question' do
        question.reload

        expect(question.title).to eq 'QuestionTitle'
        expect(question.body).to eq 'QuestionBody'
      end
      it 're-renders edit view' do
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user1) }

    context 'author question' do
      before { question.update(user_id: user1.id) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(user1.questions, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'no author question' do
      before { question.update(user_id: user2.id) }

      it "doesn't delete not the own question" do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
