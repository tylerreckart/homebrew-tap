class Index < Formula
  desc "Lightweight agent orchestrator and TUI"
  homepage "https://github.com/tylerreckart/index"
  url "https://github.com/tylerreckart/index/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "b6bbef3e4987d746707313d8ba5106e91e6c241425b80e1a0856b4c9f54d5b16"
  license "CC-BY-NC 4.0"
  head "https://github.com/tylerreckart/index.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DCMAKE_BUILD_TYPE=Release",
           "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.install "scripts/index-cli.sh" => "index-cli"
  end

  def post_install
    # Create config dir structure — don't run --init automatically
    # because it generates auth tokens that should be user-initiated
    (var/"index").mkpath
  end

  def caveats
    <<~EOS
      To get started:

        export ANTHROPIC_API_KEY="sk-ant-..."
        index --init
        index

      Config lives in ~/.index/
      Agent definitions go in ~/.index/agents/*.json

      To start the remote server:

        index --serve --port 9077
    EOS
  end

  test do
    assert_match "index --init", shell_output("#{bin}/index --help")
  end
end
