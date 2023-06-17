require 'rake/testtask'

Rake::TestTask.new("integration-tests" => :setup_coverage) do |t|
  t.test_files = FileList["test/integration_tests/test_*.rb"]
  t.verbose = true
  t.warning = false
end

Rake::TestTask.new("unit-tests" => :setup_coverage) do |t|
  t.test_files = FileList["test/unit_tests/test_*.rb"]
  t.verbose = true
  t.warning = false
end
