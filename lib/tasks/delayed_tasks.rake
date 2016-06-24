# class DelayedRakeTask
#   def initialize(task_name)
#     @task_name = task_name
#   end
#
#   def perform
#     Rake::Task[@task_name].invoke
#   end
# end
#
# namespace :job do
#
#   namespace :async do
#     Delayed::Job.enqueue DelayedRakeTask.new('job:parse_drug_details')
#   end
#
# end
