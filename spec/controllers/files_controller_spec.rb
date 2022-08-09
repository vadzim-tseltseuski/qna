# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, :with_files, user: user) }

  let(:other_user) { create(:user) }
  let(:other_question) { create(:question, :with_files, user: other_user) }

  describe 'DELETE #destroy' do
    before { login(user) }

    it 'deletes the file' do
      expect do
        delete :destroy, params: { id: question.files.first }, format: :js
      end.to change(question.files, :count).by(-1)
    end

    it "can't delete others file" do
      expect do
        delete :destroy, params: { id: other_question.files.first }, format: :js
      end.not_to change(question.files, :count)
    end

    it 'renders destroy view' do
      delete :destroy, params: { id: question.files.first }, format: :js
      expect(response).to render_template :destroy
    end
  end
end