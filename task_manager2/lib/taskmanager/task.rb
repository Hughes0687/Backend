class TM::Task

  attr_reader :project_id, :description, :priority, :id, :date
  attr_accessor :complete
  @@counter = 11111

  def initialize(project_id, description, priority)
    @project_id = project_id
    @description = description
    @priority = priority

    @date = Time.now
    @complete = false
    @id = @@counter
    @@counter += 1

    TM::Project.add_task(@project_id, self)
  end

  # def self.mark_complete(task_id)
  #   TM::Project.mark_complete(task_id)
  # end

  def create_task (pid, priority, description)
    command = <<-SQL
      INSERT INTO tasks( project_id, priority, description, complete)
      VALUES ( '#{pid}', '#{priority}', '#{description}', 'false' )
      returning *;
    SQL
    result = @db.exec(command)
    params = result.map {|x| x}
  end

  def assign_task(tid, eid)
    command = <<-SQL
      SELECT * FROM tasks WHERE id='#{tid}';
    SQL
    result1 = @db.exec(command)
    params1 = result1.map {|x| x}

    command = <<-SQL
      SELECT * FROM employees WHERE id='#{eid}'
    SQL
    result2 = @db.exec(command)
    params2 = result2.map {|x| x}

    command = <<-SQL
      INSERT INTO tasks_employees( task_id, employee_id )
      VALUES ( '#{tid}', '#{eid}' )
      returning *;
    SQL
    result3 = @db.exec(command)
    params3 = result3.map {|x| x}
    
    params = params1 + params2 + params3
  end

  def mark_task_complete(tid)
    command = <<-SQL
      UPDATE tasks SET complete = 'true' WHERE id = '#{tid}'
      returning *;
    SQL
    result = @db.exec(command)
    params = result.map {|x| x}
  end



end
