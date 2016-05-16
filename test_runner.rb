# This continually updates test.rb with new data which will be reflected when running companion

loop do
  epoch_time = Time.now.to_i
  File.write('test_area/test.rb',
%{local_var1 = #{epoch_time}
local_varB = 'be'
@instance_var1 = #{epoch_time}
@instance_varB = 'here'
$global_var = #{epoch_time}
$global_var2 ='now'
}
            )
  sleep 1
end
