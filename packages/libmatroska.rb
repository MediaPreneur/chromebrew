require 'package'

class Libmatroska < Package
  description 'libmatroska is a C++ library to parse Matroska files, i.e., .mkv and .mka.'
  homepage 'https://matroska.org/downloads/libraries.html'
  @_ver = '1.6.3'
  version @_ver
  compatibility 'all'
  license 'BSD'
  source_url 'https://github.com/Matroska-Org/libmatroska.git'
  git_hashtag "release-#{@_ver}"

  binary_url ({
     aarch64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/libmatroska/1.6.3_armv7l/libmatroska-1.6.3-chromeos-armv7l.tpxz',
      armv7l: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/libmatroska/1.6.3_armv7l/libmatroska-1.6.3-chromeos-armv7l.tpxz',
        i686: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/libmatroska/1.6.3_i686/libmatroska-1.6.3-chromeos-i686.tpxz',
      x86_64: 'https://gitlab.com/api/v4/projects/26210301/packages/generic/libmatroska/1.6.3_x86_64/libmatroska-1.6.3-chromeos-x86_64.tpxz',
  })
  binary_sha256 ({
     aarch64: '493bf84d7725d6c68191edb1013f71d3ada24798f22973ea0eedf2e288466920',
      armv7l: '493bf84d7725d6c68191edb1013f71d3ada24798f22973ea0eedf2e288466920',
        i686: 'baa10840ab9cbc8caaec61786c40a41789e3f568825a516b9558ef0335863e95',
      x86_64: '73dc2c14ee8cc3fb785a7fae86e7a981c0b2cd236039f1bd38a068a05f8cdcfd',
  })

  depends_on 'libebml'

  def self.build
    %w[builddir-static builddir-shared].each do |dirname|
      buildshared = if dirname == 'builddir-shared' then '-DBUILD_SHARED_LIBS=YES'
                    else
                      ''
                    end
      FileUtils.mkdir dirname
      Dir.chdir dirname do
        system "cmake -G Ninja #{CREW_CMAKE_OPTIONS} \
                #{buildshared} .."
      end
      system "samu -C #{dirname}"
    end
  end

  def self.install
    %w[builddir-static builddir-shared].each do |dirname|
      system "DESTDIR=#{CREW_DEST_DIR} samu -C #{dirname} install"
    end
  end
end
