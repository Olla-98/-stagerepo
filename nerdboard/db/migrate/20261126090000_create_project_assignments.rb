class CreateProjectAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :project_assignments do |t|
      t.references :user, null: false, foreign_key: true
      t.string :simplicate_project_id, null: false

      t.timestamps
    end

    add_index :project_assignments, [ :user_id, :simplicate_project_id ], unique: true,
      name: "index_project_assignments_on_user_and_simplicate_project"
  end
end
