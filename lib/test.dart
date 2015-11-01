// Object foo(int x) {
//    final y = x + 1;
//    var z = y * 2;
//    z = "$z";
//    return z;
// }

import 'dart:collection';

void info(List<int> list) {
  var length = list.length;
  if (length != 0) print("$length ${list[0]}");
}

class MyList extends ListBase<int> implements List {
   Object length;

   MyList(this.length);

   operator[](index) => "world";
   operator[]=(index, value) {}
}

typedef int Callback();
Callback c;

void main() {
   List<int> list = new MyList("hello");
   info(list);
   c = () => 1; // no warning
   c = () { return 1; }; // warning
}
