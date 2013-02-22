action :create do
  new_name = new_resource.name
  parts = new_name.split(":")
  file = if parts.count == 1
            parts.first
         else
            parts.last
         end
  directory ::File.dirname(file)  do
    recursive true
    mode "0755"
    owner "root"
    group "root"
  end

  cookbook_file file  do
    source path
    owner "root"
    group "root"
    mode "0644"
    if new_resource.postmap
      notifies :run, "postfix_postmap_hash[#{new_name}]"
    end
  end

  postfix_postmap_hash new_name if new_resource.postmap
end
