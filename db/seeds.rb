# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#@phases = ["Planning","Initial user studies","Policy-making","Collection Development","Architecture design","User interface design","Metdata collection","Classification and indexing","Services","Preservation"]
#@phases.each do |p|
 # Defaultphase.find_or_create_by_name(:name=>p)
#end

#@subphases_planning=["Identify purpose and vision statement","Establish timelines"]
#@subphases_userstudies=["Surveys","Questionnaires","Interviews","Workshops"]
#@subphases_policy_making=["","","","",""]
#@subphases_architecture=["","","","",""]
#@subphases_ui=["","","","",""]
#@subphases_metadata=["","","","",""]
#@subphases_ci=["","","","",""]
#@subphases_services=["","","","",""]
#@subphases_preservation=["","","","",""]
#@subphases_planning.each do|s|
 # Defaultphase.find_or_create_by_name(:name=>s,:parent_id=>1)
#end
#@subphases_userstudies.each do|u|
 # Defaultphase.find_or_create_by_name(:name=>u,:parent_id=>2)
#end