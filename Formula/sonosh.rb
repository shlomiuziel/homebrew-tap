class Sonosh < Formula
  desc "Sonos TUI and CLI"
  homepage "https://github.com/shlomiuziel/sonosh"
  url "https://github.com/shlomiuziel/sonosh/archive/refs/tags/v0.3.2-sonosh.2.tar.gz"
  sha256 "39fcee42976e69b3fe8878c349c5c8524be19a86f1cb22d485b2c00c4a1d048f"
  version "0.3.2-sonosh.2"
  license "MIT"

  depends_on "go" => :build

  resource "sonosh-helper-darwin-arm64" do
    url "https://github.com/shlomiuziel/sonosh/releases/download/v0.3.2-sonosh.2/sonosh-helper-darwin-arm64.tar.gz"
    sha256 "b5cd22c7ab61b07874df926b59431569bb0eeffd29f7d6377803b91e57870fb0"
  end

  resource "sonosh-helper-darwin-amd64" do
    url "https://github.com/shlomiuziel/sonosh/releases/download/v0.3.2-sonosh.2/sonosh-helper-darwin-amd64.tar.gz"
    sha256 "14eac6b0d140f37d2c31db33d411d171e68ac99319b413466047ed00491dd9b6"
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
