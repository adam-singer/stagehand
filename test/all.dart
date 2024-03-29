// Copyright (c) 2014, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'cli_test.dart' as cli_test;
import 'common_test.dart' as common_test;
import 'generators_test.dart' as generators_test;

// TODO: integration tests. generate all the samples, run the analyzer over the
// dart code

void main() {
  cli_test.defineTests();
  common_test.defineTests();
  generators_test.defineTests();
}
