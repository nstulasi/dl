xml.instruct!  
xml.policies{
for policy in @policies
xml.policy do
xml.name(policy.name)
end
end
}