require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:linkable) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:url) }

  it { should allow_value('http://fbi.com').for(:url) }
  it { should_not allow_value('fbi.com').for(:url) }

  let(:question) { create(:question) }
  let(:link) { create(:link, linkable: question) }
  let(:gist_link) { create(:link, :gist_link, linkable: question) }

  it 'method gist? for gist url' do
    expect(gist_link.gist?).to eq true
  end

  it 'method gist? for another url' do
    expect(link.gist?).to eq false
  end
end