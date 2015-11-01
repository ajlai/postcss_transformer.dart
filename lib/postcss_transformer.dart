library postcss_transformer;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:barback/barback.dart';

class _Configuration {
  final String executable;
  final String inputExtension;
  final String outputExtension;
  final List<String> executableArgs;

  _Configuration._({
    this.executable,
    this.inputExtension,
    this.outputExtension,
    this.executableArgs
  });

  factory _Configuration.fromConfig(Map<String,String> config) {
    var executable = config['executable'] ?? 'postcss';
    var inputExtension = config['input_extension'] ?? '.css';
    var outputExtension = config['output_extension'] ?? inputExtension;

    if (!config.containsKey('arguments')) {
      throw new ArgumentError('arguments must be provided');
    }

    var executableArgs = [];
    (config['arguments'] as Iterable<Map<String,String>>).forEach((argumentMap) {
      argumentMap.forEach((k, v) {
        executableArgs.add('--$k');
        executableArgs.add(v.toString());
      });
    });

    return new _Configuration._(
        executable: executable,
        inputExtension: inputExtension,
        outputExtension: outputExtension,
        executableArgs: executableArgs);
  }

  String toString() =>
      "<_Configuration "
      "executable:$executable "
      "inputExtension:$inputExtension "
      "outputExtension:$outputExtension>";
}

class PostcssTransformer extends Transformer implements DeclaringTransformer {
  final BarbackSettings _settings;
  final _Configuration _configuration;

  String get allowedExtensions => _configuration.inputExtension;

  PostcssTransformer.asPlugin(BarbackSettings s) :
      _settings = s,
      _configuration = new _Configuration.fromConfig(s.configuration);

  Future apply(Transform transform) async {
    var asset = transform.primaryInput;
    var process = await Process.start(_configuration.executable, _configuration.executableArgs);
    process.stdin.addStream(asset.read()).then((_) => process.stdin.close());

    var exitCode = await process.exitCode;
    if (exitCode == 0) {
      var newId = _outputId(asset.id);
      transform.addOutput(new Asset.fromStream(newId, process.stdout));
    } else {
      var command = "${_configuration.executable} ${_configuration.executableArgs.join(" ")}";
      var errorString = "Command: $command\nstderr:\n";
      errorString += await process.stderr.transform(UTF8.decoder).join("");
      transform.logger.error(errorString, asset: asset.id);
    }
  }

  void declareOutputs(DeclaringTransform transform) {
    transform.declareOutput(_outputId(transform.primaryId));
  }

  AssetId _outputId(AssetId inputId) {
    if (_configuration.inputExtension != _configuration.outputExtension) {
      return inputId.changeExtension(_configuration.outputExtension);
    } else {
      return inputId;
    }
  }
}
