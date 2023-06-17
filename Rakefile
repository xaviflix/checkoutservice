require 'rake/testtask'

Rake::TestTask.new(:unit_test) do |task|
  task.pattern = "test/unit_tests/**/*_test.rb"
  task.verbose = true
  task.warning = false
end

Rake::TestTask.new(:integration_test) do |task|
  task.pattern = "test/integration_tests/**/*_test.rb"
  task.verbose = true
  task.warning = false
end

Rake::TestTask.new(:all_test) do |task|
  task.pattern = "test/**/**/*_test.rb"
  task.verbose = true
  task.warning = false
end

Rake::TestTask.new(:single_test) do |task|
  task.verbose = true
  task.warning = false
end

