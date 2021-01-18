# Copyright 2020 Gregg Reynolds. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

OpamPkgInfo = provider(
    doc = "Provider for OPAM packages.",
    fields = {
        ## clients must write: dep[OpamPkgInfo].pkg.to_list()[0].name
        ## FIXME: make pkg contain just the label? no need for a depset.
        "pkg": "Label depset containing package name string used by ocamlfind.",
        "ppx_driver": "True if ocamlfind would generate -ppx command line arg when this lib is listed as a dep."
    }
)

OpamConfig = provider(
    doc = """OPAM configuration structure.

Example:

```
opam = OpamConfig(
    version = "2.0",
    switches  = {
        "mina-0.1.0": OpamSwitch(
            default  = True,
            compiler = "4.07.1",
            packages = PACKAGES
        ),
        "4.07.1": OpamSwitch(
            compiler = "4.07.1",
            packages = PACKAGES
        ),
    }
)
```
""",

    fields = {
        "version"  : "OPAM version",
        "switches" : "Dictionary from switch name strings to [OpamSwitch](#opamswitch) provider structs."
    }
)

################################################################
OpamSwitch = provider(
    doc = """OPAM switch configuration.

The `packages` parameter maps package names to package specifictions.
All package dependencies must be listed. Package specification
grammar:

```
      [<version>]
    | [<version>, [<subpkg> {, <subpkg>}*]]
    | [<version>, <path>]
    | [<version>, <url>]

where:
<versionstring>  := version string as printed by `opam list`
<subpkg>         := subpackage name string as listed by `ocamlfind list`
<path>           := string, path to implementation code
<url>            := HTTPS URL of implementation code
```

Package and subpackage names must match the name listed by `opam list`
or `ocamlfind list`. Some packages are listed by `ocamlfind list`, but
not by `opam list`.  Subpackages are listed only by `ocamlfind list`.

**Version strings**: for packages that are distributed with the
compiler and have no version string, use the empty list `[]` for the
version string; e.g. `"bytes": []`. To allow any version, use the
empty list or the empty string (required if there is a subpackage).  E.g.

```
        "lwt": ["", ["lwt.unix"]]
```

**Example**:

```
OpamSwitch(
    default  = True,
    compiler = "4.07.1",
    packages = {
        "async": ["v0.12.0"],
        "bytes": [], # not listed by `opam`; `ocamlfind` reports "distributed with OCaml"
        "core": ["v0.12.1"],
        "ctypes": ["0.17.1", ["ctypes.foreign", "ctypes.stubs"]],
        "ppx_deriving": ["4.4.1", [
            "ppx_deriving.eq",
            "ppx_deriving.show"
        ]],
        "ppx_deriving_yojson": ["3.5.2", ["ppx_deriving_yojson.runtime"]],
    }
)
```
    """,

    fields = {
        "default"  : "Must be True for exactly one switch configuration. Default: False",
        "compiler" : "OCaml compiler version",
        "packages" : "Dictionary mapping package names to package specs."
    }
)
