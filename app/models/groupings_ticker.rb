class GroupingsTicker < ApplicationRecord
  validates_uniqueness_of :grouping_id, scope: :ticker_id
  belongs_to  :grouping
  belongs_to  :ticker
  delegate :group, to: :grouping, prefix: false
end
