define :add_apt_repo, :url => nil do
  if platform?("debian", "ubuntu") then
    package "python-software-properties"

    if params[:url].nil? then
      raise ArgumentError, "Missing PPA URL"
    end

    execute "add-apt-repository" do
      command "add-apt-repository #{params[:url]}"
      notifies :run, "execute[aptitude_update]", :immediately
    end
  end
end
