Facter.add(:xcodeversion) do
  confine :operatingsystem => :darwin
  setcode do
    if File.exists?('/usr/bin/xcodebuild')
      results = %x{ /usr/bin/xcodebuild -version 2>&1 }
      if ! results =~ /^Xcode\s((?:\d+\.)?(?:\d+\.)?\d+)/
        $1
      end
    end
  end
  
  # At least in Maverics, if you even run xcorebuild it will try to install the tools
  confine :macosx_productversion_major => "10.9"
  setcode do
    if File.exists?('/Applications/Xcode.app') or File.exists?('/Library/Developer/CommandLineTools/')
      results = %x{ /usr/bin/xcodebuild -version 2>&1 }
      if results =~ /^Xcode\s((?:\d+\.)?(?:\d+\.)?\d+)/
        $1
      end
    end
  end

end
