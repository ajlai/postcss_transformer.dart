library postcss_transformer.test.code_transformers_test.dart;

import 'package:test/test.dart';
import 'package:postcss_transformer/postcss_transformer.dart';
import 'package:barback/barback.dart';
import 'package:code_transformers/tests.dart' as code_transformers;

void main() {
  void testTransform(String testName, {
      Map configuration,
      Map<String, String> inputs,
      Map<String, String> results}) {
    PostcssTransformer transformer = new PostcssTransformer.asPlugin(
        new BarbackSettings(configuration, BarbackMode.DEBUG));
    code_transformers.testPhases(testName, [[transformer]], inputs, results);
  }

  group("autoprefixer", () {
    String inputContent = ":fullscreen a { display: flex }";
    String outputContent = ":-webkit-full-screen a { display: flex }\n:-moz-full-screen a { display: flex }\n:fullscreen a { display: flex }";

    testTransform("autoprefixer works, defaulting to transforming .css files only",
      configuration: {
        "arguments": [
          {"use": "autoprefixer"},
          {"autoprefixer.browsers": "Firefox 38, Safari 9"}
        ]
      },
      inputs: {
        "postcss_transformer_test|lib/styles.css": inputContent
      },
      results: {
        "postcss_transformer_test|lib/styles.css": outputContent
      });

    testTransform("non .css files are ignored when no input_extension is provided",
        configuration: {
          "arguments": [
            {"use": "autoprefixer"},
            {"autoprefixer.browsers": "Firefox 38, Safari 9"}
          ],
        },
        inputs: {
          "postcss_transformer_test|lib/ignored.abc": inputContent
        },
        results: {
          "postcss_transformer_test|lib/ignored.abc": inputContent
        });

    testTransform(".css files are ignored when non .css input_extension is provided",
        configuration: {
          "arguments": [
            {"use": "autoprefixer"},
            {"autoprefixer.browsers": "Firefox 38, Safari 9"}
          ],
          "input_extension": ".abc"
        },
        inputs: {
          "postcss_transformer_test|lib/ignored.css": inputContent
        },
        results: {
          "postcss_transformer_test|lib/ignored.css": inputContent
        });

    testTransform("output_extension matches input_extension when only input_extension is provided",
        configuration: {
          "arguments": [
            {"use": "autoprefixer"},
            {"autoprefixer.browsers": "Firefox 38, Safari 9"}
          ],
          "input_extension": ".abc"
        },
        inputs: {
          "postcss_transformer_test|lib/styles.abc": inputContent
        },
        results: {
          "postcss_transformer_test|lib/styles.abc": outputContent
        });

    testTransform("outputExtension is respected",
        configuration: {
          "arguments": [
            {"use": "autoprefixer"},
            {"autoprefixer.browsers": "Firefox 38, Safari 9"}
          ],
          "input_extension": ".abc",
          "output_extension": ".def"
        },
        inputs: {
          "postcss_transformer_test|lib/styles.abc": inputContent
        },
        results: {
          "postcss_transformer_test|lib/styles.def": outputContent
        });
  });
}
