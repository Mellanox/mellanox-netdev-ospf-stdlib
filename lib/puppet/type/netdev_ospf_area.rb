=begin
* Puppet Module  : netdev_ospf_stdlib
* Author         : David Slama, Aviram Bar-Haim
* File           : puppet/type/netdev_ospf_area.rb
* Version        : 1.0.0
* Description    :
*
*    This file contains the Type definition for the network
*    device OSPF area interface.
*
=end

Puppet::Type.newtype(:netdev_ospf_area) do
  @doc = "Network Device OSPF Area Interface"

  ensurable

  ##### -------------------------------------------------------------
  ##### Parameters
  ##### -------------------------------------------------------------

  newparam(:name, :namevar=>true) do
    desc "The area id"
    newvalues(/^\d+$/)
  end

  ##### -------------------------------------------------------------
  ##### Properties
  ##### -------------------------------------------------------------

  newproperty(:subnets, :array_matching => :all) do
    desc "Subnets list of the form [x1.x2.x3.x4/y1, x5.x6.x7.x8/y2]"
    defaultto([])
    munge{ |v| Array(v) }
    require 'ipaddr'
    validate do |value|
      begin
        IPAddr.new value
      rescue ArgumentError
        raise "Invalid IP address #{value}"
      end
    end

    def insync?(is)
      is.sort == @should.sort.map(&:to_s)
    end

    def should_to_s( value )
      "[" + value.join(',') + "]"
    end

    def is_to_s( value )
      "[" + value.join(',') + "]"
    end

  end

  newproperty(:router_id) do
    desc "The Router OSPF associated with this area"
  end

  newproperty(:ospf_area_mode) do
    desc "The Router OSPF area mode"
    defaultto(:normal)
    newvalues(:normal, :stub, :nssa)
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

end
