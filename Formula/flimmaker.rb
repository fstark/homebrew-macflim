class Flimmaker < Formula
  desc "Create classic Macintosh FLIM movies from modern video files"
  homepage "https://github.com/fstark/macflim"
  url "https://github.com/fstark/macflim/releases/download/v2.0.12/macflim-v2.0.12.tar.gz"
  sha256 "72ea04a4b83a17e6ac5b98f7ebfb7747ec65d84a8ee23579be9a1c665376d8c9"
  license "MIT"

  depends_on "gcc@14" => :build
  depends_on "ffmpeg"
  depends_on "imagemagick"
  depends_on "yt-dlp"

  def install
    # Build with g++-14
    cd "src" do
      system "make", "clean"
      system "make", "release", "CPP=g++-14"
    end

    # Install the binary
    bin.install "flimmaker"
  end

  test do
    system "#{bin}/flimmaker", "--help"
  end
end
