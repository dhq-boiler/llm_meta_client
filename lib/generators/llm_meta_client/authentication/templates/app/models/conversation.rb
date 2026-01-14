class Conversation < ApplicationRecord
  belongs_to :user, optional: true

  validates :llm_uuid, presence: true
  validates :model, presence: true
end
