class Foo
  local_a = 1
  local_b = 'be'
  @instance_a = 112233
  @instance_b = 'here'
  $global_a = 999
  $global_b = 'now'

  def self.bar
    %w(a b e f).sort.reverse
  end

  bar
end
