action :run do
  new_name = new_resource.name
  execute "postmap_hash_#{new_name}" do
    only_if {::File.exists?(new_name)}
    command "postmap #{new_name}"
  end
end
