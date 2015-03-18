component "gcc" do |pkg, settings, platform|
  pkg.version "4.8.2"
  pkg.md5sum "deca88241c1135e2ff9fa5486ab5957b"
  pkg.url "http://buildsources.delivery.puppetlabs.net/gcc-#{pkg.get_version}.tar.gz"

  if platform.is_deb?
    pkg.requires "libc6-dev"
  else
    pkg.build_requires "gcc"
    pkg.build_requires "gawk"
    pkg.build_requires "binutils"
    pkg.build_requires "gzip"
    pkg.build_requires "bzip2"
    pkg.build_requires "make"
    pkg.build_requires "tar"
    pkg.build_requires "libstdc++-devel"
    pkg.build_requires "glibc-devel"
    pkg.build_requires "expect"
    pkg.build_requires "dejagnu"
    pkg.build_requires "tcl"
    pkg.build_requires "gcc-c++"
    pkg.requires "glibc-devel"
  end
  pkg.requires "binutils"

  # don't require this on sles - needed for tests
  unless platform.is_sles?
    pkg.build_requires "dejagnu"
    pkg.build_requires "expect"
    pkg.build_requires "tcl"
  end

  pkg.configure do
    [
      #TODO figure out a better way to find the version number than hard-code it
      "ln -s ../gmp-4.3.2 gmp",
      "ln -s ../mpc-0.8.1 mpc",
      "ln -s ../mpfr-2.4.2 mpfr"
    ]
  end

  # We've abstracted the configure command a bit because of the difference in
  # flags needed for ARM vs x86 and x86_64
  configure_command = "../gcc-#{pkg.get_version}/configure \
   --prefix=#{settings[:prefix]} \
   --disable-nls \
   --enable-languages=c,c++ \
   --disable-libgcj --disable-shared"
  # The arm flags were taken from the Debian GCC compile options. (gcc -v)
  # The fpu, float, mode flags are all to ensure the proper floating point
  # type (which is hard) on ARM.
  # The other flags are to instruct GCC on the proper target to look at in
  # libgcc when linking.
  if  platform.architecture =~ /arm/i
    configure_command << " --with-arch=armv7-a \
    --with-fpu=vfpv3-d16 \
    --with-float=hard \
    --with-mode=thumb \
    --build=arm-linux-gnueabihf \
    --host=arm-linux-gnueabihf \
    --target=arm-linux-gnueabihf"
  end

  pkg.build do
    # We set -fPIC to ensure that our 64 bit builds can correctly link and compile.
    # We enable it on both 32-bit and 64-bit builds for consistency.
    [ 'export CFLAGS="${CFLAGS} -fPIC"',
      'export CXXFLAGS="${CXXFLAGS} -fPIC"',
      'export CFLAGS_FOR_TARGET="-fPIC"',
      'rm -rf ../obj-gcc-build-dir',
      'mkdir ../obj-gcc-build-dir',
      'cd ../obj-gcc-build-dir',
      configure_command,
      "#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"
    ]
  end

  pkg.install do
    [ "cd ../obj-gcc-build-dir",
      "#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install"
    ]
  end
end
