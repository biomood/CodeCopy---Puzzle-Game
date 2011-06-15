module(..., package.seeall);

-- return a copy of the passed in table
function copyTable(table) 
  local copy = {}
  for k,v in pairs(table) do
  	copy[k] = v
  end
  
  return copy
end