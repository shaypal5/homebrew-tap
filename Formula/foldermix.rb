class Foldermix < Formula
  include Language::Python::Virtualenv

  desc "Pack a folder into a single LLM-friendly context file"
  homepage "https://github.com/shaypal5/foldermix"
  url "https://files.pythonhosted.org/packages/1f/48/6fd78975dbb3865beb4bdf7978de2b37de8166dfeb7f28dc2fde189b2bdc/foldermix-0.1.5.tar.gz"
  sha256 "87044d95027434b838838b48585006431812e2e5182ad12ae31830fee7c478cb"
  license "MIT"
  version "0.1.5"

  depends_on "python@3.12"

  def install
    venv = virtualenv_create(libexec, "python@3.12")
    # Do not vendor compiled sdists (like pydantic-core), which can
    # force Rust/LLVM downloads. Let pip resolve platform wheels.
    venv.pip_install_and_link buildpath
  end

  test do
    (testpath/"a.txt").write("hello\n")
    assert_match "foldermix #{version}", shell_output("#{bin}/foldermix version")
    system bin/"foldermix", "pack", testpath, "--out", "bundle.md"
    assert_predicate testpath/"bundle.md", :exist?
  end
end
