require 'rails_helper'

RSpec.describe Api::GroupEventsController, type: :controller do
  before(:each) do
    # Start with
    #
    # 10 published events
    10.times { GroupEvent.create name: "Test Event", start_date: Date.today, end_date: Date.tomorrow, location: 'Barcelona, Spain', description: "This is a test description", is_published: true }

    # and
    # 10 drafts
    10.times { GroupEvent.create name: 'Test Event' }
  end

  it "will test GET api/group_events#index" do
    get :index, format: 'json'
    expect(assigns(:group_events).count).to eq 20
    json = JSON.parse response.body
    response_ids = json.collect{ |group_event| group_event["id"] }
    database_ids = GroupEvent.all.collect(&:id)
    expect(response_ids).to match_array(database_ids)
  end

  it "will test GET api/group_events#show with valid arguments" do
    group_event = GroupEvent.first
    get :show, id: group_event.id, format: 'json'
    json = JSON.parse response.body
    expect(json["id"]).to eq group_event.id
  end

  it "will test GET api/group_events#show with invalid arguments" do
    get :show, id: 'a fake ID', format: 'json'
    expect(response.body).to eq "null"
    expect(response.status).to eq 404
  end

  it "will test POST api/group_events#create with valid arguments" do
    post :create, group_event: { name: 'Another Test Event' }, format: 'json'
    expect(GroupEvent.count).to eq 21
    expect(response.status).to eq 201
  end

  it "will test POST api/group_events#create with invalid arguments" do
    post :create, group_event: { description: 'A test event' }, format: 'json'
    expect(GroupEvent.count).to eq 20
    expect(response.status).to eq 422
  end

  it "will test PATCH api/group_events#update with valid arguments" do
    group_event = GroupEvent.last
    patch :update, id: group_event.id, group_event: { name: 'Updated name' }, format: 'json'
    group_event.reload
    expect(group_event.name).to eq 'Updated name'
    expect(response.status).to eq 200
  end

  it "will test PATCH api/group_events#update with invalid arguments" do
    expect {
      patch :update, id: 'dummy ID', group_event: { name: 'Updated name' }, format: 'json'
    }.to raise_error NoMethodError
  end

  it "will test DELETE api/group_events#destroy with valid arguments" do
    group_event = GroupEvent.last
    delete :destroy, id: group_event.id, format: 'json'
    expect(response.status).to eq 204
    expect(GroupEvent.count).to eq 19
  end

  it "will test DELETE api/group_events#destroy with invalid arguments" do
    expect {
      delete :destroy, id: 'A fake ID', format: 'json'
    }.to raise_error NoMethodError
    expect(GroupEvent.count).to eq 20
  end

  it "will test POST api/group_events#publish with valid arguments" do
    group_event = GroupEvent.drafts.last
    group_event.update_attributes name: "Test Event", start_date: Date.today, end_date: Date.tomorrow, location: 'Barcelona, Spain', description: "This is a test description"
    post :publish, id: group_event.id, format: 'json'
    expect(GroupEvent.published).to include(group_event)
    expect(response.status).to eq 200
  end

  it "will test POST api/group_events#publish with invalid arguments" do
    expect {
      post :publish, id: 'A fake ID', format: 'json'
    }.to raise_error NoMethodError
  end

  it "will test POST api/group_events#unpublish with valid arguments" do
    group_event = GroupEvent.published.last
    post :unpublish, id: group_event.id, format: 'json'
    expect(GroupEvent.drafts).to include(group_event)
    expect(response.status).to eq 200
  end

  it "will test POST api/group_events#unpublish with invalid arguments" do
    expect {
      post :unpublish, id: 'A fake ID', format: 'json'
    }.to raise_error NoMethodError
  end

  it "will test GET api/group_events#published" do
    get :published, format: 'json'
    expect(assigns(:group_events).count).to eq 10
    expect(assigns(:group_events)).to match_array(GroupEvent.published)
  end

  it "will test GET api/group_events#drafts" do
    get :drafts, format: 'json'
    expect(assigns(:group_events).count).to eq 10
    expect(assigns(:group_events)).to match_array(GroupEvent.drafts)
  end
end
