# frozen_string_literal: true

# (The MIT License)
#
# Copyright (c) 2018 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'minitest/autorun'
require 'tmpdir'
require 'threads'
require_relative '../lib/futex'

# Futex test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2018 Yegor Bugayenko
# License:: MIT
class FutexTest < Minitest::Test
  def test_syncs_access_to_file
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'a/b/c/file.txt')
      Threads.new(2).assert do |_, r|
        Futex.new(path, logging: true).open do |f|
          text = "op no.#{r}"
          IO.write(f, text)
          assert_equal(text, IO.read(f))
        end
      end
    end
  end

  def test_syncs_access_to_file_in_slow_motion
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'a/b/c/file.txt')
      Threads.new(20).assert(200) do |_, r|
        Futex.new(path).open do |f|
          text = "op no.#{r}"
          IO.write(f, text)
          sleep 0.01
          assert_equal(text, IO.read(f))
        end
      end
    end
  end

  # This test doesn't work and I can't fix it. If I remove the file
  # afterwards, the flock() logic gets broken. More about it here:
  # https://stackoverflow.com/questions/53011200
  def test_cleans_up_the_mess
    skip
    Dir.mktmpdir do |dir|
      Futex.new(File.join(dir, 'hey.txt')).open do |f|
        IO.write(f, 'hey')
        FileUtils.rm(f)
      end
      assert_equal(2, Dir.new(dir).count)
    end
  end
end
