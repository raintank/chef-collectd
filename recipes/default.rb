packagecloud_repo node[:raintank_stack][:packagecloud_repo] do
  type "deb"
end

%w(collectd-core collectd).each do |p|
  package p do
    action :upgrade
  end
end

template "#{node["collectd"]["dir"]}/collectd.conf" do
  mode "0644"
  source "collectd.conf.erb"
  variables(
    :name         => node["collectd"]["name"],
    :fqdnlookup   => node["collectd"]["fqdnlookup"],
    :dir          => node["collectd"]["dir"],
    :interval     => node["collectd"]["interval"],
    :read_threads => node["collectd"]["read_threads"],
    :write_queue_limit_high => node["collectd"]["write_queue_limit_high"],
    :write_queue_limit_low => node["collectd"]["write_queue_limit_low"],
    :collect_internal_stats => node["collectd"]["collect_internal_stats"],
    :plugins      => node["collectd"]["plugins"]
  )
  notifies :restart, "service[collectd]"
end

include_recipe 'collectd-ng::_service'
