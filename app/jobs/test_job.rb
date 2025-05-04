class TestJob < ApplicationJob
  queue_as :default

  def perform
    puts "=== SCHEDULER BERJALAN ==="
    Rails.logger.info("Scheduler aktif! #{Time.now}")
  end
end