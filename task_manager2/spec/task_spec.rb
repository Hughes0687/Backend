require 'spec_helper'

describe 'Task' do
  it "exists" do
    expect(TM::Task).to be_a(Class)
  end

  it "creates a task with a project id" do
  	task = TM::Task.new(7, "Crazy", 1)

  	expect(task.pid).to eq(7)
  end

  it "creates a task with a description" do
  	task = TM::Task.new(7, "Crazy", 1)

  	expect(task.description).to eq("Crazy")
  end

  it "creates a task with a priority number" do
  	task = TM::Task.new(7, "Crazy", 1)

  	expect(task.priority).to eq(1)
  end

  it "a task can be marked complete by id" do
  	task = TM::Task.new(7, "Crazy", 1)
  	TM::Task.mark_complete(task.id)

  	expect(task.status).to eq(:complete)
  end

  it "project can grab completed tasks sorted by creation date" do
    project = TM::Project.new("Stevo's Project")
    task = TM::Task.new(7, "Crazy", 1)
    TM::Task.mark_complete(task.id)
    complete_task = project.get_complete_tasks
    expect(complete_task.size).to eq(1)
  end

end
