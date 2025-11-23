class Flimmaker < Formula
  desc "Create classic Macintosh FLIM movies from modern video files"
  homepage "https://github.com/fstark/macflim"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fstark/macflim/releases/download/v3.0.0/flimmaker-arm64-macos.tar.gz"
      sha256 "3ed1e06a602ef01bf75f128f7e05299af408e7ba6153f70e9208d5832dc08c1a"
    elsif Hardware::CPU.intel?
      url "https://github.com/fstark/macflim/releases/download/v3.0.0/flimmaker-x86_64-macos.tar.gz"
      sha256 "82e927bbfa01a755777d394efc7983a07b306fea0e9602ab8ff3b46ac6a4e0b4"
    end
  end

  def install
    # Install everything to libexec to keep libraries bundled
    libexec.install "bin/flimmaker", "bin/lib"
    
    # Create wrapper script in bin that calls the binary in libexec
    # The binary's @rpath is set to @executable_path/lib, so it will find libraries correctly
    (bin/"flimmaker").write_env_script libexec/"flimmaker", {}
  end

  test do
    system "#{bin}/flimmaker", "--help"
  end
end
