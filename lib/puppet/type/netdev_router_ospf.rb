=begin
* Puppet Module  : netdev_ospf_stdlib
* Author         : David Slama, Aviram Bar-Haim
* File           : puppet/type/netdev_router_ospf.rb
* Version        : 1.0.0
* Description    :
*
*    This file contains the Type definition for the network
*    device OSPF router interface.
*
=end

Puppet::Type.newtype(:netdev_router_ospf) do
  @doc = "Network Device Router OSPF"

  ensurable

  ##### -------------------------------------------------------------
  ##### Parameters
  ##### -------------------------------------------------------------

  newparam(:name, :namevar=>true) do
    desc "The router id"
  end

  ##### -------------------------------------------------------------
  ##### Auto requires
  ##### -------------------------------------------------------------

  autorequire(:netdev_device) do
    netdev = catalog.resources.select{ |r| r.type == :netdev_device }[0]
    netdev.title if netdev  # returns the name of the netdev_device resource
  end

end
