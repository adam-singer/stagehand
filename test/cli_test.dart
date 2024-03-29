// Copyright (c) 2014, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library stagehand.cli_test;

import 'dart:async';

import 'package:stagehand/stagehand.dart';
import 'package:unittest/unittest.dart';

import '../bin/stagehand.dart';

void main() => defineTests();

void defineTests() {
  group('cli', () {
    CliApp app;
    CliLoggerMock logger;
    GeneratorTargetMock target;

    setUp(() {
      logger = new CliLoggerMock();
      target = new GeneratorTargetMock();
      app = new CliApp(generators, logger, target);
    });

    void _expectOk([_]) {
      expect(logger.getStderr(), isEmpty);
      expect(logger.getStdout(), isNot(isEmpty));
    }

    Future _expectError(Future f, [bool hasStdout = true]) {
      return f
        .then((_) => fail('error expected'))
        .catchError((e) {
          expect(logger.getStderr(), isNot(isEmpty));
          if (hasStdout) {
            expect(logger.getStdout(), isNot(isEmpty));
          } else {
            expect(logger.getStdout(), isEmpty);
          }
        });
    }

    test('no args', () {
      return app.process([]).then(_expectOk);
    });

    test('one arg', () {
      return app.process(['helloworld']).then(_expectOk);
    });

    test('one arg (bad)', () {
      return _expectError(app.process(['bad_generator']));
    });

    test('two args', () {
      return app.process(['helloworld', 'foobar']).then((_) {
        _expectOk();
        expect(target.createdCount, isPositive);
      });
    });

    test('two args (directory exists)', () {
      return _expectError(app.process(['helloworld', 'packages']), false);
    });

    test('three args', () {
      return _expectError(app.process(['helloworld', 'foobar', 'baz']));
    });
  });
}

class CliLoggerMock implements CliLogger {
  StringBuffer _stdout = new StringBuffer();
  StringBuffer _stderr = new StringBuffer();

  void stderr(String message) => _stderr.write(message);
  void stdout(String message) => _stdout.write(message);

  String getStdout() => _stdout.toString();
  String getStderr() => _stderr.toString();
}

class GeneratorTargetMock implements GeneratorTarget {
  int createdCount = 0;

  Future createFile(String path, List<int> contents) {
    expect(contents, isNot(isEmpty));
    expect(path, isNot(startsWith('/')));

    createdCount++;

    return new Future.value();
  }
}
