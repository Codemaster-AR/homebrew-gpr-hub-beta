class GprHubBeta < Formula
  include Language::Python::Virtualenv

  desc "GPR Image Reader and AI Analyzer (Beta)"
  homepage "https://github.com/Codemaster-AR/gpr-hub-cli-beta"
  url "https://github.com/Codemaster-AR/GPR-Hub-CLI-Beta/archive/refs/tags/v6.0.0-beta.tar.gz"
  sha256 "9db928f554471c3c00fdabd0d84c571121d027863f5659939a75670579d93344"
  license "MIT"

  depends_on "python@3.12"
  depends_on "libffi"
  depends_on "openssl@3"

  def install
    # Create the virtual environment
    venv = virtualenv_create(libexec, "python3.12")

    # Explicitly install the dependencies that are missing from the environment
    # By doing this here, we ensure they are available to the script.
    venv.pip_install "requests"
    venv.pip_install "cryptography"

    # Install the actual package from the downloaded source
    venv.pip_install buildpath

    # Create the symlink for the beta command
    # This links the internal 'gpr-hub' binary to the public 'gpr-hub-beta' name
    bin.install_symlink libexec/"bin/gpr-hub" => "gpr-hub-beta"
  end

  test do
    system "#{bin}/gpr-hub-beta", "--version"
  end
end
