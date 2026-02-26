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
    # This helper creates a clean virtualenv in the libexec folder
    # and automatically updates pip/setuptools/wheel for you.
    venv = virtualenv_create(libexec, "python3.12")

    # Install the package and its dependencies from the build path.
    # By removing '--no-binary', it will use the pre-compiled version of 
    # cryptography, avoiding the Rust compiler error.
    venv.pip_install buildpath

    # Symlink the internal 'gpr-hub' binary to 'gpr-hub-beta' in the user's PATH
    bin.install_symlink libexec/"bin/gpr-hub" => "gpr-hub-beta"
  end

  test do
    # Verify the installation by checking the version
    system "#{bin}/gpr-hub-beta", "--version"
  end
end
