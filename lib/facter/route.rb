Facter.add("route") do
  setcode do
    Facter::Util::Resolution.exec('which route')
  end
end
