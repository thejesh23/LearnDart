// When a function's body is a single expression, replace `{ return ...; }`
// with `=> ...`. This "arrow" (or "fat arrow") syntax is common for tiny
// helpers, especially callbacks passed to higher-order functions.
int double_(int n) => n * 2;
bool isEven(int n) => n % 2 == 0;
String initials(String first, String last) => '${first[0]}${last[0]}';

void main() {
  print(double_(21));
  print(isEven(4));
  print(initials('Ada', 'Lovelace'));
}
