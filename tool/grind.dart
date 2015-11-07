import 'package:grinder/grinder.dart';

void main(List<String> args) {
  grind(args);
}

@Task("Analyzes the package for errors or warnings")
void analyze() {
  new PubApp.global('tuneup').run(['check']);
}

@Task("Checks that Dart code adheres to the style guide")
void lint() {
  new PubApp.global('linter').run(["./"]);
}

@Task("Runs transformer test")
void test() {
  new TestRunner().testAsync();
}

@DefaultTask()
@Depends(analyze, test, lint)
void build() {}
