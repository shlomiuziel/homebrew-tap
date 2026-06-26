class Sonosh < Formula
  desc "Sonos TUI and CLI"
  homepage "https://github.com/shlomiuziel/sonosh"
  url "https://github.com/shlomiuziel/sonosh/archive/refs/tags/v0.3.2-sonosh.1.tar.gz"
  sha256 "3bd7c05d3f599bbc9f7f2d36eed418acfe7db2ade1b853a4833109991ade55c3"
  version "0.3.2-sonosh.1"
  license "MIT"

  depends_on "go" => :build

  resource "sonosh-helper-darwin-arm64" do
    url "https://github.com/shlomiuziel/sonosh/releases/download/v0.3.2-sonosh.1/sonosh-helper-darwin-arm64.tar.gz"
    sha256 :no_check
  end

  resource "sonosh-helper-darwin-amd64" do
    url "https://github.com/shlomiuziel/sonosh/releases/download/v0.3.2-sonosh.1/sonosh-helper-darwin-amd64.tar.gz"
    sha256 :no_check
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
