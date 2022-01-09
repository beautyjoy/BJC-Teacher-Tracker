class AddApplicationStatusToTeachers < ActiveRecord::Migration[5.2]
  def change
    add_column :teachers, :application_status, :string, default: 'Pending'
    Teacher.all.each do |t|
      if t.validated and not t.denied
        t.update! application_status: 'Validated'
      elsif not t.validated and t.denied
        t.update! application_status: 'Denied'
      else
        t.update! application_status: 'Pending'
      end
    end

    remove_column :teachers, :validated, :boolean
    remove_column :teachers, :denied, :boolean
  end
end
