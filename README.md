[![DevOps By Rultor.com](http://www.rultor.com/b/yegor256/futex)](http://www.rultor.com/p/yegor256/futex)
[![We recommend RubyMine](http://www.elegantobjects.org/rubymine.svg)](https://www.jetbrains.com/ruby/)

[![Build Status](https://travis-ci.org/yegor256/futex.svg)](https://travis-ci.org/yegor256/futex)
[![Gem Version](https://badge.fury.io/rb/futex.svg)](http://badge.fury.io/rb/futex)
[![Maintainability](https://api.codeclimate.com/v1/badges/5528e182bb5e4a2ecc1f/maintainability)](https://codeclimate.com/github/yegor256/futex/maintainability)

Sometimes you need to synchronize your block of code, but `Mutex` is too coarse-grained,
because it _always locks_, no matter what objects your code accesses. The
`Futex` (from "file mutex") is more fine-grained and uses a file as an
entrance lock to your code.

First, install it:

```bash
$ gem install futex
```

Then, use it like this:

```ruby
require 'futex'
Futex.new('/tmp/my-file.txt').open |f|
  File.write(f, 'Hello, world!')
end
```

The file `/tmp/my-file.txt.lock` will be created and used as an entrance lock.
It will be deleted afterwards.

For better traceability you can provide a few arguments to the
constructor of the `Futex` class, including:

  * `log`: an object that implements `debug()` method, which will
    receive supplementary messages from the locking mechanism;

  * `timeout`: the number of seconds to wait for the lock availability
    (an exception is raised when the wait is expired);

  * `sleep`: the number of seconds to wait between attempts to acquire
    the lock file (the smaller the number, the more reactive is the software,
    but the higher the load for the file system and the CPU).

That's it.

# How to contribute

Read [these guidelines](https://www.yegor256.com/2014/04/15/github-guidelines.html).
Make sure you build is green before you contribute
your pull request. You will need to have [Ruby](https://www.ruby-lang.org/en/) 2.3+ and
[Bundler](https://bundler.io/) installed. Then:

```
$ bundle update
$ rake
```

If it's clean and you don't see any error messages, submit your pull request.

# License

(The MIT License)

Copyright (c) 2018 Yegor Bugayenko

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the 'Software'), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
