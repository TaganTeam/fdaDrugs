class Scheduler < ActiveRecord::Base

  before_save :create_background_job

  serialize :task, Hash

  has_many :jobs, as: :owner, class_name: "::Delayed::Job", dependent: :destroy

  validates :day, presence: true, unless: :daily_or_every_some_minutes?

  def time
    self['time'] ||= Time.utc 2000, 1, 1, 0, 0
  end

  def frequency
    self['frequency'] ||= 'day'
  end

  def frequency= value
    self['frequency'] = value
    self.day = nil if daily?
    frequency
  end

  def daily?
    frequency == 'day'
  end

  def weekly?
    frequency == 'week'
  end

  def monthly?
    frequency == 'month'
  end

  def every_some_minutes?
    frequency == 'every_some_minutes'
  end

  def daily_or_every_some_minutes?
    ['day', 'every_some_minutes'].include?(frequency)
  end

  def parse_timeout
    task['parse_timeout'].to_i
  end

  def per_run_count
    task['per_run_count'].to_i
  end

  def next_run
    I18n.localize(jobs.last.run_at, format: '%d/%m/%Y %I:%M %P') if jobs.last
  end

  def type_formatted
    type.to_s.demodulize.titleize.humanize
  end

  def time_formatted
    I18n.localize(time, format: '%d/%m/%Y %I:%M %P')
  end

  def frequency_formatted
    case frequency
      when 'month'
        "Monthly #{day}th day #{time_formatted}"
      when 'week'
        "Weekly #{day} #{time_formatted}"
      when 'day'
        "Daily #{time_formatted}"
    end
  end

  protected

  def run_at_changed?
    time_changed? || day_changed? || frequency_changed?
  end

  def run_at
    @run_at ||= Time.now.utc
  end

  def create_background_job
  end

end
