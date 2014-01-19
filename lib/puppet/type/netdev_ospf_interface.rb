=begin
* Puppet Module  : netdev_ospf_stdlib
* Author         : David Slama, Aviram Bar-Haim
* File           : puppet/type/netdev_ospf_interface.rb
* Version        : 1.0.0
* Description    :
*
*    This file contains the Type definition for the network
*    device OSPF interface.
*
=end

Puppet::Type.newtype(:netdev_ospf_interface) do
  @doc = "Network Device OSPF Interface"

  ensurable

  ##### -------------------------------------------------------------
  ##### Parameters
  ##### -------------------------------------------------------------

  newparam(:name, :namevar=>true) do
    desc "The OSPF interface name"
  end

  ##### -------------------------------------------------------------
  ##### Properties
  ##### -------------------------------------------------------------

  newproperty(:area_id) do
    desc "The OSPF interface associated area number"
    newvalues(/^\d+$/)
  end

  newproperty(:type) do
    desc "The OSPF interface network type"
    defaultto("broadcast")
    newvalues("broadcast", "point_to_point", "nbma", "pointToMultipoint")
  end

  ##### -------------------------------------------------------------
  ##### Auto requires
  ##### -------------------------------------------------------------

  autorequire(:netdev_device) do
    netdev = catalog.resources.select{ |r| r.type == :netdev_device }[0]
    netdev.title if netdev  # returns the name of the netdev_device resource
  end

  autorequire(:netdev_router_ospf) do
    routers = catalog.resources.select{ |r| r.type == :netdev_router_ospf }
    notice("No netdev_router found in catalog") if routers.empty?
    ['default']
  end

  autorequire(:netdev_l3_interface) do
    self[:name]
  end

end
