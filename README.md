# ARB Merge

ARB Merge merges translation files from multiple folders of any structure and depth.
What sets this package apart from other merging packages is that it merges the content of files
based on the @@locale language code instead of using imposed file or folder naming conventions or imposed structures.
It can also take an arbitrary number of source folders by using a comma separated string of paths,
and each one of these folders will be recursed through so files can be nested to any depth.

## Background

I created this package because I couldn't find a package that supported multiple input folders (with different paths).
I have one folder with small translation files that are continuously updated and automatically translated by Google,
and I have another folder with large translation files that don't auto-translate.
So basically it was an economic incentive to develop this package because Google had started to charge me for
translating those large monolithic files

## Credits and Copyright
This package is based on the excellent [arb_glue] package by Shueh Chou Lu, but I needed some other
features so I modified his code, made some additions and created this package.


Features:

-   Supports [JSON] and [ARB] source files
-   Supports unlimited nesting, arbitrary file and folder naming convention
-   Supports unlimited* source folders
-   The translation keys of the merged files can, if so desired, be sorted alphabetically
-   Supports optional verbose output for debugging purposes

* limited by your command line's input buffer

## Installation

```shell
flutter pub add dev:arb_merge
```

Or add dependencies to `pubspec.yaml`:

```yaml
dev_dependencies:
  arb_merge: *
```

## Usage

inline command options:

`--sources`
A comma separated string with all the paths of the folders you would like to merge files from.

Example:
```shell
dart run arb_merge --sources intl_autoTranslated,intl_static,assets/manual_translations --destination lib/intl
```

`--destination`
The path of the destination folder for the merged files

`--pattern`
A string that will be used to name the created files where `{lang}` will be replaced by the language code.
Default value: `intl_{lang}.arg` which will render the file name `intl_en.arb` for english 

`--verbose` 
Setting verbose will output details on the files processed, default value: false

`--sort`
Will sort the keys in each output file alphabetically, default value: false

```shell
dart run arb_glue --
# or
flutter pub run arb_glue
```

You can also set all the options' values in your pubspec.yaml file,
and then simply run `dart run arb_merge` to run arb_merge with the values from pubspec.
Please not that any options set on the command line will then override those values.

```yaml
arb_merge:
  sources: example/primarySource,example/secondarySource
  destination: example/merged
  sort: false
  pattern: 'intl_{lang}.arb'
  verbose: false
```

## Supported formats

arb_merge supports JSON and ARB files.


[ARB]: https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification
[arb_glue]: https://github.com/evan361425/flutter-arb-glue
