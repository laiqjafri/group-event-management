class GroupEvent < ActiveRecord::Base
  validates :name, presence: true
  validate  :date_order
  validates :start_date, :end_date, :location, :description, presence: true, :if => Proc.new { |group_event| group_event.is_published? }

  scope :published, -> { where is_published: true  }
  scope :drafts,    -> { where is_published: false }

  before_validation :set_duration, :if => Proc.new { |group_event| group_event.start_date.present? }

  def set_duration
    return unless [self.end_date?, self.duration].any?
    if self.end_date.blank? and self.duration.present?
      self.end_date = self.start_date + self.duration.to_i.days
    else
      self.duration = (self.end_date - self.start_date).to_i
    end
  end

  def date_order
    if self.start_date and self.end_date and self.start_date >= self.end_date
      self.errors.add(:start_date, "can't be less than or equal to end date")
    end
  end

  def publish!
    update_attributes :is_published => true
  end

  def unpublish!
    update_attributes :is_published => false
  end
end
