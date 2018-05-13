class Capture < ApplicationRecord
  has_many :snapshots
  belongs_to :admin_user
  def holdings_value
    snapshots.inject(0) {|sum, n| sum + n.value}
  end
  def total_value
    self.holdings_value + self.cash
  end
  def segment_amount(segment)
    if !segment.to_s.ends_with?('_amount')
      segment = segment.to_s + '_amount'
    end
    snapshots.inject(0) {|sum, n| sum + n.send(segment) }
  end

end
