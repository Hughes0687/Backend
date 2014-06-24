class TM::Employees

  attr_reader
  attr_accessor

  def initialize()
  end


  def show_project_employees(pid)
    command = <<-SQL
      SELECT * FROM projects WHERE id='#{pid}';
    SQL
    result1 = @db.exec(command)
    params1 = result1.map {|x| x}

    command = <<-SQL
      SELECT * FROM projects_employees WHERE project_id='#{pid}';
    SQL
    result2 = @db.exec(command)
    params2 = result2.map {|x| x}

    result3 =[]
    params2.each do |x|
      command = <<-SQL
        SELECT * FROM employees WHERE id='#{x['employee_id']}';
      SQL
      result3 << @db.exec(command)
    end
    params3 = []
    result3.each do |x|
      x.each do |y|
       params3 << y 
    end
    end
      params = params1 + params3
    end

    def recruit(pid, eid)
      command = <<-SQL
        SELECT * FROM projects WHERE id='#{pid}';
      SQL
      result1 = @db.exec(command)
      params1 = result1.map {|x| x}

      command = <<-SQL
        SELECT * FROM employees WHERE id='#{eid}'
      SQL
      result2 = @db.exec(command)
      params2 = result2.map {|x| x}

      command = <<-SQL
        INSERT INTO projects_employees( project_id, employee_id )
        VALUES ( '#{pid}', '#{eid}' )
        returning *;
      SQL
      result3 = @db.exec(command)
      params3 = result3.map {|x| x}

      params = params1 + params2 + params3
    end

    def list_employees
      command = <<-SQL
        SELECT * FROM employees;
      SQL
      result = @db.exec(command)
      params = result.map {|x| x}
    end

    def create_employee(name)
      command = <<-SQL
        INSERT INTO employees( name )
        VALUES ( '#{name}' )
        returning *;
      SQL
      result = @db.exec(command)
      params = result.map {|x| x}
    end

    def employee_info(eid)
      command = <<-SQL
        SELECT * FROM employees WHERE id='#{eid}' LIMIT 1;
      SQL
      result1 = @db.exec(command)
      params1 = result1.map {|x| x}

      command = <<-SQL
        SELECT * FROM projects_employees WHERE employee_id='#{eid}';
      SQL
      result2 = @db.exec(command)
      params2 = result2.map {|x| x}

      pids = params2.map {|x| x['project_id']}
      result3 = []
      pids.each do |x|
        command = <<-SQL
          SELECT * FROM projects WHERE id='#{x}';
        SQL
        result3 << @db.exec(command)
      end
      params3 = []
      result3.each do |x|
        x.each do |y|
         params3 << y 
        end
      end

      params = params1 + params3
    end
    
    def employee_details(eid)
      command = <<-SQL
        SELECT * FROM employees WHERE id='#{eid}';
      SQL
      result1 = @db.exec(command)
      params1 = result1.map {|x| x}

      command = <<-SQL
        SELECT * FROM tasks_employees WHERE employee_id='#{eid}';
      SQL
      result2 = @db.exec(command)
      params2 = result2.map {|x| x}

      tids = params2.map {|x| x['task_id']}
      result3 = []
      tids.each do |x|
        command = <<-SQL
          SELECT * FROM tasks WHERE id='#{x}' AND complete='false';
        SQL
        result3 << @db.exec(command)
      end
      params3 = []
      result3.each do |x|
        x.each do |y|
         params3 << y 
        end
      end

      pids = params3.map {|x| x['project_id']}
      result4 = []
      pids.each do |x|
        command = <<-SQL
          SELECT * FROM projects WHERE id='#{x}';
        SQL
        result4 << @db.exec(command)
      end
      params4 = []
      result4.each do |x|
        x.each do |y|
         params4 << y 
        end
      end

      params = [params1] + [params3] + [params4]
    end

    def employee_history(eid)
      command = <<-SQL
        SELECT * FROM employees WHERE id='#{eid}';
      SQL
      result1 = @db.exec(command)
      params1 = result1.map {|x| x}

      command = <<-SQL
        SELECT * FROM tasks_employees WHERE employee_id='#{eid}';
      SQL
      result2 = @db.exec(command)
      params2 = result2.map {|x| x}

      tids = params2.map {|x| x['task_id']}
      result3 = []
      tids.each do |x|
        command = <<-SQL
          SELECT * FROM tasks WHERE id='#{x}' AND complete='true';
        SQL
        result3 << @db.exec(command)
      end
      params3 = []
      result3.each do |x|
        x.each do |y|
         params3 << y 
        end
      end

      pids = params3.map {|x| x['project_id']}
      result4 = []
      pids.each do |x|
        command = <<-SQL
          SELECT * FROM projects WHERE id='#{x}';
        SQL
        result4 << @db.exec(command)
      end
      params4 = []
      result4.each do |x|
        x.each do |y|
         params4 << y 
        end
      end

      params = [params1] + [params3] + [params4]
    end

  end

end
