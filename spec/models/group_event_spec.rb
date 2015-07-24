require 'rails_helper'

RSpec.describe GroupEvent, type: :model do
  it "has none to begin with" do
    expect(GroupEvent.count).to eq 0
  end

  it "will validate name" do
    group_event = GroupEvent.create
    expect(group_event).to be_invalid
    expect(group_event.errors[:name].count).to eq 1
    expect(GroupEvent.count).to eq 0

    group_event = GroupEvent.create name: 'Test Event'
    expect(group_event).to be_valid
    expect(group_event.errors[:name].count).to eq 0
    expect(GroupEvent.count).to eq 1
  end

  it "will validate start and end dates order" do
    group_event = GroupEvent.new name: 'Test Event'
    group_event.start_date = Date.tomorrow
    expect(group_event).to be_valid

    group_event.end_date = Date.today # End date before start date
    expect(group_event).to be_invalid
    expect(group_event.errors[:start_date].count).to eq 1

    group_event.start_date = Date.today # Start date and end date same. Still invalid
    expect(group_event).to be_invalid
    expect(group_event.errors[:start_date].count).to eq 1

    group_event.start_date = Date.today - 1.day # Valid now. Start date before end date
    expect(group_event).to be_valid
  end

  it "will test set_duration method" do
    group_event = GroupEvent.new name: 'Test Event'
    group_event.save

    expect(GroupEvent.count).to eq 1
    expect(group_event.start_date).to be nil
    expect(group_event.end_date).to be nil
    expect(group_event.duration).to be nil

    group_event.start_date = Date.today
    group_event.save
    expect(group_event.start_date).to eq Date.today
    expect(group_event.end_date).to be nil
    expect(group_event.duration).to be nil

    group_event.end_date = Date.today + 4.days
    group_event.save
    expect(group_event.start_date).to eq Date.today
    expect(group_event.end_date).to eq (Date.today + 4.days)
    expect(group_event.duration).to eq 4

    group_event.end_date = nil
    group_event.duration = 3
    group_event.save
    expect(group_event.start_date).to eq Date.today
    expect(group_event.end_date).to eq (Date.today + 3.days)
    expect(group_event.duration).to eq 3
  end

  it "will test presence of attributes on publish action" do
    group_event = GroupEvent.new name: 'Test Event'
    group_event.is_published = true
    expect(group_event).to be_invalid
    expect(GroupEvent.count).to eq 0
    expect(group_event.errors[:start_date].first).to  eq "can't be blank"
    expect(group_event.errors[:end_date].first).to    eq "can't be blank"
    expect(group_event.errors[:description].first).to eq "can't be blank"
    expect(group_event.errors[:location].first).to    eq "can't be blank"

    group_event.description = "This is a test event"
    group_event.location    = "Barcelona, Spain"
    group_event.start_date  = Date.tomorrow
    group_event.end_date    = Date.today
    expect(group_event).to be_invalid
    expect(group_event.errors[:start_date].first).to eq "can't be less than or equal to end date"

    group_event.start_date  = Date.today
    group_event.end_date    = Date.tomorrow
    expect(group_event).to be_valid
    expect(group_event.duration).to eq 1

    group_event.end_date = nil
    group_event.duration = 2
    expect(group_event).to be_valid
    expect(group_event.end_date).to eq (group_event.start_date + 2.days)
  end

  it "will test published and drafts scopes" do
    20.times { GroupEvent.create name: "Test Event", start_date: Date.today, end_date: Date.tomorrow, location: 'Barcelona, Spain', description: "This is a test description", is_published: true }
    expect(GroupEvent.count).to eq 20
    expect(GroupEvent.published.count).to eq 20
    expect(GroupEvent.drafts.count).to eq 0

    GroupEvent.all[0...5].each {|g| g.unpublish! }
    expect(GroupEvent.count).to eq 20
    expect(GroupEvent.published.count).to eq 15
    expect(GroupEvent.drafts.count).to eq 5

    GroupEvent.all.each {|g| g.publish! }
    expect(GroupEvent.count).to eq 20
    expect(GroupEvent.published.count).to eq 20
    expect(GroupEvent.drafts.count).to eq 0
  end
end
