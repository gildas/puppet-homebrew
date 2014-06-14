Facter.add(:xcodeversion) do
  confine :operatingsystem => :darwin
  setcode do
    return "" if ! File.exists?('/usr/bin/xcodebuild')
    results = %x{ /usr/bin/xcodebuild -version 2>&1 }
    return "" if ! results =~ /^Xcode\s((?:\d+\.)?(?:\d+\.)?\d+)/
    $1
  end
end

