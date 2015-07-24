class Api::GroupEventsController < ApplicationController
  before_action :set_group_event, :only => [:show, :update, :destroy, :publish, :unpublish]

  def index
    @group_events = GroupEvent.all # Not using pagination for now
    respond_to do |format|
      format.json { render json: @group_events }
    end
  end

  def show
    respond_to do |format|
      if @group_event
        format.json { render json: @group_event }
      else
        format.json { render json: nil, status: :not_found }
      end
    end
  end

  def create
    @group_event = GroupEvent.new group_event_params
    respond_to do |format|
      if @group_event.save
        format.json { render json: @group_event, status: :created }
      else
        format.json { render json: @group_event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @group_event.update_attributes group_event_params
        format.json { render json: @group_event, status: :ok }
      else
        format.json { render json: @group_event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @group_event.destroy
        format.json { head :no_content, status: :ok }
      else
        format.json { render json: @group_event.errors, status: :unprocessable_entity }
      end
    end
  end

  def publish
    respond_to do |format|
      if @group_event.publish!
        format.json { render json: @group_event, status: :ok }
      else
        format.json { render json: @group_event.errors, status: :unprocessable_entity }
      end
    end
  end

  def unpublish
    respond_to do |format|
      if @group_event.unpublish!
        format.json { render json: @group_event, status: :ok }
      else
        format.json { render json: @group_event.errors, status: :unprocessable_entity }
      end
    end
  end

  def published
    @group_events = GroupEvent.published
    respond_to do |format|
      format.json { render json: @group_events }
    end
  end

  def drafts
    @group_events = GroupEvent.drafts
    respond_to do |format|
      format.json { render json: @group_events }
    end
  end

  private

  def set_group_event
    @group_event = GroupEvent.find_by id: params[:id]
  end

  def group_event_params
    params.require(:group_event).permit(:name, :description, :location, :start_date, :end_date, :duration, :is_published)
  end
end
