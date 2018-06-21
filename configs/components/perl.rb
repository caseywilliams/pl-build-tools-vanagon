component "perl" do |pkg, settings, platform|
  pkg.version "5.26.2"
  pkg.md5sum "dc0fea097f3992a8cd53f8ac0810d523"
  pkg.url "https://www.cpan.org/src/5.0/perl-#{pkg.get_version}.tar.gz"
  pkg.mirror "https://artifactory.delivery.puppetlabs.net/artifactory/generic__buildsources/buildsources/perl-#{pkg.get_version}.tar.gz"

  if platform.name =~ /ubuntu-16.04-ppc64el/
    pkg.build_requires "pl-binutils"
  end

  if platform.is_windows?
    arch = platform.architecture == "x64" ? "64" : "32"
    pkg.environment "PATH", "$(PATH):C:/tools/mingw#{arch}/bin"
    pkg.environment "CYGWIN", "nodosfilewarning winsymlinks:native"
    pkg.environment "LIB", "C:/tools/mingw#{arch}/lib"
    pkg.environment "INCLUDE", "C:/tools/mingw#{arch}/include"
    pkg.environment "CC", "C:/tools/mingw#{arch}/bin/gcc"
    # pkg.environment "CXX", "C:/tools/mingw#{arch}/bin/g++"
    platform.make = "/usr/bin/make"
  elsif platform.is_solaris?
    if platform.os_version == "10"
      pkg.build_requires "http://pl-build-tools.delivery.puppetlabs.net/solaris/10/pl-gcc-4.8.2-8.#{platform.architecture}.pkg.gz"
      pkg.build_requires "http://pl-build-tools.delivery.puppetlabs.net/solaris/10/pl-binutils-2.27-1.#{platform.architecture}.pkg.gz"
    elsif platform.os_version == "11"
      pkg.build_requires "pl-binutils-#{platform.architecture}"
      pkg.build_requires "pl-gcc-#{platform.architecture}"
    end
  end

  pkg.configure do
    [ "sh Configure -de -Dprefix=#{settings[:prefix]}" ]
  end

  pkg.build do
    [ platform[:make] ]
  end

  pkg.install do
    [ "#{platform[:make]} install" ]
  end
end
