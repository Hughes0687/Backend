class TM::Client
  def initialize
  end

  def start
    puts "Welcome to Project Manager Lite"
    help
    client
  end

  private
  def help
    puts "Available Commands:"
    puts "  help - Show these commands again"
    puts "  project list - List all projects"
    puts "  project create NAME - Create a new project"
    puts "  project show PID - Show remaining tasks for project PID"
    puts "  project history PID - Show completed tasks for project PID"
    puts "  project employees PID - Show employees participating in this project"
    puts "  project recruit PID EID - Adds employee EID to participate in project PID"
    puts "  task create PID PRIORITY DESC - Add a new task to project PID"
    puts "  task assign TID EID - Assign task to employee"
    puts "  task mark TID - Mark task TID as complete"
    puts "  emp list - List all employees"
    puts "  emp create NAME - Create a new employee"
    puts "  emp show EID - Show employee EID and all participating projects"
    puts "  emp details EID - Show all remaining tasks assigned to employee EID, along"
    puts "                    with the project name next to each task"
    puts "  emp history EID - Show completed tasks for employee with id=EID"
  end

  def client
    print ">>"
    input = gets.chomp
    args = split_input(input)
    action(args)
  end

  def split_input(input)
    args = input.split(' ')

    return ["help", nil] if args[0] == "help"

    if args[0] == "task" && args[1] == "create"
      desc = [args[4..-1].join(" ")]
      array = args[0..3] + desc
      return array
    end

    if args[1] == "create"
      name = [args[2..-1].join(" ")]
      array = args[0..1] + name
      return array
    end

    return args
  end


  def action(args)
    case args[0]
    when "help"
      help
      client
    when "project"
      case args[1]
      when "list"
        puts "--Projects List--"
        puts "(PID) Project Name"
        params = TM::Project.list_projects
        client
      when "create"
        params = TM.db.create_project(args[2])
        puts "--Project Created--"
        puts "Project ID: #{params[0]['id']}"
        puts "Project Name: #{params[0]['name']}"
        client
      when "show"
        params = TM.db.show_project_tasks(args[2])
        project = params.shift
        puts "--Remaining Task for #{project['name']} (PID: #{project['id']})--"
        puts "(TID) (PID) Description (Priority)"
        params.each do |x|
          puts "(#{x['id']}) (#{x['project_id']}) #{x['description']} (#{x['priority']})"
        end
        client
      when "history"
        params = TM.db.show_completed_tasks(args[2])
        project = params.shift
        puts "--Completed Task for #{project['name']} (PID: #{project['id']})--"
        puts "(TID) (PID) Description (Priority)"
        params.each do |x|
          puts "(#{x['id']}) (#{x['project_id']}) #{x['description']} (#{x['priority']})"
        end
        client
      when "employees"
        params = TM.db.show_project_employees(args[2])
        project = params.shift
        puts "--Employees on #{project['name']} (PID: #{project['id']})--"
        puts "(EID) Employee Name"
        params.each do |x|
          puts "(#{x['id']}) #{x['name']}"
        end
        client
      when "recruit"
        params = TM.db.recruit(args[2], args[3])
        puts "Employee: #{params[1]['name']} (EID: #{params[1]['id']}) added to Project: #{params[0]['name']} (PID: #{params[0]['id']})"
        client
      else
        puts "Not a valid project input"
        client
      end
    when "task"
      case args[1]
      when "create"
        param = TM.db.create_task(args[2], args[3], args[4])
        puts "--Task Created--"
        puts "Task ID: #{param[0]['id']}"
        puts "Project ID: #{param[0]['project_id']}"
        puts "Description: #{param[0]['description']}"
        puts "Priority: #{param[0]['priority']}"
        client
      when "assign"
        params = TM.db.assign_task(args[2], args[3])
        puts "Task: #{params[0]['description']} (TID: #{params[0]['id']}) assigned to Employee: #{params[1]['name']} (EID: #{params[1]['id']})"
        client
      when "mark"
        params = TM.db.mark_task_complete(args[2])
        puts "Task: #{params[0]['description']} (TID: #{params[0]['id']}) marked as COMPLETE"
        client
      else 
        puts "Not a valid task input"
        client
      end
    when "emp"
      case args[1]
      when "list"
        params = TM.db.list_employees
        puts "--Employee List--"
        puts "(ID) Employee Name"
        params.each do |x|
          puts "(#{x['id']}) #{x['name']}"
        end
        client
      when "create"
        params = TM.db.create_employee(args[2])
        puts "--Employee Created--"
        puts "Employee ID: #{params[0]['id']}"
        puts "Employee Name: #{params[0]['name']}"
        client
      when "show"
        params = TM.db.employee_info(args[2])
        employee = params.shift
        puts "--Employee: #{employee['name']} (EID: #{employee['id']}) projects--"
        puts "(PID) Project Name"
        params.each do |x|
          puts "(#{x['id']}) #{x['name']}"
        end
        client
      when "details"
        params = TM.db.employee_details(args[2])
        projects = params.pop
        tasks = params.pop
        employee = params.pop
        puts "--Remaining Tasks for Employee: #{employee[0]['name']} (EID: #{employee[0]['id']})--"
        puts "(TID) Task Description (Priority) | (PID) Project Name"
        tasks.each_index do |x|
          puts "(#{tasks[x]['id']}) #{tasks[x]['description']} (#{tasks[x]['priority']}) | (#{projects[x]['id']}) #{projects[x]['name']}"
        end
        client
      when "history"
        params = TM.db.employee_history(args[2])
        projects = params.pop
        tasks = params.pop
        employee = params.pop
        puts "--Completed Tasks for Employee: #{employee[0]['name']} (EID: #{employee[0]['id']})--"
        puts "(TID) Task Description (Priority) | (PID) Project Name"
        tasks.each_index do |x|
          puts "(#{tasks[x]['id']}) #{tasks[x]['description']} (#{tasks[x]['priority']}) | (#{projects[x]['id']}) #{projects[x]['name']}"
        end
        client
      else 
        puts "Not a valid emp input"
        client
      end
    when "exit" 
      puts "Good-bye"
      return
    when "quit"
      puts "Good-bye"
      return
    else
      puts "Not a valid input"
      client
    end
  end

end

TM::Client.new.start
