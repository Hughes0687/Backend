require 'pry-debugger'

module TM::Project

  attr_reader :name, :id, :tasks

  def initialize(name)
    @name = name
  end

  def list_projects
    command = <<-SQL
      SELECT * FROM projects;
    SQL
    result = @db.exec(command)
    params = result.map {|x| x}
    # binding.pry
    params.each do |x|
      puts "(#{x['id']}) #{x['name']}"
    end
  end

  def create_project(name)
    command = <<-SQL
      INSERT INTO projects( name )
      VALUES ( '#{name}' )
      returning *;
    SQL
    result = @db.exec(command)
    params = result.map{|x| x}
  end

  def show_completed_tasks(pid)
    command = <<-SQL
      SELECT * FROM projects WHERE id='#{pid}';
    SQL
    result1 = @db.exec(command)
    params1 = result1.map {|x| x}

    command = <<-SQL
      SELECT * FROM tasks WHERE project_id='#{pid}' AND complete='true';
    SQL
    result2 = @db.exec(command)
    params2 = result2.map {|x| x}

    params = params1 + params2
  end

  def show_project_tasks(pid)
    command = <<-SQL
      SELECT * FROM projects WHERE id='#{pid}';
    SQL
    result1 = @db.exec(command)
    params1 = result1.map {|x| x}

    command = <<-SQL
      SELECT * FROM tasks WHERE project_id='#{pid}' AND complete='false';
    SQL
    result2 = @db.exec(command)
    params2 = result2.map {|x| x}

    params = params1 + params2   
  end

  def get_incomplete_tasks
    list = []
    @tasks.each do |x|
      if x.complete == false
        list.push(x)
      end
    end
    list = list.sort {|x,y| [x.priority, x.date] <=> [y.priority, y.date]}
  end

  def self.add_task(project_id, task)
    @@projects.each do |x|
      if x.id == project_id
        x.tasks << task
      end
    end
  end
  def self.mark_complete(task_id)
    @@projects.each do |x|
      x.tasks.each do |y|
        if y.id == task_id
          y.complete = true 
        end
      end
    end
  end

end


  # def self.projects
  #   @@projects
  # end