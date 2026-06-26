class Sonosh < Formula
  desc "Sonos TUI and CLI"
  homepage "https://github.com/shlomiuziel/sonosh"
  url "https://github.com/shlomiuziel/sonosh/archive/refs/tags/v0.3.2-sonosh.2.tar.gz"
  sha256 "2c312e1d4e3e36bd70ae3331eb856f58dbe3ea282f002c3c9224ad1713a05437"
  version "0.3.2-sonosh.2"
  license "MIT"

  depends_on "go" => :build

  resource "sonosh-helper-darwin-arm64" do
    url "https://github.com/shlomiuziel/sonosh/releases/download/v0.3.2-sonosh.2/sonosh-helper-darwin-arm64.tar.gz"
    sha256 "da579dbe48bfc948c75f397ce12498ecf68487756b80761fb8789f0656ddae21"
  end

  resource "sonosh-helper-darwin-amd64" do
    url "https://github.com/shlomiuziel/sonosh/releases/download/v0.3.2-sonosh.2/sonosh-helper-darwin-amd64.tar.gz"
    sha256 "554d4b7b2a4c36d483c0eed1371fabf6d0e2701d05e6163d566e804eea32f6e3"
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
