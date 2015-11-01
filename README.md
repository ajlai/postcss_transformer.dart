# postcss_transformer.dart

[Dart transformer](https://www.dartlang.org/tools/pub/glossary.html#transformer) wrapping [PostCSS](https://github.com/postcss/postcss).

Allows for easy hooking in of [PostCSS plugins](http://postcss.parts/) (ie autoprefixer) into the build process of a dart project.

## Requirements
Must have installed `postcss`, `postcss-cli` and postcss plugins (ie `autoprefixer`) via npm.

## Usage
Add `postcss_transformer` to dependencies and transformers in your `pubspec.yaml`:
```yaml
name: postcss_transformer_example
dependencies:
  postcss_transformer: any
transformers:
- postcss_transformer:
    arguments:
    - use: autoprefixer
    - autoprefixer.browsers: Firefox 38, Safari 9
```
See `example/` folder for what a basic dart project using postcss_transformer would look like.

## Configuration
### `arguments` (REQUIRED)
List of key-value pairs passed in as arguments to the postcss command. Use `use` key to configure which plugins run and the order they run in. You can also pass in config parameters for the plugins similar to [how they are passed in postcss-cli](https://github.com/code42day/postcss-cli#examples).

For example, the following arguments
```yaml
arguments:
  - use: autoprefixer
  - autoprefixer.browsers: > 5%
  - use: postcss-cachify
  - postcss-cachify.baseUrl: /res
```
end up turning into the command
```
postcss --use autoprefixer --autoprefixer.browsers '> 5%' \
        --use postcss-cachify --postcss-cachify.baseUrl /res
```

See postcss-cli [documentation](https://github.com/code42day/postcss-cli#usage) for more details.
### `executable` (OPTIONAL, default: `postcss`)
Path to postcss executable
### `input_extension` (OPTIONAL, default: `.css`)
extension for transformer input files
### `output_extension` (OPTIONAL)
extension for transformer output files. If not set then transformer will use `input_extension`.

## Credits
postcss_transformer was very much inspired by [autoprefixer_transformer](https://github.com/localvoid/autoprefixer_transformer) and how incredibly easy it was to set up.
