class Claudius < Formula
  desc "Lightweight agent orchestrator for the Claude API"
  homepage "https://github.com/tylerreckart/claudius"
  url "https://github.com/tylerreckart/claudius/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "c17e18050a3706e96b8ec61d20fbb58c85b3eca0163a05c9015fb1302bd6dbe7"
  license "MIT"
  head "https://github.com/tylerreckart/claudius.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DCMAKE_BUILD_TYPE=Release",
           "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.install "scripts/claudius-cli.sh" => "claudius-cli"
  end

  def post_install
    # Create config dir structure — don't run --init automatically
    # because it generates auth tokens that should be user-initiated
    (var/"claudius").mkpath
  end

  def caveats
    <<~EOS
      To get started:

        export ANTHROPIC_API_KEY="sk-ant-..."
        claudius --init
        claudius

      Config lives in ~/.claudius/
      Agent definitions go in ~/.claudius/agents/*.json

      To start the remote server:

        claudius --serve --port 9077
    EOS
  end

  test do
    assert_match "v0.1.0", shell_output("#{bin}/claudius --help")
  end
end
