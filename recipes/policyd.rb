policyd_pkgs = %w(
    http://devlabs.linuxassist.net/attachments/download/253/cluebringer_2.1.x_201211111115_all.deb
    http://devlabs.linuxassist.net/attachments/download/260/cluebringer-webui_2.1.x_201211111115_all.deb
  )
policyd_pkgs.each do | p |
  s = "/root/#{File.basename(p)}"
  remote_file s do
    source p 
  end
  dpkg_package p do
    source s
  end
end
