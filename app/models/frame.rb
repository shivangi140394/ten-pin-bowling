class Frame < ApplicationRecord
  belongs_to :game

  attribute :rolls, :integer, array: true, default: []
end
