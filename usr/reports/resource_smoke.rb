require "json"
require "objspace"
require "timely-app"

input = JSON.generate(100.times.to_h { |number| ["field_#{number}", "fixture"] })
iterations = 10_000
GC.start
allocated_before = GC.stat(:total_allocated_objects)
heap_before = ObjectSpace.memsize_of_all
started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
cpu_started_at = Process.clock_gettime(Process::CLOCK_PROCESS_CPUTIME_ID)
iterations.times do
  JSON.parse(input, symbolize_names: true, object_class: TimelyApp::Record)
end
wall_time = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started_at
cpu_time = Process.clock_gettime(Process::CLOCK_PROCESS_CPUTIME_ID) - cpu_started_at
GC.start
puts JSON.generate(
  iterations: iterations,
  wall_seconds: wall_time.round(6),
  cpu_seconds: cpu_time.round(6),
  allocated_objects: GC.stat(:total_allocated_objects) - allocated_before,
  retained_heap_bytes: ObjectSpace.memsize_of_all - heap_before
)
