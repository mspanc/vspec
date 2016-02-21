# VSpec

## RSpec-like testing framework for the Vala language

This project aims at creating RSpec-like testing framework for the
[Vala](http://live.gnome.org/Vala) language.

It is at early stage of development but should be sufficient for basic needs
and even now should be nicer to use than plain GLib unit tests.

It's being tested on Mac OS X and Vala 0.30.0.

Contributions are welcome!

# Sample usage

## Spec

```vala
public class AbcSpec : VSpec.Spec {
  public override void define() {
    before_each(() => {
      // Before each in that spec
    });

    after_each(() => {
      // After each in that spec
    });

    describe(".something", () => {
      // Equivalent to let in RSpec
      this["lazyvar"] = () => { return "original"; };

      context("if something happened", () => {
        // Test cases will have access to the closest let
        this["lazyvar"] = () => { return "overriden"; };

        before_each(() => {
          // Before each in that context
        });

        after_each(() => {
          // After each in that context
        });

        xit("should do whatever", () => {
          // I am pending spec
        });

        it("should ensure that let is working", () => {
          assert(str_equal(this["lazyvar"]().get_string(), "overriden"));
        });

        it("should fail because of invalid var name", () => {
          assert(str_equal(this["lazyvar-invalid"]().get_string(), "def"));
        });
      });

      it("should throw an arror and keep runner running", () => {
        throw new ThreadError.AGAIN("Abc");
      });

      // Pending context
      xcontext("if something happened", () => {
        it("should print variables ", () => {
          // I won't be called as parent context is pending
        });
      });
    });
  }
}
```


## Runner

```vala
public static int main(string[] args) {
  VSpec.add(typeof(AbcSpec));

  VSpec.before_all(() => {
    // Do something before running all specs
  });

  VSpec.after_all(() => {
    // Do something after running all specs
  });

  VSpec.before_each(() => {
    // Do something before each spec
  });

  VSpec.after_each(() => {
    // Do something after each spec
  });


  VSpec.verbose = true; // Print output of all GLib logging functions

  return VSpec.run();
}
```

## Output

![Report](/docs/report.png?raw=true "Report")


# Debugging

If you set VSPEC_DEBUG environment variable, VSpec will output additional
messages that can be useful while debugging.


# Compiling

## Ubuntu/Debian

In Ubuntu/Debian the best way is to create .deb package. You can do this in the
following way (tested on Ubuntu 15.10):

* Install devscripts & equivs: `sudo apt-get install devscripts equivs`
* Install build dependencies: `sudo mk-build-deps -i -r debian/control`
* Build the package `sudo debuild`

## Other systems

Ensure that automake, C compiler, valac, GLib development library are installed.

* Run `./configure`
* Run `make`
* Run `sudo make install`


# Using in your project

## Using with the autotools

In order to satisfy compilation dependencies, you should add:

* `libvspec-1.0` to the pkg-config checks in `configure.ac`
* `--pkg libvspec-1.0` to the VALAFLAGS in `Makefile.am`
* appropriate LD_FLAGS and CFLAGS in `Makefile.am`

Then just create standard automake TESTS program, and launch runner like in the
example above.


# Feature status

* Basic context nesting - DONE
* Defining variables within context (equivalent to `let!`) - NOT STARTED
* Reporting to the console output - DONE
* Defining lazy-loaded variables within context (equivalent to `let`) - IN PROGRESS (value is not cached)
* `expect` syntax - NOT STARTED
* Matchers - NOT STARTED
* Shared examples - NOT STARTED
* Filtering specs in the runner - NOT STARTED
* Verbose output of the failed specs - NOT STARTED

# License

LGPL3


# Support & bug reporting

Please use [GitHub issues](https://github.com/mspanc/vspec/issues).


# Author

Marcin Lewandowski <marcin@saepia.net>
