class Sonosh < Formula
  desc "Sonos TUI and CLI"
  homepage "https://github.com/shlomiuziel/sonosh"
  url "https://github.com/shlomiuziel/sonosh/archive/refs/tags/v0.3.2-sonosh.3.tar.gz"
  sha256 "b25dec60bab29d0d3106e5f9d32b25185802f39c8e68744a89bf06271c3b0cea"
  version "0.3.2-sonosh.3"
  license "MIT"

  depends_on "go" => :build

  resource "sonosh-helper-darwin-arm64" do
    url "https://github.com/shlomiuziel/sonosh/releases/download/v0.3.2-sonosh.3/sonosh-helper-darwin-arm64.tar.gz"
    sha256 "989f6e8204b336fb9cdcdea5d038d44834d03ebea40d8a839d3db27afa6acd12"
  end

  resource "sonosh-helper-darwin-amd64" do
    url "https://github.com/shlomiuziel/sonosh/releases/download/v0.3.2-sonosh.3/sonosh-helper-darwin-amd64.tar.gz"
    sha256 "6880cfe63e41a5c060ca42c5a5832becb7e12dc138668c331cf715b7125b0b10"
  end

  def install
    sonosh_bin = libexec/"sonosh"
    system "go", "build", "-o", sonosh_bin, "./cmd/sonosh"

    if OS.mac?
      helper_resource = Hardware::CPU.arm? ? "sonosh-helper-darwin-arm64" : "sonosh-helper-darwin-amd64"
      resource(helper_resource).stage do
        libexec.install "sonosh-macos-helper"
      end
    end

    (bin/"sonosh").write <<~EOS
      #!/bin/bash
      HELPER="#{libexec}/sonosh-macos-helper"
      if [ -x "$HELPER" ]; then
        export SONOSH_MAC_HELPER="$HELPER"
      fi
      exec "#{sonosh_bin}" "$@"
    EOS
    chmod 0755, bin/"sonosh"
  end
end
