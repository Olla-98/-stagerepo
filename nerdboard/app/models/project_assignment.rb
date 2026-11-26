class ProjectAssignment < ApplicationRecord
  belongs_to :user

  validates :simplicate_project_id, presence: true
  validates :simplicate_project_id, uniqueness: { scope: :user_id }
end
