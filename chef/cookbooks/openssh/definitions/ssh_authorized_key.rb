define :ssh_authorized_key, :action => :create, :key_type => nil, :key => nil, :user => 'root', :target => nil do

    if params[:key_type].nil? or params[:key_type].empty?
        raise ArgumentError, "Missing required argument: key_type"
    end
    if params[:key].nil? or params[:key].empty?
        raise ArgumentError, "Missing required argument: key"
    end
    if params[:target].nil? or params[:target].empty?
        if params[:user].empty?
            raise ArgumentError, "Missing required argument: user"
        elsif params[:user] == 'root'
            authorized_keys = "/root/.ssh/authorized_keys"
        else
            authorized_keys = "/home/#{params[:user]}/.ssh/authorized_keys"
        end
    else
        authorized_keys = params[:target]
    end

    if params[:action] == :delete
        execute "delete_authorized_key-#{params[:name]}" do
            command "/bin/sed -i '/#{params[:key]}/d' '#{authorized_keys}'"
        end
    else
        execute "create_authorized_key-#{params[:name]}" do
            command "/bin/echo '#{params[:key_type]} #{params[:key]}' >> '#{authorized_keys}'"
            not_if "/bin/grep '#{params[:key]}' '#{authorized_keys}'"
        end
    end
end
