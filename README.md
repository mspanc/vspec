# VSpec - RSpec-like testing framework for the Vala language

This project aims at creating RSpec-like testing framework for the
[Vala](http://live.gnome.org/Vala) language.

It is at early stage of development but should be sufficient for basic needs
and even now should be nicer to use than plain GLib unit tests.

It's being tested on Mac OS X and Vala 0.30.0.

Contributions are welcome!

# Sample usage

## Spec

```vala
public class AbcSuite : VSpec.Suite {
  public override void define() {
    describe("Abc", (_) => {
      string a = "abc";
      string b = "123";

      _.before(() => {
        warning("BEFORE0");
      });

      _.after(() => {
        warning("AFTER0");
      });

      _.xcontext("disabled context", (_) => {
        var q = 123;

        _.before(() => {
          warning(@"BEFORE1 $q");
        });
      });

      _.context("if something", (_) => {
        var c = 123;

        _.before(() => {
          warning("BEFORE1");
        });

        _.after(() => {
          warning("AFTER1");

        });

        _.context("even if something more", (_) => {
          _.before(() => {
            warning("BEFORE2");
          });

          _.after(() => {
            warning("AFTER2");
          });

          _.it("should do something", () => {
            warning(@":)1 $a $b");
          });

          _.xit("should do something2", () => {
            warning(@":)2 $a $b");
          });

          _.context("deep!", (_) => {
            _.it("deep task", () => {
              warning(@":))) $a $b $c");
            });
          });
        });

        _.it("shallow task", () => {
          warning(@":))]]] $a $b");
        });
      });
    });
  }
}
```

## Runner

```vala
public static int main(string[] args) {
  VSpec.add(typeof(AbcSuite));

  return VSpec.run();
}
```

# Using in your project

## Using with autotools

In order to satisfy compilation dependencies, you should add:

* `libvspec-1.0` to the pkg-config checks in `configure.ac`
* `--pkg libvspec-1.0` to the VALAFLAGS in `Makefile.am`
* appropriate LD_FLAGS and CFLAGS in `Makefile.am`

Then just create standard automake TESTS program, and launch runner like in the
example above.

# Feature status

* Basic context nesting - DONE
* Defining variables within context (equivalent to `let!`) - DONE
* Defining lazy-loaded variables within context (equivalent to `let`) - NOT STARTED
* `except` syntax - NOT STARTED
* Matchers - NOT STARTED
* Shared examples - NOT STARTED
* Different formats of console output - NOT STARTED

# License

LGPL3

# Support & bug reporting

Please use [GitHub issues](https://github.com/mspanc/vspec/issues).

# Author

Marcin Lewandowski <marcin@saepia.net>
