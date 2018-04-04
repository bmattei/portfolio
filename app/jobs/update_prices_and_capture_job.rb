class UpdatePricesAndCaptureJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Ticker.retrieve_prices
    AdminUser.all.each do |user|
      user.new_capture
    end
  end
end
