class Flimmaker < Formula
  desc "Create classic Macintosh FLIM movies from modern video files"
  homepage "https://github.com/fstark/macflim"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fstark/macflim/releases/download/v3.0.1/flimmaker-arm64-macos.tar.gz"
      sha256 "7f9cebb23817fad9b7e58a825c5a4bba65c006fb3d3baa124e94ebfed8c59d3c"
    elsif Hardware::CPU.intel?
      url "https://github.com/fstark/macflim/releases/download/v3.0.1/flimmaker-x86_64-macos.tar.gz"
      sha256 "8aae345cb22dc3b0cdfc154f74e938502bbb8817448d0e12f3030d8bc2bb99ae"
    end
  end

  def install
    # Install everything to libexec to keep libraries bundled
    libexec.install "flimmaker", "lib"
    
    # Create wrapper script in bin that calls the binary in libexec
    # The binary's @rpath is set to @executable_path/lib, so it will find libraries correctly
    (bin/"flimmaker").write_env_script libexec/"flimmaker", {}
  end

  test do
    system "#{bin}/flimmaker", "--help"
  end
end
