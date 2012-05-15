module PhasesHelper
def nested_set_options
  @phases = Phase.all
  @p=[]
  @phases.each do |p|
     @p<<p.name
  end
  return @p
end
end
