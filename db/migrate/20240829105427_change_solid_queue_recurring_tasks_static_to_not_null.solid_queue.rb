# This migration comes from solid_queue (originally 20240819165045)
class ChangeSolidQueueRecurringTasksStaticToNotNull < ActiveRecord::Migration[7.1]
  def change
    change_column_null :solid_queue_recurring_tasks, :static, false, true
  end
end
