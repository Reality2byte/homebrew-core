class Tombi < Formula
  desc "TOML formatter, linter and language server"
  homepage "https://github.com/tombi-toml/tombi"
  url "https://github.com/tombi-toml/tombi/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "4d97f5c740e35b99c28f382e29a3f792241bb756371c41a66b2c64f0f7ee4a0c"
  license "MIT"
  head "https://github.com/tombi-toml/tombi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c1479e22806ecbba85316da9a6e765fbb26147d2f94ba8e761ab4824bbb2d2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "032c0e1af9c5387794c2c5ec1bcdc88bf83418508909550c4a1fd25b0e4be8e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0706b75060023304505cfe457d28fb613c8232fa5af089cb157ac29767dd090"
    sha256 cellar: :any_skip_relocation, sonoma:        "a88ae2fbcb6fab533282fffcb60506b157406085f1cd6538295f1b00fc9d607c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbb47804ceab795a27e662d69232c93915d340159b4b932d1bda2051143a4ea4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34ed9ccea679fd009d4ba0a3ebadd995c9ca85c3555118fa95d9e556ed4d8ba9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/tombi-cli")
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"tombi", "lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
