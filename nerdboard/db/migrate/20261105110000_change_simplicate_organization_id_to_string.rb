class ChangeSimplicateOrganizationIdToString < ActiveRecord::Migration[8.1]
  def change
    change_column :users, :simplicate_organization_id, :string
  end
end
