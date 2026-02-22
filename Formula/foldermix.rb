class Foldermix < Formula
  include Language::Python::Virtualenv

  desc "Pack a folder into a single LLM-friendly context file"
  homepage "https://github.com/shaypal5/foldermix"
  url "https://files.pythonhosted.org/packages/e5/32/585e8bc59d7304fd6b4d902ee2f7d9b2ffc1c65e839f5438bfe768e18b0a/foldermix-0.1.6.tar.gz"
  sha256 "6bc9f1d0fe00a3127f4fe861246d648ed12ee0233f11ed0dd5f47d0a66e7bf01"
  license "MIT"
  version "0.1.6"

  depends_on "python@3.12"

  def install
    venv = virtualenv_create(libexec, "python3.12")
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
