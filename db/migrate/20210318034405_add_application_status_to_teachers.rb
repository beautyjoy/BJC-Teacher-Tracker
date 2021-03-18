class AddApplicationStatusToTeachers < ActiveRecord::Migration[5.2]
  def change
    add_column :teachers, :application_status, :string
    Teacher.all.each do |t|
      if t.validated == true and t.denied == false
        t.update! application_status: "Validated"
      elsif t.validated == false and t.denied == true
        t.update! application_status: "Denied"
      else
        t.update! application_status: "Pending"
      end
    end

    remove_column :teachers, :validated
    remove_column :teachers, :denied
  end
end
