class Email < ActiveRecord::Base

  attr_accessor :app, :drug
  enum status: [:queued, :sent]

  has_many :jobs, as: :owner, class_name: "::Delayed::Job", dependent: :destroy

  after_create :create_job


  protected


  def run_at
    @run_at ||= Time.now.utc
  end

  def current_mail
    self
  end

  def current_app
    self.app
  end

  def current_drug
    self.drug
  end

  def create_job
  end

end
