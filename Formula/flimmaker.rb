class Flimmaker < Formula
  desc "Create classic Macintosh FLIM movies from modern video files"
  homepage "https://github.com/fstark/macflim"
  url "https://github.com/fstark/macflim/releases/download/v2.0.18/macflim-v2.0.18.tar.gz"
  sha256 "48acfa59e4f92bab8fd9ce080493104e8977993bd2191f7581461bfc159517f4"
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
