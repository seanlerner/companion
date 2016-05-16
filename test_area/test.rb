class TestFun
  local_a = 1
  local_b = 'zoo'
  @instance_a = 'abcdef'
  @instance_b = 112233
  $global_a = 'a_world'
  $global_b = 999

  def self.letters
    %w(a b e f).sort.reverse
  end

  letters

end
