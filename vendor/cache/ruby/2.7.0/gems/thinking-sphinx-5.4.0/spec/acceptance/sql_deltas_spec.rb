# frozen_string_literal: true

require 'acceptance/spec_helper'

describe 'SQL delta indexing', :live => true do
  it "automatically indexes new records" do
    guards = Book.create(
      :title => 'Guards! Guards!', :author => 'Terry Pratchett'
    )
    index

    expect(Book.search('Terry Pratchett').to_a).to eq([guards])

    men = Book.create(
      :title => 'Men At Arms', :author => 'Terry Pratchett'
    )
    sleep 0.25

    expect(Book.search('Terry Pratchett').to_a).to match_array([guards, men])
  end

  it "automatically indexes updated records" do
    book = Book.create :title => 'Night Watch', :author => 'Harry Pritchett'
    index

    expect(Book.search('Harry').to_a).to eq([book])

    book.reload.update(:author => 'Terry Pratchett')
    sleep 0.25

    expect(Book.search('Terry').to_a).to eq([book])
  end

  it "does not match on old values" do
    book = Book.create :title => 'Night Watch', :author => 'Harry Pritchett'
    index

    expect(Book.search('Harry').to_a).to eq([book])

    book.reload.update(:author => 'Terry Pratchett')
    sleep 0.25

    expect(Book.search('Harry')).to be_empty
  end

  it "does not match on old values with alternative ids" do
    album = Album.create :name => 'Eternal Nightcap', :artist => 'The Whitloms'
    index

    expect(Album.search('Whitloms').to_a).to eq([album])

    album.reload.update(:artist => 'The Whitlams')
    sleep 0.25

    expect(Book.search('Whitloms')).to be_empty
  end

  it "automatically indexes new records of subclasses" do
    book = Hardcover.create(
      :title => 'American Gods', :author => 'Neil Gaiman'
    )
    sleep 0.25

    expect(Book.search('Gaiman').to_a).to eq([book])
  end

  it "updates associated models" do
    colour = Colour.create(:name => 'green')
    sleep 0.25

    expect(Colour.search('green').to_a).to eq([colour])

    tee = colour.tees.create
    sleep 0.25

    expect(Colour.search(:with => {:tee_ids => tee.id}).to_a).to eq([colour])
  end
end
