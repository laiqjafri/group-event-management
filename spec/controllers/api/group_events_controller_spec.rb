require 'rails_helper'

RSpec.describe Api::GroupEventsController, type: :controller do
  before(:each) do
    # Start with
    #
    # 10 published events
    10.times { GroupEvent.create name: "Test Event", start_date: Date.today, end_date: Date.tomorrow, location: 'Barcelona, Spain', description: "This is a test description", is_published: true }

    # and
    # 10 drafts
    10.times { GroupEvent.create name: "Test Event", start_date: Date.today, end_date: Date.tomorrow, location: 'Barcelona, Spain', description: "This is a test description", is_published: false }
  end

  describe '#index' do
    it 'assigns @group_events a list of group events' do
      get :index, format: 'json'
      expect(assigns(:group_events).count).to eq 20
    end
  end

  describe '#show' do
    context 'with valid ID' do
      it 'assigns @group_event' do
        get :show, id: GroupEvent.first.id, format: 'json'
        expect(assigns(:group_event)).to eq GroupEvent.first
      end
    end

    context 'with fake ID' do
      it 'should return not found' do
        get :show, id: 'a fake ID', format: 'json'
        expect(response).to have_http_status :not_found
      end
    end
  end

  describe '#create' do
    context 'with valid arguments' do
      it 'should add a new group event' do
        expect {
          post :create, group_event: { name: 'Another Test Event' }, format: 'json'
        }.to change(GroupEvent, :count).to(21).from(20)
      end
    end

    context 'with invalid arguments' do
      it 'should return unprocessable_entity' do
        post :create, group_event: { description: 'A test event' }, format: 'json'
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe '#update' do
    context 'with valid arguments' do
      it 'should update the group event' do
        group_event = GroupEvent.last
        expect {
          patch :update, id: group_event.id, group_event: { name: 'Updated name' }, format: 'json'
          group_event.reload
        }.to change(group_event, :name).to('Updated name').from('Test Event')
      end
    end

    context 'with invalid arguments' do
      it 'should raise NoMethodError' do
        expect {
          patch :update, id: 'dummy ID', group_event: { name: 'Updated name' }, format: 'json'
        }.to raise_error NoMethodError
      end
    end
  end

  describe '#destroy' do
    context 'with valid arguments' do
      it 'will destroy the group event' do
        expect {
          delete :destroy, id: GroupEvent.last.id, format: 'json'
        }.to change(GroupEvent, :count).to(19).from(20)
      end
    end

    context 'with invalid arguments' do
      it 'will raise NoMethodError' do
        expect {
          delete :destroy, id: 'a fake ID', format: 'json'
        }.to raise_error NoMethodError
      end
    end
  end

  describe '#publish' do
    context 'with valid arguments' do
      it 'should publish an event' do
        expect {
          post :publish, id: GroupEvent.drafts.last.id, format: 'json'
        }.to change(GroupEvent.published, :count).to(11).from(10)
      end
    end

    context 'with invalid arguments' do
      it 'will raise NoMethodError' do
        expect {
          post :publish, id: 'a fake ID', format: 'json'
        }.to raise_error NoMethodError
      end
    end
  end

  describe '#unpublish' do
    context 'with valid arguments' do
      it 'should unpublish an event' do
        expect {
          post :unpublish, id: GroupEvent.published.last.id, format: 'json'
        }.to change(GroupEvent.published, :count).to(9).from(10)
      end
    end

    context 'with invalid arguments' do
      it 'will raise NoMethodError' do
        expect {
          post :unpublish, id: 'a fake ID', format: 'json'
        }.to raise_error NoMethodError
      end
    end
  end

  describe '#published' do
    it "will assig all published events to @group_events" do
      get :published, format: 'json'
      expect(assigns(:group_events)).to match_array(GroupEvent.published)
    end
  end

  describe '#drafts' do
    it "will assign all drafts to @group_events" do
      get :drafts, format: 'json'
      expect(assigns(:group_events)).to match_array(GroupEvent.drafts)
    end
  end
end
