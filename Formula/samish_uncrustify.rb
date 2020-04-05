# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class SamishUncrustify < Formula
  desc "Samish's version of Uncrustify"
  homepage "https://github.com/samishchandra/uncrustify"
  url "https://github.com/samishchandra/homebrew/blob/master/archive/uncrustify/uncrustify-0.70.1-306-f643d6ec.tar.gz?raw=true"
  sha256 "87f17eb75f26e34b4d3a36d1417f920e95d861d18f838f3fc0171564fb0aa420"
  head "https://github.com/samishchandra/uncrustify.git"

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    doc.install (buildpath/"documentation").children
  end

  test do
    (testpath/"t.c").write <<~EOS
      #include <stdio.h>
      int main(void) {return 0;}
    EOS
    expected = <<~EOS
      #include <stdio.h>
      int main(void) {
      \treturn 0;
      }
    EOS

    system "#{bin}/uncrustify", "-c", "#{doc}/htdocs/default.cfg", "t.c"
    assert_equal expected, File.read("#{testpath}/t.c.uncrustify")
  end
end
