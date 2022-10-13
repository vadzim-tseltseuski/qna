require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'Accept': 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 5) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status code' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq questions.size
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[user_id best_answer_id].each do |attr|
          expect(question_response).to_not have_key(attr)
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq answers.size
        end

        it 'returns all public fields of answer' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end

        it 'does not return private fields of answer' do
          %w[user_id].each do |attr|
            expect(answer_response).to_not have_key(attr)
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/{id}' do
    let!(:question) { create(:question, :with_files) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }
      let!(:comments) { create_list(:comment, 3, commentable: question) }
      let!(:links) { create_list(:link, 3, linkable: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status code' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'does not return private fields of question' do
        %w[user_id].each do |attr|
          expect(question_response).to_not have_key(attr)
        end
      end

      describe 'comments' do
        it_behaves_like 'Comments responsibility' do
          let(:object) { question }
          let(:object_response) { question_response }
        end
      end

      describe 'files' do
        it_behaves_like 'Files responsibility' do
          let(:object) { question }
          let(:object_response) { question_response }
        end
      end

      describe 'links' do
        it_behaves_like 'Links responsibility' do
          let(:object_response) { question_response }
        end
      end
    end

    describe 'POST /api/v1/questions' do
      let(:api_path) { '/api/v1/questions' }

      it_behaves_like 'API Authorizable' do
        let(:method) { :post }
      end

      context 'authorized' do
        let(:user) { create(:user) }
        let(:access_token) { create(:access_token, resource_owner_id: user.id) }

        context 'with valid attributes' do
          it 'returns 201 status code' do
            post api_path, params: { access_token: access_token.token, question: attributes_for(:question) }, headers: headers

            expect(response).to have_http_status :created
          end

          it 'saves a new question in the database' do
            expect { post api_path, params: { access_token: access_token.token, question: attributes_for(:question) }, headers: headers }.
              to change(user.questions, :count).by(1)
          end

          it 'returns fields that was send in parameters' do
            post api_path, params: { access_token: access_token.token, question: attributes_for(:question) }, headers: headers

            %w[title body].each do |attr|
              expect(json['question'][attr]).to eq attributes_for(:question)[attr.to_sym]
            end
          end
        end

        context 'with invalid attributes' do
          it 'returns 400 status code' do
            post api_path, params: { access_token: access_token.token, question: attributes_for(:question, :invalid) }, headers: headers

            expect(response).to have_http_status :bad_request
          end

          it 'does not save the question' do
            expect { post api_path, params: { access_token: access_token.token, question: attributes_for(:question, :invalid) }, headers: headers }.
              to_not change(Question, :count)
          end

          it 'should contain key errors' do
            post api_path, params: { access_token: access_token.token, question: attributes_for(:question, :invalid) }, headers: headers

            expect(json).to have_key('errors')
          end
        end
      end
    end

    describe 'PATCH /api/v1/questions/{id}' do
      let(:question) { create(:question) }
      let(:api_path) { "/api/v1/questions/#{question.id}" }

      it_behaves_like 'API Authorizable' do
        let(:method) { :patch }
      end

      context 'authorized' do
        let(:user) { create(:user) }
        let(:access_token) { create(:access_token, resource_owner_id: user.id) }

        context 'own question' do
          before { question.update(user_id: user.id) }

          context 'with valid attributes' do
            before { patch api_path, params:
              { access_token: access_token.token, question: { title: 'new title', body: 'new body' } }, headers: headers }

            it 'returns 200 status code' do
              expect(response).to be_successful
            end

            it 'changes question attributes' do
              question.reload

              expect(question.title).to eq 'new title'
              expect(question.body).to eq 'new body'
            end
          end

          context 'with invalid attributes' do
            before { patch api_path, params:
              { access_token: access_token.token, question: attributes_for(:question, :invalid) }, headers: headers }

            it 'returns 400 status code' do
              expect(response).to have_http_status :bad_request
            end

            it 'does not change question' do
              question.reload

              expect(question.title).to eq 'QuestionTitle'
              expect(question.body).to eq 'QuestionBody'
            end

            it 'should contain key errors' do
              expect(json).to have_key('errors')
            end
          end
        end

        context 'not own question' do
          let(:another_user) { create(:user) }

          before do
            question.update(user_id: another_user.id)

            patch api_path, params:
              { access_token: access_token.token, question: { title: 'new title', body: 'new body' } }, headers: headers
          end

          it 'returns 403 status code' do
            expect(response).to have_http_status :forbidden
          end

          it 'does not change question' do
            question.reload

            expect(question.title).to eq 'QuestionTitle'
            expect(question.body).to eq 'QuestionBody'
          end
        end
      end
    end

    describe 'DELETE /api/v1/questions/{id}' do
      let(:question) { create(:question) }
      let(:api_path) { "/api/v1/questions/#{question.id}" }

      it_behaves_like 'API Authorizable' do
        let(:method) { :delete }
      end

      context 'authorized' do
        let(:user) { create(:user) }
        let(:access_token) { create(:access_token, resource_owner_id: user.id) }

        context 'own question' do
          before { question.update(user_id: user.id) }

          it 'returns 204 status code' do
            delete api_path, params: { access_token: access_token.token }, headers: headers

            expect(response).to have_http_status :no_content
          end

          it 'deletes the question' do
            expect { delete api_path, params:
              { access_token: access_token.token }, headers: headers }.to change(user.questions, :count).by(-1)
          end
        end

        context 'no own question' do
          it 'returns 403 status code' do
            delete api_path, params: { access_token: access_token.token }, headers: headers

            expect(response).to have_http_status :forbidden
          end

          it "doesn't delete not the own question" do
            question.reload # TODO: for some reason doesn't work without it
            expect { delete api_path, params:
              { access_token: access_token.token }, headers: headers }.to_not change(Question, :count)
          end
        end
      end
    end

    describe 'GET /api/v1/questions/{id}/answers' do
      let!(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 5, question: question) }
      let(:answer) { answers.first }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

      it_behaves_like 'API Authorizable' do
        let(:method) { :get }
      end

      context 'authorized' do
        let(:user) { create(:user) }
        let(:access_token) { create(:access_token, resource_owner_id: user.id) }
        let(:answer_response) { json['answers'].first }

        before { get api_path, params: { access_token: access_token.token }, headers: headers }

        it 'returns 200 status code' do
          expect(response).to be_successful
        end

        it 'returns list of answers' do
          expect(json['answers'].size).to eq answers.size
        end

        it 'returns all public fields of answer' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end

        it 'does not return private fields of answer' do
          %w[user_id].each do |attr|
            expect(answer_response).to_not have_key(attr)
          end
        end
      end
    end
  end
end
